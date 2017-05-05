#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Install and initialize helm/tiller
HELM_URL=https://storage.googleapis.com/kubernetes-helm
HELM_TARBALL=helm-v2.2.3-linux-amd64.tar.gz

wget -q ${HELM_URL}/${HELM_TARBALL}
tar xzfv ${HELM_TARBALL}

# Clean up tarball
rm -f ${HELM_TARBALL}

# Housekeeping
linux-amd64/helm init --upgrade

# Run test framework
go run /src/k8s.io/charts/test/helm-test/main.go