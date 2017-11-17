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

# Cleanup any releases and namespaces left over from the test
function cleanup {
    if [ -n $CURRENT_RELEASE ];then
      helm delete --purge ${CURRENT_RELEASE} > cleanup_log 2>&1 || true
    fi
    kubectl delete ns ${NAMESPACE} >> cleanup_log 2>&1 || true
}
trap cleanup EXIT

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

# Iterate over each of the changed charts
#    Lint, install and delete
for directory in ${CHANGED_FOLDERS}; do
  if [ "$directory" == "incubator/common" ]; then
    continue
  elif [ -d $directory ]; then
    CHART_NAME=`echo ${directory} | cut -d '/' -f2`
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
  fi
done
