#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Install and initialize helm/tiller
HELM_URL=https://storage.googleapis.com/kubernetes-helm
HELM_TARBALL=helm-v2.8.2-linux-amd64.tar.gz

wget -q ${HELM_URL}/${HELM_TARBALL} -P ${WORKSPACE}
tar xzfv ${WORKSPACE}/${HELM_TARBALL} -C ${WORKSPACE}

# Housekeeping
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
${WORKSPACE}/linux-amd64/helm init --service-account tiller --upgrade

${WORKSPACE}/linux-amd64/helm repo add stable https://kubernetes-charts.storage.googleapis.com/
${WORKSPACE}/linux-amd64/helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

# Run test framework
pushd .
cd $GOPATH
go get github.com/ghodss/yaml
popd
go run $GOPATH/src/k8s.io/charts/test/helm-test/main.go
