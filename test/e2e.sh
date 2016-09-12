#!/bin/bash -ex
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

# TODO should we inject this.  This is creating problems bumping the Docker version
IMAGE_VERSION="test-image:v1.8"
CHART_ROOT=${CHART_ROOT:-$(git rev-parse --show-toplevel)}
IMAGE_NAME=${IMAGE_NAME:-"gcr.io/kubernetes-charts-ci/${IMAGE_VERSION}"}

docker run -v ${CHART_ROOT}:/src ${IMAGE_NAME} /src/test/changed.sh
echo "Done Testing!"
