#!/usr/bin/env bash

# Copyright 2016 The Kubernetes Authors. All rights reserved.
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

function create-patch-file () {
    local file="$1"

    cat << EOF > "$file"
[{
  "op":    "add",
  "path":  "/metadata/labels/name",
  "value": "$POD_NAME"
}]
EOF
}

function create-label () {
    local data="$1"
    local token="$(< /var/run/secrets/kubernetes.io/serviceaccount/token)"
    local url="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$POD_NAMESPACE/pods/$POD_NAME"
    local cacert="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

    curl -sS --request PATCH \
        --data "@$data" \
        --cacert "$cacert" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type:application/json-patch+json" \
        "$url"
}

create-patch-file ./create-name-label.patch.json
create-label ./create-name-label.patch.json
