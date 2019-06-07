#!/usr/bin/env bash

MONGOCACRT=/ca/tls.crt
MONGOPEM=/work-dir/mongo.pem

MONGOARGS="--quiet"

if [ -f "$MONGOPEM" ]; then
    MONGOARGS="$MONGOARGS --ssl --sslCAFile $MONGOCACRT --sslPEMKeyFile $MONGOPEM"
fi

if [[ "${AUTH}" == "true" ]]; then
    MONGOARGS="$MONGOARGS --username $ADMIN_USER --password $ADMIN_PASSWORD --authenticationDatabase admin"
fi

pod_name() {
    local full_name="${FULL_NAME?Environment variable FULL_NAME not set}"
    local index="$1"
    echo "$full_name-$index.$full_name"
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
