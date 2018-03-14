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
HELM_LATEST_VERSION="v2.7.2"

wget http://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
rm -f helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
rm -rf linux-amd64

# Setup Helm so that it will work with helm dep commands. Only the client
# needs to be setup. In addition, the incubator repo needs to be
# available for charts that depend on it.
helm init -c
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

# Install A YAML Linter
# Pinning to a version for consistency
sudo pip install yamllint==1.8.1

# Install YAML Command line reader
wget https://github.com/mikefarah/yaml/releases/download/1.13.1/yaml_linux_amd64
chmod +x yaml_linux_amd64
sudo mv yaml_linux_amd64 /usr/local/bin/yaml

# Install SemVer testing tool
wget https://github.com/Masterminds/vert/releases/download/v0.1.0/vert-v0.1.0-linux-amd64
chmod +x vert-v0.1.0-linux-amd64
sudo mv vert-v0.1.0-linux-amd64 /usr/local/bin/vert