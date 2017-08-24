#!/bin/bash -xe

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

NAMESPACE=$1
if [ -z $NAMESPACE ];then
  echo "ERROR: No namespace specified"
  exit 1
fi

# Ensure all pods in the namespace entered a Running state
SUCCESS=0
PODS_FOUND=0
COUNT=0
RETRY=18
RETRY_DELAY=10
while [ "$COUNT" -lt "$RETRY" ]; do
  POD_STATUS=`kubectl get pods --no-headers --namespace $NAMESPACE`
  if [ -z "$POD_STATUS" ];then
    echo "INFO: No pods found for this release, retrying after sleep"
    COUNT=$((COUNT+1))
    sleep $RETRY_DELAY
    continue
  else
    PODS_FOUND=1
  fi
  if ! echo "$POD_STATUS" | grep -v Running;then
    echo "INFO: All pods entered the Running state"
    exit 0
  else
    echo "INFO: Sleeping waiting for containers to be ready"
    COUNT=$((COUNT+1))
    kubectl get pods  --no-headers --namespace $NAMESPACE
    sleep $RETRY_DELAY
  fi
done

if [ "$PODS_FOUND" -eq 0 ];then
  echo "WARN: No pods launched by this chart's default settings"
  exit 0
else
  echo "ERROR: Some containers failed to reach the ready state"
  exit 1
fi
