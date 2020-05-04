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

readonly IMAGE_TAG=v3.4.1
readonly IMAGE_REPOSITORY="gcr.io/kubernetes-charts-ci/test-image"
readonly SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

show_help() {
cat << EOF
Usage: ${0##*/} <args>
    -h, --help             Display help
    -v, --verbose          Display verbose output
    -p, --push             Push image to registry
EOF
}

main() {
    local verbose=
    local push=

    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -v|--verbose)
                verbose=true
                ;;
            -p|--push)
                push=true
                ;;
            -?*)
                printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
                ;;
            *)
                break
                ;;
        esac

        shift
    done

    [[ -n "$verbose" ]] && set -o xtrace

    pushd "$SCRIPT_DIR"

    docker build --tag "$IMAGE_REPOSITORY:$IMAGE_TAG" .

    if [[ -n "$push" ]]; then
        docker push "$IMAGE_REPOSITORY:$IMAGE_TAG"
    fi

    popd
}

main "$@"
