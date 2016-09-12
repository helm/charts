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

CHANGED_FOLDERS=`git diff --name-only ${UPSTREAM_BRANCH} | grep -v test | grep / | awk -F/ '{print $1"/"$2}' | uniq`

# Get credentials for test cluster
gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a

# Initialize helm/tiller
helm init --client-only
for directory in ${CHANGED_FOLDERS}; do
  CHART_NAME=`echo $directory | cut -d '/' -f2`
  RELEASE_NAME="pr-$ghprbPullId-$BUILD_NUMBER-$CHART_NAME"
  helm lint ${directory}
  helm install --name $RELEASE_NAME
  helm delete --name $RELEASE_NAME
done
