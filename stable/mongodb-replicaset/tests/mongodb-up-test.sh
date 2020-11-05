#!/usr/bin/env bash

set -ex

CACRT_FILE=/work-dir/tls.crt
CAKEY_FILE=/work-dir/tls.key
MONGOPEM=/work-dir/mongo.pem

MONGOARGS="--quiet"

if [ -e "/tls/tls.crt" ]; then
    # log "Generating certificate"
    mkdir -p /work-dir
    cp /tls/tls.crt /work-dir/tls.crt
    cp /tls/tls.key /work-dir/tls.key

    # Move into /work-dir
    pushd /work-dir

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
DNS.1 = $(echo -n "$(hostname)" | sed s/-[0-9]*$//)
DNS.2 = $(hostname)
DNS.3 = localhost
DNS.4 = 127.0.0.1
EOL

    # Generate the certs
    openssl genrsa -out mongo.key 2048
    openssl req -new -key mongo.key -out mongo.csr -subj "/OU=MongoDB/CN=$(hostname)" -config openssl.cnf
    openssl x509 -req -in mongo.csr \
        -CA "$CACRT_FILE" -CAkey "$CAKEY_FILE" -CAcreateserial \
        -out mongo.crt -days 3650 -extensions v3_req -extfile openssl.cnf
    cat mongo.crt mongo.key > $MONGOPEM
    MONGOARGS="$MONGOARGS --ssl --sslCAFile $CACRT_FILE --sslPEMKeyFile $MONGOPEM"
fi

if [[ "${AUTH}" == "true" ]]; then
    MONGOARGS="$MONGOARGS --username $ADMIN_USER --password $ADMIN_PASSWORD --authenticationDatabase admin"
fi

pod_name() {
    local full_name="${FULL_NAME?Environment variable FULL_NAME not set}"
    local namespace="${NAMESPACE?Environment variable NAMESPACE not set}"
    local index="$1"
    echo "$full_name-$index.$full_name.$namespace.svc.cluster.local"
}

replicas() {
    echo "${REPLICAS?Environment variable REPLICAS not set}"
}

master_pod() {
    for ((i = 0; i < $(replicas); ++i)); do
        response=$(mongo $MONGOARGS "--host=$(pod_name "$i")" "--eval=rs.isMaster().ismaster")
        if [[ "$response" == "true" ]]; then
            pod_name "$i"
            break
        fi
    done
}

setup() {
    local ready=0
    until [[ "$ready" -eq $(replicas) ]]; do
        echo "Waiting for application to become ready" >&2
        sleep 1
        ready=0
        for ((i = 0; i < $(replicas); ++i)); do
            response=$(mongo $MONGOARGS "--host=$(pod_name "$i")" "--eval=rs.status().ok" || true)
            if [[ "$response" -eq 1 ]]; then
                ready=$((ready + 1))
            fi
        done
    done
}

@test "Testing mongodb client is executable" {
    mongo -h
    [ "$?" -eq 0 ]
}

@test "Connect mongodb client to mongodb pods" {
    for ((i = 0; i < $(replicas); ++i)); do
        response=$(mongo $MONGOARGS "--host=$(pod_name "$i")" "--eval=rs.status().ok")
        if [[ ! "$response" -eq 1 ]]; then
            exit 1
        fi
    done
}

@test "Write key to primary" {
    response=$(mongo $MONGOARGS --host=$(master_pod) "--eval=db.test.insert({\"abc\": \"def\"}).nInserted")
    if [[ ! "$response" -eq 1 ]]; then
        exit 1
    fi
}

@test "Read key from slaves" {
    # wait for slaves to catch up
    sleep 10

    for ((i = 0; i < $(replicas); ++i)); do
        response=$(mongo $MONGOARGS --host=$(pod_name "$i") "--eval=rs.slaveOk(); db.test.find({\"abc\":\"def\"})")
        if [[ ! "$response" =~ .*def.* ]]; then
            exit 1
        fi
    done

    # Clean up a document after test
    mongo $MONGOARGS --host=$(master_pod) "--eval=db.test.deleteMany({\"abc\": \"def\"})"
}
