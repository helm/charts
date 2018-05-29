#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

NAMESPACE="${1:-}"
if [[ -z "$NAMESPACE" ]];then
  echo "ERROR: No namespace specified"
  exit 1
fi

# Ensure all pods in the namespace entered a Running state
PODS_FOUND=0
POD_RETRY_COUNT=0
RETRY=54
RETRY_DELAY=10

while (("$POD_RETRY_COUNT" < "$RETRY")); do
  POD_RETRY_COUNT=$((POD_RETRY_COUNT + 1))
  POD_STATUS=$(kubectl get pods --no-headers --namespace "$NAMESPACE")

  if [[ -z "$POD_STATUS" ]];then
    echo "INFO: No pods found for this release, retrying after sleep"

    sleep "$RETRY_DELAY"
    continue
  else
    PODS_FOUND=1
  fi

  if ! echo "$POD_STATUS" | grep -v Running; then
    echo "INFO: All pods entered the Running state"

    CONTAINER_RETRY_COUNT=0
    READINESS_RETRY_COUNT=0
    READINESS_RETRY_DELAY=2

    while (("$CONTAINER_RETRY_COUNT" < "$RETRY")); do
      JSON_PATH="{.items[*].status.containerStatuses[?(@.ready!=true)].name}"
      UNREADY_CONTAINERS=$(kubectl get pods --namespace "$NAMESPACE" -o "jsonpath=$JSON_PATH")

      if [[ -n "$UNREADY_CONTAINERS" ]]; then
        echo "INFO: Some containers are not yet ready; retrying after sleep"

        CONTAINER_RETRY_COUNT=$((CONTAINER_RETRY_COUNT + 1))
        READINESS_RETRY_COUNT=0

        sleep "$RETRY_DELAY"
        continue
      else
        echo "INFO: All containers are ready"

        if (("$READINESS_RETRY_COUNT" < 3)); then
            echo "INFO: Double-checking readiness again"

            READINESS_RETRY_COUNT=$((READINESS_RETRY_COUNT + 1))

            sleep "$READINESS_RETRY_DELAY"
            continue
        fi

        exit 0
      fi
    done
  else
    echo "INFO: Waiting for pods to enter running state"
    sleep "$RETRY_DELAY"
  fi
done

if (("$PODS_FOUND" == 0)); then
  echo "WARN: No pods launched by this chart's default settings"
  exit 0
else
  echo "ERROR: Some containers failed to reach the ready state"
  exit 1
fi
