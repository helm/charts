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
POD_RETRY_COUNT=0
RETRY=18
RETRY_DELAY=10
while [ "$POD_RETRY_COUNT" -lt "$RETRY" ]; do
  POD_STATUS=`kubectl get pods --no-headers --namespace $NAMESPACE`
  if [ -z "$POD_STATUS" ];then
    echo "INFO: No pods found for this release, retrying after sleep"
    POD_RETRY_COUNT=$((POD_RETRY_COUNT+1))
    sleep $RETRY_DELAY
    continue
  else
    PODS_FOUND=1
  fi

  if ! echo "$POD_STATUS" | grep -v Running;then
    echo "INFO: All pods entered the Running state"

    CONTAINER_RETRY_COUNT=0
    while [ "$CONTAINER_RETRY_COUNT" -lt "$RETRY" ]; do
      UNREADY_CONTAINERS=`kubectl get pods --namespace $NAMESPACE \
        -o jsonpath="{.items[*].status.containerStatuses[?(@.ready!=true)].name}"`
      if [ -n "$UNREADY_CONTAINERS" ];then
        echo "INFO: Some containers are not yet ready; retrying after sleep"
        CONTAINER_RETRY_COUNT=$((CONTAINER_RETRY_COUNT+1))
        sleep $RETRY_DELAY
        continue
      else
        echo "INFO: All containers are ready"
        exit 0
      fi
    done
  fi
done

if [ "$PODS_FOUND" -eq 0 ];then
  echo "WARN: No pods launched by this chart's default settings"
  exit 0
else
  echo "ERROR: Some containers failed to reach the ready state"
  exit 1
fi
