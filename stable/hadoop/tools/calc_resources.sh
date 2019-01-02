#!/bin/bash

# Calculates cluster resources given a percentage based on what is currently allocatable.
# Related issue to programmatic resource query: https://github.com/kubernetes/kubernetes/issues/27404

TARGET_PCT=$1

[[ -z "${TARGET_PCT}" ]] && echo "USAGE: $0 <target percent>" && exit 1

NODES=$(kubectl get nodes -o jsonpath='{.items..metadata.name}')
NUM_NODES=$(echo "${NODES}" | tr ' ' '\n' | wc -l | xargs echo -n)

TOTAL_CPU=$(kubectl get nodes -o jsonpath='{.items[0].status.allocatable.cpu}')
# Convert CPU to nanocores
TOTAL_CPU=$(bc <<< "${TOTAL_CPU} * 1000000000")

# Start kube proxy to get to node stats summary api
kubectl proxy >/dev/null 2>&1 &
export kproxy=%1

# Cleanup kproxy on exit
function finish {
  kill $kproxy
}
trap finish EXIT

# Wait for proxy
(while [[ $count -lt 5 && -z "$(curl -s localhost:8001/api/v1)" ]]; do ((count=count+1)) ; sleep 2; done && [[ $count -lt 5 ]])
[[ $? -ne 0 ]] && echo "ERROR: could not start kube proxy to fetch node stats summary" && exit 1

declare -a NODE_STATS
declare -a AVAIL_CPU
declare -a AVAIL_MEM
i=0
for NODE in ${NODES}; do
    NODE_STATS[$i]=$(curl -sf localhost:8001/api/v1/proxy/nodes/${NODE}:10255/stats/summary)
    [[ $? -ne 0 ]] && echo "ERROR: Could not get stats summary for node: ${NODE}" && exit 1

    # Get available memory
    AVAIL_MEM[$i]=$(jq '.node.memory.availableBytes' <<< "${NODE_STATS[$i]}")
    AVAIL_MEM[$i]=$(bc -l <<< "scale=0; ${AVAIL_MEM[$i]}/1024/1024")

    # Derive available CPU
    USED_CPU=$(jq '.node.cpu.usageNanoCores' <<< "${NODE_STATS[$i]}")
    AVAIL_CPU[$i]=$(bc -l <<< "scale=2; (${TOTAL_CPU} - ${USED_CPU})/1000000")
    ((i=i+1))
done

# Optimize per the min resources on any node.
CORES=$(echo "${AVAIL_CPU[*]}" | tr ' ' '\n' | sort -n  | head -1)
MEMORY=$(echo "${AVAIL_MEM[*]}" | tr ' ' '\n' | sort -n | head -1)

# Subtract resources used by the chart. Note these are default values.
HADOOP_SHARE_CPU=400
CORES=$(bc -l <<< "scale=0; (${CORES} - ${HADOOP_SHARE_CPU})")

HADOOP_SHARE_MEM=1024
MEMORY=$(bc -l <<< "scale=0; (${MEMORY} - ${HADOOP_SHARE_MEM})")

CPU_PER_NODE=$(bc -l <<< "scale=2; (${CORES} * ${TARGET_PCT}/100)")
MEM_PER_NODE=$(bc -l <<< "scale=2; (${MEMORY} * ${TARGET_PCT}/100)")

# Round cpu to lower mCPU
CPU_PER_NODE=$(bc -l <<< "scale=0; ${CPU_PER_NODE} - (${CPU_PER_NODE} % 10)")

# Round mem to lower Mi
MEM_PER_NODE=$(bc -l <<< "scale=0; ${MEM_PER_NODE} - (${MEM_PER_NODE} % 100)")

[[ "${CPU_PER_NODE/%.*/}" -lt 100 ]] && echo "WARN: Insufficient available CPU for scheduling" >&2
[[ "${MEM_PER_NODE/%.*/}" -lt 2048 ]] && MEM_PER_NODE=2048.0 && echo "WARN: Insufficient available Memory for scheduling" >&2

CPU_LIMIT=${CPU_PER_NODE/%.*/m}
MEM_LIMIT=${MEM_PER_NODE/%.*/Mi}

echo -n "--set yarn.nodeManager.replicas=${NUM_NODES},yarn.nodeManager.resources.requests.cpu=${CPU_LIMIT},yarn.nodeManager.resources.requests.memory=${MEM_LIMIT},yarn.nodeManager.resources.limits.cpu=${CPU_LIMIT},yarn.nodeManager.resources.limits.memory=${MEM_LIMIT}"
