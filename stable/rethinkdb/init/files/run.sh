#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
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

set -o pipefail

POD_NAMESPACE=${POD_NAMESPACE:-default}
POD_IP=${POD_IP:-127.0.0.1}
RETHINK_CLUSTER_SERVICE=${RETHINK_CLUSTER_SERVICE:-"rethinkdb"}
POD_NAME=${POD_NAME:-"NO_POD_NAME"}
RETHINKDB_PASSWORD=${RETHINKDB_PASSWORD:-"auto"}

# Transform - to _ to comply with requirements
SERVER_NAME=$(echo ${POD_NAME} | sed 's/-/_/g')

echo "Using additional CLI flags: ${@}"
echo "Pod IP: ${POD_IP}"
echo "Pod namespace: ${POD_NAMESPACE}"
echo "Using service name: ${RETHINK_CLUSTER_SERVICE}"
echo "Using server name: ${SERVER_NAME}"

echo "Checking for other nodes..."
if [[ -n "${KUBERNETES_SERVICE_HOST}" ]]; then
  echo "Using endpoints to lookup other nodes..."
  URL="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/namespaces/${POD_NAMESPACE}/endpoints/${RETHINK_CLUSTER_SERVICE}"
  echo "Endpoint url: ${URL}"
  echo "Looking for IPs..."
  token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  # try to pick up first different ip from endpoints
  IP=$(curl -s ${URL} --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt --header "Authorization: Bearer ${token}" \
    | jq -s -r --arg h "${POD_IP}" '.[0].subsets | .[].addresses | [ .[].ip ] | map(select(. != $h)) | .[0]') || exit 1
  [[ "${IP}" == null ]] && IP=""
  JOIN_ENDPOINTS="${IP}"
fi

# xargs echo removes extra spaces before/after
# tr removes extra spaces in the middle
JOIN_ENDPOINTS=$(echo ${JOIN_ENDPOINTS} | xargs echo | tr -s ' ')

if [ -n "${JOIN_ENDPOINTS}" ]; then
  echo "Found other nodes: ${JOIN_ENDPOINTS}"

  # Now, transform join endpoints into --join ENDPOINT:29015
  # Put port after each
  JOIN_ENDPOINTS=$(echo ${JOIN_ENDPOINTS} | sed -r 's/([0-9.])+/&:29015/g')

  # Put --join before each
  JOIN_ENDPOINTS=$(echo ${JOIN_ENDPOINTS} | sed -e 's/^\|[ ]/&--join /g')
else
  echo "No other nodes detected, will be a single instance."
  if [ -n "$PROXY" ]; then
    echo "Cannot start in proxy mode without endpoints."
    exit 1
  fi
fi

if [[ -n "${PROXY}" ]]; then
  echo "Starting in proxy mode"
  set -x
  exec rethinkdb \
    proxy \
    --canonical-address ${POD_IP} \
    --initial-password ${RETHINKDB_PASSWORD} \
    ${JOIN_ENDPOINTS} \
    ${@}
else
  set -x
  exec rethinkdb \
    --server-name ${SERVER_NAME} \
    --canonical-address ${POD_IP} \
    --initial-password ${RETHINKDB_PASSWORD} \
    ${JOIN_ENDPOINTS} \
    ${@}
fi
