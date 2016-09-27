#!/bin/bash -xe
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

UPSTREAM_BRANCH="upstream/master"
NAMESPACE="pr-${ghprbPullId}-${BUILD_NUMBER}"
CHANGED_FOLDERS=`git diff --find-renames --name-only ${UPSTREAM_BRANCH} | grep -v test | grep / | awk -F/ '{print $1"/"$2}' | uniq`
CURRENT_RELEASE=""

# Cleanup any releases and namespaces left over from the test
function cleanup {
    if [ -n $CURRENT_RELEASE ];then
      helm delete --purge ${CURRENT_RELEASE} || true
    fi
    kubectl delete ns ${NAMESPACE} || true
}
trap cleanup EXIT

# Get credentials for test cluster
gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a

# Install and initialize helm/tiller
HELM_URL=https://storage.googleapis.com/kubernetes-helm
HELM_TARBALL=helm-canary-linux-amd64.tar.gz
pushd /opt
  wget -q ${HELM_URL}/${HELM_TARBALL}
  tar xzfv ${HELM_TARBALL}
  PATH=/opt/linux-amd64/:$PATH
popd

helm init --client-only

# Iterate over each of the changed charts
#    Lint, install and delete
for directory in ${CHANGED_FOLDERS}; do
  CHART_NAME=`echo ${directory} | cut -d '/' -f2`
  RELEASE_NAME="${CHART_NAME:0:7}-${BUILD_NUMBER}"
  CURRENT_RELEASE=${RELEASE_NAME}
  helm lint ${directory}
  helm install --name ${RELEASE_NAME} --namespace ${NAMESPACE} ${directory}
  # TODO run functional validation here
  helm delete --purge ${RELEASE_NAME}
done
