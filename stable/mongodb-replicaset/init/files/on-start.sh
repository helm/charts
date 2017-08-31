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

replica_set=$REPLICA_SET
script_name=${0##*/}

if [[ "$AUTH" == "true" ]]; then
    admin_user="$ADMIN_USER"
    admin_password="$ADMIN_PASSWORD"
    admin_auth=(-u "$admin_user" -p "$admin_password")
fi

function log() {
    local msg="$1"
    local timestamp=$(date --iso-8601=ns)
    echo "[$timestamp] [$script_name] $msg" >> /work-dir/log.txt
}

function shutdown_mongo() {
    if [[ $# -eq 1 ]]; then
        args="timeoutSecs: $1"
    else
        args='force: true'
    fi
    log "Shutting down MongoDB ($args)..."
    mongo admin "${admin_auth[@]}" "${ssl_args[@]}" --eval "db.shutdownServer({$args})"
}

my_hostname=$(hostname)
log "Bootstrapping MongoDB replica set member: $my_hostname"

log "Reading standard input..."
while read -ra line; do
    if [[ "${line}" == *"${my_hostname}"* ]]; then
        service_name="$line"
        continue
    fi
    peers=("${peers[@]}" "$line")
done

# Generate the ca cert
ca_crt=/ca/tls.crt
if [ -f $ca_crt  ]; then
    log "Generating certificate"
    ca_key=/ca/tls.key
    pem=/work-dir/mongo.pem
    ssl_args=(--ssl --sslCAFile $ca_crt --sslPEMKeyFile $pem)

cat >openssl.cnf <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
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

    # Generate the certs
    openssl genrsa -out mongo.key 2048
    openssl req -new -key mongo.key -out mongo.csr -subj "/CN=$my_hostname" -config openssl.cnf
    openssl x509 -req -in mongo.csr \
        -CA $ca_crt -CAkey $ca_key -CAcreateserial \
        -out mongo.crt -days 3650 -extensions v3_req -extfile openssl.cnf

    rm mongo.csr
    cat mongo.crt mongo.key > $pem
    rm mongo.key mongo.crt
fi


log "Peers: ${peers[@]}"

log "Starting a MongoDB instance..."
mongod --config /config/mongod.conf >> /work-dir/log.txt 2>&1 &

log "Waiting for MongoDB to be ready..."
until mongo "${ssl_args[@]}" --eval "db.adminCommand('ping')"; do
    log "Retrying..."
    sleep 2
done

log "Initialized."

# try to find a master and add yourself to its replica set.
for peer in "${peers[@]}"; do
    mongo admin --host "$peer" "${admin_auth[@]}" "${ssl_args[@]}" --eval "rs.isMaster()" | grep '"ismaster" : true'
    if [[ $? -eq 0 ]]; then
        log "Found master: $peer"
        log "Adding myself ($service_name) to replica set..."
        mongo admin --host "$peer" "${admin_auth[@]}" "${ssl_args[@]}" --eval "rs.add('$service_name')"
        log "Done."

        shutdown_mongo "60"
        log "Good bye."
        exit 0
    fi
done

# else initiate a replica set with yourself.
mongo "${ssl_args[@]}" --eval "rs.status()" | grep "no replset config has been received"
if [[ $? -eq 0 ]]; then
    log "Initiating a new replica set with myself ($service_name)..."
    mongo "${ssl_args[@]}" --eval "rs.initiate({'_id': '$replica_set', 'members': [{'_id': 0, 'host': '$service_name'}]})"

    mongo "${ssl_args[@]}" --eval "rs.status()"

    if [[ "$AUTH" == "true" ]]; then
        # sleep a little while just to be sure the initiation of the replica set has fully
        # finished and we can create the user
        sleep 3

        log "Creating admin user..."
        mongo admin "${ssl_args[@]}" --eval "db.createUser({user: '$admin_user', pwd: '$admin_password', roles: [{role: 'root', db: 'admin'}]})"
    fi

    log "Done."
fi

shutdown_mongo
log "Good bye."
