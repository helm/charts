#!/usr/bin/env bash

    MONGOCACRT=/ca/tls.crt
    MONGOPEM=/work-dir/mongo.pem
    if [ -f $MONGOPEM ]; then
        MONGOARGS="--ssl --sslCAFile $MONGOCACRT --sslPEMKeyFile $MONGOPEM"
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
            response=$(mongo "$MONGOARGS" "--host=$(pod_name $i)" "--eval=rs.isMaster().ismaster")
            if [[ $response =~ "true" ]]; then
                pod_name "$i"
                break
            fi
        done
    }

    setup() {
        local ready=0
        until [[ $ready -eq $(replicas) ]]; do
            echo "Waiting for application to become ready" >&2
            sleep 1

            for ((i = 0; i < $(replicas); ++i)); do
                response=$(mongo "$MONGOARGS" "--host=$(pod_name $i)" "--eval=rs.status()" || true)
                if [[ $response =~ .*ok.* ]]; then
                    ready=$((ready + 1))
                fi
            done
        done
    }

    @test "Testing mongodb client is accessible" {
        mongo -h
        [ "$?" -eq 0 ]
    }

    @test "Connect mongodb client to mongodb pods" {
        for ((i = 0; i < $(replicas); ++i)); do
            response=$(mongo "$MONGOARGS" "--host=$(pod_name $i)" "--eval=rs.status()")
            if [[ ! $response =~ .*ok.* ]]; then
                exit 1
            fi
        done
    }

    @test "Write key to master" {
        response=$(mongo "$MONGOARGS" --host=$(master_pod) "--eval=db.test.insert({\"abc\": \"def\"}).nInserted")
        if [[ ! $response =~ "1" ]]; then
            exit 1
        fi
    }

    @test "Read key from slaves" {
        # wait for slaves to catch up
        sleep 10

        for ((i = 0; i < $(replicas); ++i)); do
            response=$(mongo "$MONGOARGS" --host=$(pod_name $i) "--eval=rs.slaveOk(); db.test.find({\"abc\":\"def\"})")
            if [[ ! $response =~ .*def.* ]]; then
                exit 1
            fi
        done
    }
