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

git remote add k8s https://github.com/kubernetes/charts
git fetch k8s master

namespace="pr-${PULL_NUMBER}-${BUILD_NUMBER}"
changed_folders=$(git diff --find-renames --name-only "$(git merge-base k8s/master HEAD)" stable/ incubator/ | awk -F/ '{ print $1"/"$2 }' | uniq)
current_release=""

# Exit early if no charts have changed
if [[ -z "$changed_folders" ]]; then
    exit 0
fi

# include the semvercompare function
curDir="$(dirname "$0")"
source "$curDir/semvercompare.sh"
exitCode=0

# Cleanup any releases and namespaces left over from the test
function cleanup {
    if [[ -n "$current_release" ]]; then

        # Before reporting the logs from all pods provide a helm status for
        # the release
        helm status "${current_release}" || true

        # List all logs for all containers in all pods for the namespace which was
        # created for this PR test run
        kubectl get pods --show-all --no-headers --namespace "$namespace" | awk '{ print $1 }' | while read -r pod; do
            if [[ -n "$pod" ]]; then
                printf '===Logs from pod %s:===\n' "$pod"

                # There can be multiple containers within a pod. We need to iterate
                # over each of those
                containers=$(kubectl get pods --show-all -o jsonpath="{.spec.containers[*].name}" --namespace "$namespace" "$pod")
                for container in $containers; do
                    printf -- '---Logs from container %s in pod %s:---\n' "$container" "$pod"
                    kubectl logs --namespace "$namespace" -c "$container" "$pod" || true
                    printf -- '---End of logs for container %s in pod %s---\n\n' "$container" "$pod"
                done

                printf '===End of logs for pod %s===\n' "$pod"
            fi
        done

        helm delete --purge "$current_release" > cleanup_log 2>&1 || true
    fi

    kubectl delete ns "$namespace" >> cleanup_log 2>&1 || true
}
trap cleanup EXIT

function dosemvercompare {
    # Note, the trap and automatic exiting are disabled for the semver comparison
    # because it catches its own errors. If the comparison fails exitCode is set
    # to 1. So, trapping and exiting is re-enabled and then the exit is handled
    trap - EXIT
    set +e
    semvercompare "$1"
    trap cleanup EXIT
    set -e
    if [[ "$exitCode" == 1 ]]; then
        exit 1
    fi
}

if [ ! -f "${KUBECONFIG:=}" ];then
    # Get credentials for test cluster
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a
fi

# Install and initialize helm/tiller
helm_url=https://storage.googleapis.com/kubernetes-helm
helm_tarball=helm-v2.7.2-linux-amd64.tar.gz
incubator_repo_url=https://kubernetes-charts-incubator.storage.googleapis.com/

pushd /opt
    wget -q "$helm_url/$helm_tarball"
    tar xzfv "$helm_tarball"
    PATH="/opt/linux-amd64/:$PATH"
popd

helm init --client-only
helm repo add incubator "$incubator_repo_url"

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
#    Lint, install and delete
for directory in $changed_folders; do
    if [[ "$directory" == "incubator/common" ]]; then
        continue
    elif [[ -d "$directory" ]]; then
        chart_name=$(echo "$directory" | cut -d '/' -f2)

        # A semver comparison is here as well as in the circleci tests. The circleci
        # tests provide almost immediate feedback to chart authors. This test is also
        # re-run right before the bot merges a PR so we can make sure the chart
        # version is always incremented.
        dosemvercompare "$directory"

        release_name="${chart_name:0:7}-${BUILD_NUMBER}"
        current_release="$release_name"

        helm dep build "$directory"
        helm install --timeout 600 --name "$release_name" --namespace "$namespace" "$directory" | tee install_output

        ./test/verify-release.sh "$namespace"

        kubectl get pods --namespace "$namespace"
        kubectl get svc --namespace "$namespace"
        kubectl get deployments --namespace "$namespace"
        kubectl get endpoints --namespace "$namespace"

        helm test "$release_name"

        if [[ -n "${VERIFICATION_PAUSE:-}" ]]; then
            cat install_output
            sleep "$VERIFICATION_PAUSE"
        fi

        helm delete --purge "$release_name"

        # Setting the current release to none to avoid the cleanup and error
        # handling for a release that no longer exists.
        current_release=""
    fi
done
