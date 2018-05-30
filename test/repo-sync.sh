#!/bin/bash

# Copyright 2016 The Kubernetes Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# Setup Helm
readonly HELM_URL=https://storage.googleapis.com/kubernetes-helm
readonly HELM_TARBALL=helm-v2.9.1-linux-amd64.tar.gz
readonly STABLE_REPO_URL=https://kubernetes-charts.storage.googleapis.com/
readonly INCUBATOR_REPO_URL=https://kubernetes-charts-incubator.storage.googleapis.com/

main() {
    setup_helm_client
    authenticate

    if ! sync_repo stable; then
        echo "ERROR: Not all stable charts could be packaged and synced!"
    fi
    if ! sync_repo incubator; then
        echo "ERROR: Not all incubator charts could be packaged and synced!"
    fi
}

setup_helm_client() {
    echo "Setting up Helm client..."

    apt-get update
    apt-get install -y wget
    wget --user-agent=wget-ci-sync -q "$HELM_URL/$HELM_TARBALL"
    tar xzfv "$HELM_TARBALL"

    PATH="$(pwd)/linux-amd64/:$PATH"

    helm init --client-only
    helm repo add incubator "$INCUBATOR_REPO_URL"
}

authenticate() {
    echo "Authenticating with Google Cloud..."
    gcloud auth activate-service-account --key-file <(base64 --decode <<< "$SYNC_CREDS")
}

sync_repo() {
    local repo_dir="${1?Specify repo dir}"
    local sync_dir="${repo_dir}-sync"

    echo "Syncing repo '$repo_dir'..."

    mkdir -p "$sync_dir"
    gsutil cp gs://kubernetes-charts/index.yaml "$sync_dir"

    local exit_code=0

    for dir in "$repo_dir"/*; do
        if ! helm dependency build "$dir"; then
            echo "ERROR: Chart dependencies for '$dir' could not be built!" >&2
            exit_code=1
        elif ! helm package --destination "$sync_dir" "$dir"; then
            exit_code=1
            echo "ERROR: Chart '$dir' could not be packaged!" >&2
        fi
    done

    helm repo index --url "$sync_dir" --merge "$sync_dir"/index.yaml "$sync_dir"
    gsutil -m rsync "$sync_dir" gs://kubernetes-charts/

    ls -l "$sync_dir"

    return "$exit_code"
}

main
