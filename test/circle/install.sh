#!/bin/bash -e
# Copyright 2017 The Kubernetes Authors All rights reserved.
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

# Install Helm
HELM_LATEST_VERSION="v2.6.1"

wget http://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm -f helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
rm -rf linux-amd64

# Install A YAML Linter
# Pinning to a version for consistency
sudo pip install yamllint==1.8.1