#!/usr/bin/env bash

# Copyright 2018 The Kubernetes Authors. All rights reserved.
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

set -e pipefail

port=27017
replica_set="$REPLICA_SET"
script_name=${0##*/}
SECONDS=0
timeout="${TIMEOUT:-900}"
COUNTER=0

if [[ "$AUTH" == "true" ]]; then
    admin_user="$ADMIN_USER"
    admin_password="$ADMIN_PASSWORD"
    admin_creds=(-u "$admin_user" -p "$admin_password")
	
    if [[ "$METRICS" == "true" ]]; then
        metrics_user="$METRICS_USER"
        metrics_password="$METRICS_PASSWORD"
    fi
	
    auth_args=("--auth" "--keyFile=/data/configdb/key.txt")
fi

log() {
    local msg="$1"
    local timestamp
    timestamp=$(date --iso-8601=ns)
	echo "[$timestamp] [$script_name] $msg" 2>&1
    echo "[$timestamp] [$script_name] $msg" 2>&1 | tee -a /work-dir/log.txt 1>&2
}

retry_until() {
    local host="${1}"
    local command="${2}"
    local expected="${3}"
    local creds=("${admin_creds[@]}")

    # Don't need credentials for admin user creation and pings that run on localhost
    if [[ "${host}" =~ ^localhost ]]; then
        creds=()
    fi
    
	echo "trying to connect to server ${host} with credentials: ${creds[@]} with arguments: ${ssl_args[@]}"
	
    until [[ $(mongo admin --host "${host}" "${creds[@]}" "${ssl_args[@]}" --quiet --eval "${command}") == "${expected}" ]]; do
        sleep 1

        if (! ps "${pid}" &>/dev/null); then
            log "mongod shutdown unexpectedly"
            exit 1
        fi
		
		let COUNTER=COUNTER+1 
		
		if [[ "${COUNTER}" -eq 20 ]]; then
            log "Timed out after ${COUNTER}s attempting to bootstrap mongod"
            exit 1
        fi
		
        if [[ "${SECONDS}" -ge "${timeout}" ]]; then
            log "Timed out after ${timeout}s attempting to bootstrap mongod"
            exit 1
        fi

        log "Retrying ${command} on ${host}"
    done
}

shutdown_mongo() {
    local host="${1:-localhost}"
    local args='force: true'
    log "Shutting down MongoDB ($args)..."
    if (! mongo admin --host "${host}" "${admin_creds[@]}" "${ssl_args[@]}" --eval "db.shutdownServer({$args})"); then
      log "db.shutdownServer() failed, sending the terminate signal"
      kill -TERM "${pid}"
    fi
}

init_mongod_standalone() {
    if [[ ! -f /init/initMongodStandalone.js ]]; then
        log "Skipping init mongod standalone script"
        return 0
    elif [[ -z "$(ls -1A /data/db)" ]]; then
        log "mongod standalone script currently not supported on initial install"
        return 0
    fi

    local port="27018"
    log "Starting a MongoDB instance as standalone..."
    mongod --config /data/configdb/mongod.conf --dbpath=/data/db "${auth_args[@]}" --port "${port}" --bind_ip=0.0.0.0 2>&1 | tee -a /work-dir/log.txt 1>&2 &
    export pid=$!
    trap shutdown_mongo EXIT
    log "Waiting for MongoDB to be ready..."
    retry_until "localhost:${port}" "db.adminCommand('ping').ok" "1"
    log "Running init js script on standalone mongod"
    mongo admin --port "${port}" "${admin_creds[@]}" "${ssl_args[@]}" /init/initMongodStandalone.js
    shutdown_mongo "localhost:${port}"
}

my_hostname=$(hostname)
log "Bootstrapping MongoDB replica set member: $my_hostname"

log "Reading standard input..."
while read -ra line; do
    if [[ "${line}" == *"${my_hostname}"* ]]; then
        service_name="$line"
    fi
    peers=("${peers[@]}" "$line")
done

# Generate the ca cert
ca_crt=/data/configdb/tls.crt
if [ -f "$ca_crt"  ]; then
    log "Generating certificate"
    ca_key=/data/configdb/tls.key
    pem=/work-dir/mongo.pem
    ssl_args=(--ssl --sslCAFile "$ca_crt" --sslPEMKeyFile "$pem")

# Move into /work-dir
pushd /work-dir

cat >openssl.cnf <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]f
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $(echo -n "$my_hostname" | sed s/-[0-9]*$//)
DNS.2 = $my_hostname
DNS.3 = $service_name
DNS.4 = localhost
DNS.5 = 127.0.0.1
EOL

log "my_hostname: $my_hostname"

log "service_name: $service_name"

    export RANDFILE=/work-dir/.rnd
	
    # Generate the certs	
    openssl genrsa -out mongo.key 2048
    openssl req -new -key mongo.key -out mongo.csr -subj "/O=cert-manager/OU=MongoDB/CN=$my_hostname" -config openssl.cnf
    openssl x509 -req -in mongo.csr \
        -CA "$ca_crt" -CAkey "$ca_key" -CAcreateserial \
        -out mongo.crt -days 3650 -extensions v3_req -extfile openssl.cnf

	log "CA: $(cat $ca_crt)"
	log "CA KEY: $(cat $ca_key)"
	
    log "mongo.key: $(cat mongo.key)"
	log "mongo.crt: $(cat mongo.crt)"
	
    rm mongo.csr
    #openssl x509 -in mongo.crt -out mogo.pem -outform PEM
	#cat mogo.pem > $pem	
	
	#cat mongo.crt > $pem
	#cat mongo.key >> $pem
	#cat $ca_crt >> $pem	
	
	#echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDakNDQWZLZ0F3SUJBZ0lRQ1ZKbHlyVmdmMmlzK3ErRmVCaUhvVEFOQmdrcWhraUc5dzBCQVFzRkFEQW0KTVJVd0V3WURWUVFLRXd4alpYSjBMVzFoYm1GblpYSXhEVEFMQmdOVkJBTVRCR2xoWVdnd0hoY05NVGt3TlRJegpNVE15T0RVNFdoY05NVGt3T0RJeE1UTXlPRFU0V2pBbU1SVXdFd1lEVlFRS0V3eGpaWEowTFcxaGJtRm5aWEl4CkRUQUxCZ05WQkFNVEJHbGhZV2d3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ3MKOFNDZlp0d3pOQXZ2SXhZV29MMzJuQ0U2UzRUTWpIaVRGb2x6cVlqc3JQMjZxQmxCam5ZYXh4dmFGeXN6c3NveAoxV3psSlFSWFNyZmc1M0xyZnBWbVM3UXNXQ2pncmozdUxIeDlva0o4UzV6UzFaU1huNVpPaEo3RHJhREJtUndvCkNYTWVUUzFQbzR1K0Y3YVM5Y3NQTng5Y0gwblVLMDB5ZW1NS3MxSG14Q0ttVWJBYmVvS2lrOGdNc1RyWFlJS1AKZ2ZVbXUxNFBqaUhLeW5sallXTno5MW03QUtra2Q5eE81TjRWSUE1MnZvYmUrRDNPNXU1SFJ1V0wvUGFKZnlDQgowOHlSWDVJU3B0WU44NjJ1UVNIdE1oU3lZNENJYi9oeTlSUkN0TGxadXJmdVVmZWRLbVlaQmoyWTlnZTZnR3RQCkpPQWhCTnY5aklBK2ZrSS9Ra2tIQWdNQkFBR2pOREF5TUE0R0ExVWREd0VCL3dRRUF3SUNwREFQQmdOVkhSTUIKQWY4RUJUQURBUUgvTUE4R0ExVWRFUVFJTUFhQ0JHbGhZV2d3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUNLcwowLzM1ekhGTWdrTEpGem01THk0ZzdIRVdGNXM1OFZzcTJpeTZpSVlKdkhXVEdZUDdZTGdRK0hST3JpTEJPdURECi9aZ29nOGQrQXFCajNWY2dDOHlwUXBVdWJVK1RLbVlaZnJOU0RTOE5PcEQ3S2M3OE5nRW1vaTlIZzdBeld5SFQKend0VHB3ekJFNFl3d1Z5VVJCRzJTNXFKei83ZkFXU0pCRTlOTHBCOFN1dm95ZWlLUC9vVFJ3cmN0K1ZPLzUxYQoycGUrQjRuRy94WmkvcUlicE82N3NOeDllODJ1NnpoNzJIU0JHNUQ3cUlQT1IrUHRMT3FHYWlDTHNXWC9IZHpyCmNGUWtsdDIxK2pTeEdsWm5lUTBJU1lrZHJJMkVJNWNOVkRzSkZmMDZTUC9lSjVKTnBseXg4cGU0MXBKVDltb3UKYTRyWGJ3VmdxOWtIUmVpRzQ3TT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= > $pem
	#cat mongo.crt mongo.key >> $pem
	
	cat mongo.crt > $pem
	echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDakNDQWZLZ0F3SUJBZ0lRQ1ZKbHlyVmdmMmlzK3ErRmVCaUhvVEFOQmdrcWhraUc5dzBCQVFzRkFEQW0KTVJVd0V3WURWUVFLRXd4alpYSjBMVzFoYm1GblpYSXhEVEFMQmdOVkJBTVRCR2xoWVdnd0hoY05NVGt3TlRJegpNVE15T0RVNFdoY05NVGt3T0RJeE1UTXlPRFU0V2pBbU1SVXdFd1lEVlFRS0V3eGpaWEowTFcxaGJtRm5aWEl4CkRUQUxCZ05WQkFNVEJHbGhZV2d3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ3MKOFNDZlp0d3pOQXZ2SXhZV29MMzJuQ0U2UzRUTWpIaVRGb2x6cVlqc3JQMjZxQmxCam5ZYXh4dmFGeXN6c3NveAoxV3psSlFSWFNyZmc1M0xyZnBWbVM3UXNXQ2pncmozdUxIeDlva0o4UzV6UzFaU1huNVpPaEo3RHJhREJtUndvCkNYTWVUUzFQbzR1K0Y3YVM5Y3NQTng5Y0gwblVLMDB5ZW1NS3MxSG14Q0ttVWJBYmVvS2lrOGdNc1RyWFlJS1AKZ2ZVbXUxNFBqaUhLeW5sallXTno5MW03QUtra2Q5eE81TjRWSUE1MnZvYmUrRDNPNXU1SFJ1V0wvUGFKZnlDQgowOHlSWDVJU3B0WU44NjJ1UVNIdE1oU3lZNENJYi9oeTlSUkN0TGxadXJmdVVmZWRLbVlaQmoyWTlnZTZnR3RQCkpPQWhCTnY5aklBK2ZrSS9Ra2tIQWdNQkFBR2pOREF5TUE0R0ExVWREd0VCL3dRRUF3SUNwREFQQmdOVkhSTUIKQWY4RUJUQURBUUgvTUE4R0ExVWRFUVFJTUFhQ0JHbGhZV2d3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUNLcwowLzM1ekhGTWdrTEpGem01THk0ZzdIRVdGNXM1OFZzcTJpeTZpSVlKdkhXVEdZUDdZTGdRK0hST3JpTEJPdURECi9aZ29nOGQrQXFCajNWY2dDOHlwUXBVdWJVK1RLbVlaZnJOU0RTOE5PcEQ3S2M3OE5nRW1vaTlIZzdBeld5SFQKend0VHB3ekJFNFl3d1Z5VVJCRzJTNXFKei83ZkFXU0pCRTlOTHBCOFN1dm95ZWlLUC9vVFJ3cmN0K1ZPLzUxYQoycGUrQjRuRy94WmkvcUlicE82N3NOeDllODJ1NnpoNzJIU0JHNUQ3cUlQT1IrUHRMT3FHYWlDTHNXWC9IZHpyCmNGUWtsdDIxK2pTeEdsWm5lUTBJU1lrZHJJMkVJNWNOVkRzSkZmMDZTUC9lSjVKTnBseXg4cGU0MXBKVDltb3UKYTRyWGJ3VmdxOWtIUmVpRzQ3TT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= >> $pem
    cat mongo.key >> $pem
	
    #cat mongo.crt mongo.key > $pem
    rm mongo.key mongo.crt
fi

init_mongod_standalone

log "Peers: ${peers[*]}"
log "Starting a MongoDB replica"
mongod --config /data/configdb/mongod.conf --dbpath=/data/db --replSet="$replica_set" --port="${port}" "${auth_args[@]}" --bind_ip=0.0.0.0 2>&1 | tee -a /work-dir/log.txt 1>&2 &
pid=$!
trap shutdown_mongo EXIT

log "Waiting for MongoDB to be ready..."
retry_until "localhost" "db.adminCommand('ping').ok" "1"
log "Initialized."

# try to find a master
for peer in "${peers[@]}"; do
    log "Checking if ${peer} is primary"
    # Check rs.status() first since it could be in primary catch up mode which db.isMaster() doesn't show
    if [[ $(mongo admin --host "${peer}" "${admin_creds[@]}" "${ssl_args[@]}" --quiet --eval "rs.status().myState") == "1" ]]; then
        retry_until "${peer}" "db.isMaster().ismaster" "true"
        log "Found primary: ${peer}"
        primary="${peer}"
        break
    fi
done

if [[ "${primary}" = "${service_name}" ]]; then
    log "This replica is already PRIMARY"
elif [[ -n "${primary}" ]]; then
    if [[ $(mongo admin --host "${primary}" "${admin_creds[@]}" "${ssl_args[@]}" --quiet --eval "rs.conf().members.findIndex(m => m.host == '${service_name}:${port}')") == "-1" ]]; then
      log "Adding myself (${service_name}) to replica set..."
      if (mongo admin --host "${primary}" "${admin_creds[@]}" "${ssl_args[@]}" --eval "rs.add('${service_name}')" | grep 'Quorum check failed'); then
          log 'Quorum check failed, unable to join replicaset. Exiting prematurely.'
          exit 1
      fi
    fi

    sleep 3
    log 'Waiting for replica to reach SECONDARY state...'
    retry_until "${service_name}" "rs.status().myState" "2"
    log '✓ Replica reached SECONDARY state.'

elif (mongo "${ssl_args[@]}" --eval "rs.status()" | grep "no replset config has been received"); then
    log "Initiating a new replica set with myself ($service_name)..."
    mongo "${ssl_args[@]}" --eval "rs.initiate({'_id': '$replica_set', 'members': [{'_id': 0, 'host': '$service_name'}]})"

    sleep 3
    log 'Waiting for replica to reach PRIMARY state...'
    retry_until "localhost" "db.isMaster().ismaster" "true"
    primary="${service_name}"
    log '✓ Replica reached PRIMARY state.'

    if [[ "${AUTH}" == "true" ]]; then
        log "Creating admin user..."
        mongo admin "${ssl_args[@]}" --eval "db.createUser({user: '${admin_user}', pwd: '${admin_password}', roles: [{role: 'root', db: 'admin'}]})"
    fi
fi

# User creation
if [[ -n "${primary}" && "$AUTH" == "true" && "$METRICS" == "true" ]]; then
    metric_user_count=$(mongo admin --host "${primary}" "${admin_creds[@]}" "${ssl_args[@]}" --eval "db.system.users.find({user: '${metrics_user}'}).count()" --quiet)
    if [[ "${metric_user_count}" == "0" ]]; then
        log "Creating clusterMonitor user..."
        mongo admin --host "${primary}" "${admin_creds[@]}" "${ssl_args[@]}" --eval "db.createUser({user: '${metrics_user}', pwd: '${metrics_password}', roles: [{role: 'clusterMonitor', db: 'admin'}, {role: 'read', db: 'local'}]})"
    fi
fi

log "MongoDB bootstrap complete"
exit 0

