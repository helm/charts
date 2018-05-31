#!/bin/bash
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
HELM_TARBALL=helm-v2.9.1-linux-amd64.tar.gz
STABLE_REPO_URL=https://kubernetes-charts.storage.googleapis.com/
INCUBATOR_REPO_URL=https://kubernetes-charts-incubator.storage.googleapis.com/
apt-get install -y wget
wget --user-agent=wget-ci-sync -q ${HELM_URL}/${HELM_TARBALL}
tar xzfv ${HELM_TARBALL}
PATH=`pwd`/linux-amd64/:$PATH
helm init --client-only
helm repo add incubator ${INCUBATOR_REPO_URL}

# Authenticate before uploading to Google Cloud Storage
SERVICE_ACCOUNT_JSON=$(echo $SYNC_CREDS | base64 --decode)
cat > sa.json <<EOF
$SERVICE_ACCOUNT_JSON
EOF
gcloud auth activate-service-account --key-file sa.json

# Create the stable repository
STABLE_REPO_DIR=stable-repo
mkdir -p ${STABLE_REPO_DIR}
cd ${STABLE_REPO_DIR}
  gsutil cp gs://kubernetes-charts/index.yaml .
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "Exiting because unable to copy index locally. Not safe to proceed."
    exit 1
  fi

  for dir in `ls ../stable`;do
    echo "Building and packaging ${dir}"
    helm dep build ../stable/$dir
    ret=$?
    if [ $ret -ne 0 ]; then
      echo "Problem building dependencies. Skipping packaging of ${dir}"
    else
      helm package ../stable/$dir
    fi
  done
  helm repo index --url ${STABLE_REPO_URL} --merge ./index.yaml .
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "Exiting because unable to update index. Not safe to push update."
    exit 1
  fi
  gsutil -m rsync ./ gs://kubernetes-charts/
cd ..
ls -l ${STABLE_REPO_DIR}

# Create the incubator repository
INCUBATOR_REPO_DIR=incubator-repo
mkdir -p ${INCUBATOR_REPO_DIR}
cd ${INCUBATOR_REPO_DIR}
  gsutil cp gs://kubernetes-charts-incubator/index.yaml .
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "Exiting because unable to copy index locally. Not safe to proceed."
    exit 1
  fi
  for dir in `ls ../incubator`;do
    echo "Building and packaging ${dir}"
    helm dep build ../incubator/$dir
    ret=$?
    if [ $ret -ne 0 ]; then
      echo "Problem building dependencies. Skipping packaging of ${dir}"
    else
      helm package ../incubator/$dir
    fi
  done
  helm repo index --url ${INCUBATOR_REPO_URL} --merge ./index.yaml .
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "Exiting because unable to update index. Not safe to push update."
    exit 1
  fi
  gsutil -m rsync ./ gs://kubernetes-charts-incubator/
cd ..
ls -l ${INCUBATOR_REPO_DIR}
