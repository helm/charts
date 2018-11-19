#!/bin/sh

set -exuo pipefail

mkdir -p /tmp/ca-cert-generator

${NIFI_TOOLKIT_HOME}/bin/tls-toolkit.sh client\
    -c "${CA_NAME}"\
    -p "${CA_PORT}"\
    -t "${TOKEN_FILE}"\
    -D "${DN}"\
    -T "${TYPE}"

kubectl create secret generic ca-cert-"${ID}" --from-file /tmp/ca-cert-generator
