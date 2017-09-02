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
  if [ -n "$POD_STATUS" ];then
    PODS_FOUND=1
  fi

  UNREADY_CONTAINERS=`kubectl get pods --namespace $NAMESPACE \
    -o jsonpath="{.items[*].status.containerStatuses[?(@.ready!=true)]}"`
  if [ -n "$UNREADY_CONTAINERS" ];then
    echo "INFO: Some containers are not yet ready; retrying after sleep"
    COUNT=$((COUNT+1))
    sleep $RETRY_DELAY
    continue
  else
    echo "INFO: All containers are ready"
    exit 0
  fi
done

if [ "$PODS_FOUND" -eq 0 ];then
  echo "WARN: No pods launched by this chart's default settings"
  exit 0
else
  echo "ERROR: Some containers failed to reach the ready state"
  exit 1
fi
