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
set -o xtrace

# Install and initialize helm/tiller
readonly HELM_URL=https://storage.googleapis.com/kubernetes-helm
readonly HELM_TARBALL=helm-v2.9.1-linux-amd64.tar.gz

wget -q "$HELM_URL/$HELM_TARBALL" -P "$WORKSPACE"
tar xzfv "$WORKSPACE/$HELM_TARBALL" -C "$WORKSPACE"

# Housekeeping
pushd "$WORKSPACE/linux-amd64"

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
./helm init --service-account tiller --upgrade
./helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

popd

# Run test framework
go get github.com/ghodss/yaml
go run "$GOPATH/src/k8s.io/charts/test/helm-test/main.go"
