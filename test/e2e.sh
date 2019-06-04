#!/usr/bin/env bash

# Copyright 2018 The Kubernetes Authors. All rights reserved.
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

readonly IMAGE_TAG=v3.3.2
readonly IMAGE_REPOSITORY="gcr.io/kubernetes-charts-ci/test-image"
readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

# Pull numbers are only available on presubmit jobs. When the tests are run as
# part of a batch job (e.g., batch merge) the PULL_NUMBER is not available. Pull
# numbers are useful for some debugging. When no PULL_NUMBER is supplied we build
# from other info.
PULL_INFO="${PULL_NUMBER:-}"
if [ -z "$PULL_INFO" ]; then
    PULL_INFO="${PULL_BASE_SHA:-}"
fi
readonly PULL_INFO

main() {
    git remote add k8s https://github.com/helm/charts
    git fetch k8s master

    local config_container_id
    config_container_id=$(docker run -ti -d -v "$GOOGLE_APPLICATION_CREDENTIALS:/service-account.json" \
        -v "$REPO_ROOT:/workdir" --workdir=/workdir \
        -e "CT_BUILD_ID=$JOB_TYPE-$PULL_INFO-$BUILD_ID" \
        "$IMAGE_REPOSITORY:$IMAGE_TAG" cat)

    # shellcheck disable=SC2064
    trap "docker rm -f $config_container_id" EXIT

    docker exec "$config_container_id" gcloud auth activate-service-account --key-file /service-account.json
    docker exec "$config_container_id" gcloud container clusters get-credentials jenkins --project kubernetes-charts-ci --zone us-west1-a
    docker exec "$config_container_id" kubectl cluster-info
    docker exec "$config_container_id" ct lint-and-install --config test/ct.yaml

    echo "Done Testing!"
}

main
