#!/bin/bash

set -eou pipefail

CURRENT_DIR="$(cd `dirname $0` && pwd)"

source $CURRENT_DIR/functions.sh

argcheck $@

if [[ $(helm list --namespace $RELEASE_NAMESPACE | grep $RELEASE_NAME) ]]; then
    helm delete $RELEASE_NAME --purge
fi
kubectl delete pvc -l release=$RELEASE_NAME
kubectl delete secret -l release=$RELEASE_NAME