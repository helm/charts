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

NAMESPACE="pr-${PULL_NUMBER}-${BUILD_NUMBER}"
CHANGED_FOLDERS=`git diff --find-renames --name-only $(git merge-base k8s/master HEAD) stable/ incubator/ | awk -F/ '{print $1"/"$2}' | uniq`
CURRENT_RELEASE=""

# Exit early if no charts have changed
if [ -z "$CHANGED_FOLDERS" ]; then
  exit 0
fi

# include the semvercompare function
curDir="$(dirname "$0")"
source "$curDir/semvercompare.sh"
exitCode=0

# Cleanup any releases and namespaces left over from the test
function cleanup {
    if [ -n "$CURRENT_RELEASE" ]; then

      # Capture logs from test pods
      kubectl get po --namespace ${NAMESPACE} --show-all -o go-template='{{range .items}}{{ $hook := print (index .metadata.annotations "helm.sh/hook") }}{{ if or (eq $hook "test-success") (eq $hook "test-failure") }}{{printf "%s\n" .metadata.name}}{{end}}{{end}}' | while read line; do
        if [[ $line != "" ]]; then
          echo "Logs from test pod $line:"
          kubectl logs --namespace ${NAMESPACE} ${line}
          printf "End of logs for $line\n\n"
        fi
      done

      # Capture logs from application pods
      helm status ${CURRENT_RELEASE}
      helm status ${CURRENT_RELEASE} | sed -n '/Pod(related)/,/^$/p' | sed -e '1,2d' | awk '{ print $1 }' | while read line; do
        if [[ $line != "" ]]; then
          echo "logs for app pod $line:"
          kubectl logs ${line}
          printf "End of logs for $line\n\n"
        fi
      done


      helm delete --purge ${CURRENT_RELEASE} > cleanup_log 2>&1 || true
    fi
    kubectl delete ns ${NAMESPACE} >> cleanup_log 2>&1 || true
}
trap cleanup EXIT

function dosemvercompare {
  # Note, the trap and automatic exiting are disabled for the semver comparison
  # because it catches its own errors. If the comparison fails exitCode is set
  # to 1. So, trapping and exiting is re-enabled and then the exit is handled
  trap - EXIT
  set +e
  semvercompare ${1}
  trap cleanup EXIT
  set -e
  if [ $exitCode == 1 ]; then
    exit 1
  fi
}

if [ ! -f "${KUBECONFIG:=}" ];then
  # Get credentials for test cluster
  gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
  gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a
fi

# Install and initialize helm/tiller
HELM_URL=https://storage.googleapis.com/kubernetes-helm
HELM_TARBALL=helm-v2.7.2-linux-amd64.tar.gz
INCUBATOR_REPO_URL=https://kubernetes-charts-incubator.storage.googleapis.com/
pushd /opt
  wget -q ${HELM_URL}/${HELM_TARBALL}
  tar xzfv ${HELM_TARBALL}
  PATH=/opt/linux-amd64/:$PATH
popd

helm init --client-only
helm repo add incubator ${INCUBATOR_REPO_URL}

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
PATH=/opt/bin/:$PATH

# Iterate over each of the changed charts
#    Lint, install and delete
for directory in ${CHANGED_FOLDERS}; do
  if [ "$directory" == "incubator/common" ]; then
    continue
  elif [ -d $directory ]; then
    CHART_NAME=`echo ${directory} | cut -d '/' -f2`
    
    # A semver comparison is here as well as in the circleci tests. The circleci
    # tests provide almost immediate feedback to chart authors. This test is also
    # re-run right before the bot merges a PR so we can make sure the chart
    # version is always incremented.
    dosemvercompare ${directory}
    RELEASE_NAME="${CHART_NAME:0:7}-${BUILD_NUMBER}"
    CURRENT_RELEASE=${RELEASE_NAME}
    helm dep build ${directory}
    helm install --timeout 600 --name ${RELEASE_NAME} --namespace ${NAMESPACE} ${directory} | tee install_output
    ./test/verify-release.sh ${NAMESPACE}
    kubectl get pods --namespace ${NAMESPACE}
    kubectl get svc --namespace ${NAMESPACE}
    kubectl get deployments --namespace ${NAMESPACE}
    kubectl get endpoints --namespace ${NAMESPACE}
    helm test ${RELEASE_NAME}

    if [ -n $VERIFICATION_PAUSE ]; then
      cat install_output
      sleep $VERIFICATION_PAUSE
    fi
    helm delete --purge ${RELEASE_NAME}
    
    # Setting the current release to none to avoid the cleanup and error
    # handling for a release that no longer exists.
    CURRENT_RELEASE=""
  fi
done
