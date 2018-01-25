#!/bin/bash

# setup helm
echo "Installing helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
echo "--- Configuring Helm cli :rocket:"
export HELM_HOME="${PWD}/.buildkite/.helm"
helm init -c
helm repo add charts https://my_charts.com/charts
helm repo update

# use buildkite commit hash as a TAG
TAG=${BUILDKITE_COMMIT::8}

# app name
APP=some_app

# deploy/upgrade app with helm
echo "--- Deploying $APP :rocket:"
helm upgrade --install ${APP} charts/my_app --namespace ${SOME_NAMESPACE} --reuse-values \
  --set image.tag="${GIT_TAG}"
