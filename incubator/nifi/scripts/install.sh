#!/bin/bash

set -eou pipefail

CURRENT_DIR="$(cd `dirname $0` && pwd)"

source $CURRENT_DIR/functions.sh

argcheck $@

echo "Checking tiller"
if [[ ! $(kubectl get po -n kube-system | grep tiller) || ! $(kubectl get sa -n kube-system tiller) || ! $(kubectl get clusterrolebindings tiller-cluster-role) ]]; then
    echo "Initializing helm in the kube-system namespace"
    kubectl create serviceaccount --namespace kube-system tiller --dry-run -o yaml | kubectl replace --force --namespace kube-system -f -
    kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller --dry-run -o yaml | kubectl replace --force -f -
    helm init --service-account tiller

    echo -n "Waiting for tiller to become available.."
    until [[ $(kubectl get po -n kube-system | grep tiller | grep '1/1') ]]; do
        sleep 2
        echo -n "."
    done
fi

if [[ -z ${PROXY_HOST:-} ]]; then
  echo "Please provide the domain name that will be used to access the cluster! Default: nifi"
  read -r PROXY_HOST
  export PROXY_HOST=${PROXY_HOST:-nifi}
fi

echo "Running helm..."
helm upgrade --install $RELEASE_NAME $CHART_PATH\
 $VALUES_FILES\
 --namespace $RELEASE_NAMESPACE\
 --set properties.webProxyHost=$PROXY_HOST\
 --set ca.admin.cn=$ADMIN_CN\
 --kube-context $SELECTED_CONTEXT
