#! /bin/bash

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

NS="${RELEASE_NAMESPACE:-default}"
POD_NAME="${RELEASE_NAME:-mongo}-mongodb-replicaset"

MONGOCACRT=/ca/tls.crt
MONGOPEM=/work-dir/mongo.pem
if [ -f $MONGOPEM ]; then
    MONGOARGS="--ssl --sslCAFile $MONGOCACRT --sslPEMKeyFile $MONGOPEM"
fi

for i in $(seq 0 2); do
    pod="${POD_NAME}-$i"
    kubectl exec --namespace $NS $pod -- sh -c 'mongo '"$MONGOARGS"' --eval="printjson(rs.isMaster())"' | grep '"ismaster" : true'

    if [ $? -eq 0 ]; then
        echo "Found master: $pod"
        MASTER=$pod
        break
    fi
done

kubectl exec --namespace $NS $MASTER -- mongo "$MONGOARGS" --eval='printjson(db.test.insert({"status": "success"}))'

# TODO: find maximum duration to wait for slaves to be up-to-date with master.
sleep 2

for i in $(seq 0 2); do
    pod="${POD_NAME}-$i"
    if [[ $pod != $MASTER ]]; then
        echo "Reading from slave: $pod"
        kubectl exec --namespace $NS $pod -- mongo "$MONGOARGS" --eval='rs.slaveOk(); db.test.find().forEach(printjson)'
    fi
done
