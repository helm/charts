#!/bin/bash -e

if [ "${1}" == "" ] || [ "${2}" == "" ]; then
    echo "Usage: $0 [secret name] [namespace]"
fi

DIR=$(mktemp -d)
NAME=${1:-pomerium}
NAMESPACE=${2:-default}
for service in authenticate authorize proxy; do
    kubectl get secrets "${NAME}" -n "${NAMESPACE}" -o jsonpath="{.data.${service}-key}" | base64 -D | base64 -D >"${DIR}/${service}.key"
    kubectl get secrets "${NAME}" -n "${NAMESPACE}" -o jsonpath="{.data.${service}-cert}" | base64 -D | base64 -D >"${DIR}/${service}.crt"

    kubectl create secret tls "${NAME}-${service}-tls" \
        --cert="${DIR}/${service}.crt" \
        --key="${DIR}/${service}.key"
done

kubectl get secrets "${NAME}" -n "${NAMESPACE}" -o jsonpath="{.data.ca-cert}" | base64 -D | base64 -D >"${DIR}/ca.crt"
kubectl create secret generic "${NAME}-ca-tls" \
    --from-file=ca.crt="${DIR}/ca.crt"
echo "Please delete ${DIR} to clean up temporary certificate storage"
echo "# rm ${DIR}/*.{key,crt} && rmdir ${DIR}"
