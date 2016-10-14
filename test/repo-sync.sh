#!/bin/bash -xe
# Copyright 2016 The Kubernetes Authors All rights reserved.
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

# Setup Helm
HELM_URL=https://storage.googleapis.com/kubernetes-helm
HELM_TARBALL=helm-canary-linux-amd64.tar.gz
wget -q ${HELM_URL}/${HELM_TARBALL}
tar xzfv ${HELM_TARBALL}
PATH=`pwd`/linux-amd64/:$PATH
helm init --client-only

# Create the stable repository
STABLE_REPO_DIR=stable-repo
mkdir -p ${STABLE_REPO_DIR}
cd ${STABLE_REPO_DIR}
  for dir in `ls ../stable`;do 
    helm package ../stable/$dir
  done
  helm repo index --url http://storage.googleapis.com/kubernetes-charts/ .
cd ..
ls -l ${STABLE_REPO_DIR}

# Create the incubator repository
INCUBATOR_REPO_DIR=incubator-repo
mkdir -p ${INCUBATOR_REPO_DIR}
cd ${INCUBATOR_REPO_DIR}
  for dir in `ls ../incubator`;do 
    helm package ../incubator/$dir
  done
  helm repo index --url http://storage.googleapis.com/kubernetes-charts-incubator/ .
cd ..
ls -l ${INCUBATOR_REPO_DIR}

# Sync repository content
cat > sa.json <<EOF
$SERVICE_ACCOUNT_JSON
EOF
gcloud auth activate-service-account --key-file sa.json
gsutil -m rsync stable-repo/ gs://kubernetes-charts/
gsutil -m rsync incubator-repo/ gs://kubernetes-charts-incubator/
