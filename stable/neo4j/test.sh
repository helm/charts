#!/bin/bash

NS="${RELEASE_NAMESPACE:-default}"
STATEFULSET_NAME="${RELEASE_NAME:-neo4j}-neo4j"
NEO4J_SECRETS_PASSWORD=$(kubectl get secret -n ${NS} ${RELEASE_NAME}-neo4j-secrets -o jsonpath='{.data.neo4j-password}' | base64 --decode)
CORE_REPLICAS=${REPLICAS:-3}

echo "Testing we can get the cluster role of each server in statefulset ${STATEFULSET_NAME} in namespace: ${NS}"

check_role() {
  name=$1
  end="$((SECONDS+600))"
  while true; do
    echo "checking cluster role: ${name} for systemdb"
    # In Neo4j 4.0 members now only have a cluster role with respect to a particular database.
    kubectl exec ${name} -n ${NS} -- bin/cypher-shell -a ${name} -u neo4j -p ${NEO4J_SECRETS_PASSWORD} "call dbms.cluster.role('system')" 2>/dev/null
    response_code=$?
    [[ "0" = "$response_code" ]] && break
    [[ "${SECONDS}" -ge "${end}" ]] && exit 1
    echo "waiting for connection to pod: ${name}"
    sleep 5
  done
}

for num in $(seq $CORE_REPLICAS); do
  id=$(expr $num - 1)
  name="${STATEFULSET_NAME}-core-$id"
  echo "checking role of $name for systemdb"
  check_role $name
done

# kill a machine and make sure it comes back again
machine_to_kill="${STATEFULSET_NAME}-core-0"
echo "Testing recovery after failed/deleted pod"
echo "Deleting pod: ${machine_to_kill}"
kubectl delete pod ${machine_to_kill} -n ${NS}
check_role ${machine_to_kill}
echo "Pod recovered successfully!"
