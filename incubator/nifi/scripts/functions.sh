#!/bin/bash

function argcheck {
    [[ $# -lt 2 ]] && cat <<EOF && exit 1
Usage: <profile> <context>

- profile: Predefined or custom profile that will be sourced for required env vars
- context: Kubectl context used to install the helm chart into
EOF

    SELECTED_PROFILE=${1:-}
    echo "Selected profile: $SELECTED_PROFILE"
    source $SELECTED_PROFILE

    SELECTED_CONTEXT=${2:-}
    echo "Selected context: $SELECTED_CONTEXT"
    kubectl config use-context $SELECTED_CONTEXT
}

function kubectl_download_secret() {
    SECRET=$1
    SECRET_FILENAME=$2
    DESTINATION=$3

    kubectl get secret -n "${RELEASE_NAMESPACE}" "$SECRET" -o json | jq -r ".data.\"${SECRET_FILENAME}\"" | base64 -D > "$3"
}