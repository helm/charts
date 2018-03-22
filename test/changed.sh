#!/bin/bash
# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace
shopt -s nullglob

git remote add k8s https://github.com/kubernetes/charts
git fetch k8s master

readonly NAMESPACE="${JOB_TYPE}-${PULL_INFO}-${BUILD_ID}"
readonly CHANGED_FOLDERS=$(git diff --find-renames --name-only "$(git merge-base k8s/master HEAD)" stable/ incubator/ | awk -F/ '{ print $1"/"$2 }' | uniq)

# Exit early if no charts have changed
if [[ -z "$CHANGED_FOLDERS" ]]; then
    exit 0
fi

# include the semvercompare function
readonly CURRENT_DIR="$(dirname "$0")"
source "$CURRENT_DIR/semvercompare.sh"

release_index=1
exitCode=0
current_release=""

# Cleanup any releases and namespaces left over from the test
cleanup_release() {
    if [[ -n "$current_release" ]]; then

        # Before reporting the logs from all pods provide a helm status for
        # the release
        helm status "${current_release}" || true

        # List all logs for all containers in all pods for the namespace which was
        # created for this PR test run
        kubectl get pods --show-all --no-headers --namespace "$NAMESPACE" | awk '{ print $1 }' | while read -r pod; do
            if [[ -n "$pod" ]]; then
                printf '===Details from pod %s:===\n' "$pod"

                printf '...Description of pod %s:...\n' "$pod"
                kubectl describe pod --namespace "$NAMESPACE" "$pod" || true
                printf '...End of description for pod %s...\n\n' "$pod"

                # There can be multiple containers within a pod. We need to iterate
                # over each of those
                containers=$(kubectl get pods --show-all -o jsonpath="{.spec.containers[*].name}" --namespace "$NAMESPACE" "$pod")
                for container in $containers; do
                    printf -- '---Logs from container %s in pod %s:---\n' "$container" "$pod"
                    kubectl logs --namespace "$NAMESPACE" -c "$container" "$pod" || true
                    printf -- '---End of logs for container %s in pod %s---\n\n' "$container" "$pod"
                done

                printf '===End of details for pod %s===\n' "$pod"
            fi
        done

        helm delete --purge "$current_release" > cleanup_log 2>&1 || true
    fi
}

# Cleanup any namespace left over from the test
cleanup_namespace() {
    kubectl delete ns "$NAMESPACE" >> cleanup_log 2>&1 || true
}

trap 'cleanup_release; cleanup_namespace' EXIT

dosemvercompare() {
    # Note, the trap and automatic exiting are disabled for the semver comparison
    # because it catches its own errors. If the comparison fails exitCode is set
    # to 1. So, trapping and exiting is re-enabled and then the exit is handled
    trap - EXIT
    set +e
    semvercompare "$1"
    trap 'cleanup_release; cleanup_namespace' EXIT
    set -e
    if [[ "$exitCode" == 1 ]]; then
        exit 1
    fi
}

test_release() {
    values_file="${1:-}"
    current_release="$release_name-$release_index"
    release_index=$((release_index + 1))

    if [[ -n "$values_file" ]]; then
        echo "Testing chart with values file: $values_file..."
        helm install --timeout 600 --name "$current_release" --namespace "$NAMESPACE" --values "$values_file" . | tee install_output
    else
        echo "Chart does not provide test values. Testing chart with defaults..."
        helm install --timeout 600 --name "$current_release" --namespace "$NAMESPACE" . | tee install_output
    fi

    "$CURRENT_DIR/verify-release.sh" "$NAMESPACE"

    kubectl get pods --namespace "$NAMESPACE"
    kubectl get svc --namespace "$NAMESPACE"
    kubectl get deployments --namespace "$NAMESPACE"
    kubectl get endpoints --namespace "$NAMESPACE"

    helm test "$current_release"

    if [[ -n "${VERIFICATION_PAUSE:-}" ]]; then
        cat install_output
        sleep "$VERIFICATION_PAUSE"
    fi

    cleanup_release

    # Setting the current release to none to avoid the cleanup and error
    # handling for a release that no longer exists.
    current_release=""
}

if [ ! -f "${KUBECONFIG:=}" ];then
    # Get credentials for test cluster
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a
fi

# Install and initialize helm/tiller
readonly HELM_URL=https://storage.googleapis.com/kubernetes-helm
readonly HELM_TARBALL=helm-v2.8.2-linux-amd64.tar.gz
readonly INCUBATOR_REPO_URL=https://kubernetes-charts-incubator.storage.googleapis.com/

pushd /opt
    wget -q "$HELM_URL/$HELM_TARBALL"
    tar xzfv "$HELM_TARBALL"
    PATH="/opt/linux-amd64/:$PATH"
popd

helm init --client-only
helm repo add incubator "$INCUBATOR_REPO_URL"

mkdir /opt/bin
pushd /opt/bin
    # Install tools to check chart versions
    # Install YAML Command line reader
    wget -q -O yaml https://github.com/mikefarah/yaml/releases/download/1.13.1/yaml_linux_amd64
    chmod +x yaml

    # Install SemVer testing tool
    wget -q -O vert https://github.com/Masterminds/vert/releases/download/v0.1.0/vert-v0.1.0-linux-amd64
    chmod +x vert
popd
PATH="/opt/bin/:$PATH"

# Iterate over each of the changed charts
#    Install, install and delete
for directory in $CHANGED_FOLDERS; do
    if [[ "$directory" == "incubator/common" ]]; then
        continue
    elif [[ -d "$directory" ]]; then
        chart_name=$(echo "$directory" | cut -d '/' -f2)

        # A semver comparison is here as well as in the circleci tests. The circleci
        # tests provide almost immediate feedback to chart authors. This test is also
        # re-run right before the bot merges a PR so we can make sure the chart
        # version is always incremented.
        dosemvercompare "$directory"

        helm dep build "$directory"

        release_name="${chart_name:0:7}-${BUILD_ID}"

        pushd "$directory"
            has_test_values=

            for values_file in ./ci/*-values.yaml; do
                test_release "$values_file"
                has_test_values=true
            done

            if [[ -z "$has_test_values" ]]; then
                test_release
            fi
        popd
    fi
done

cleanup_namespace
