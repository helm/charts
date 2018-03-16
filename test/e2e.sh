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

# TODO should we inject this.  This is creating problems bumping the Docker version
IMAGE_VERSION="test-image:v1.11"
CHART_ROOT=${CHART_ROOT:-$(git rev-parse --show-toplevel)}
IMAGE_NAME=${IMAGE_NAME:-"gcr.io/kubernetes-charts-ci/${IMAGE_VERSION}"}

VOLUMES="-v ${CHART_ROOT}:/src -v ${KUBECONFIG:=${HOME}/.kube/config}:/.kube/config"

GKE_CREDS=""
if [ -f $HOME/.config/gcloud/application_default_credentials.json ];then
  GKE_CREDS="-v $HOME/.config/gcloud/application_default_credentials.json:/service-account.json:ro"
  GKE_CREDS="${GKE_CREDS} -e KUBECONFIG=/.kube/config"
elif [ -n ${GOOGLE_APPLICATION_CREDENTIALS:=} ];then
  GKE_CREDS="-v ${GOOGLE_APPLICATION_CREDENTIALS}:/service-account.json:ro"
else
  echo "Unable to find a suitable value for GOOGLE_APPLICATION_CREDENTIALS"
  exit 1
fi

# Pull numbers are only available on presubmit jobs. When the tests are run as
# part of a batch job (e.g., batch merge) the PULL_NUMBER is not available. Pull
# numbers are useful for some debugging. When no PULL_NUMBER is supplied we build
# from other info.
PULL_INFO=${PULL_NUMBER}
if [ -z "$PULL_INFO" ]; then
  PULL_INFO=${PULL_BASE_SHA}
fi

docker run ${VOLUMES} ${GKE_CREDS} \
           -e GOOGLE_APPLICATION_CREDENTIALS=/service-account.json \
           -e "JOB_TYPE=$JOB_TYPE" \
           -e "PULL_INFO=$PULL_INFO" \
           -e "BUILD_ID=$BUILD_ID" \
           -e "VERIFICATION_PAUSE=${VERIFICATION_PAUSE:=0}" \
           ${IMAGE_NAME} /src/test/changed.sh
echo "Done Testing!"
