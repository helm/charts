#! /bin/bash

# Copyright 2016 The Kubernetes Authors All rights reserved.
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

POD_NAME=$RELEASE_NAME-mongodb-replicaset
POD_NAME=${POD_NAME:0:24}

kubectl exec "$POD_NAME-0" -- /usr/bin/mongo --eval="printjson(db.test.insert({\"status\": \"success\"}))"
# TODO: find maximum duration to wait for slaves to be up-to-date with master.
sleep 2
kubectl exec "$POD_NAME-1" -- /usr/bin/mongo --eval="rs.slaveOk(); db.test.find().forEach(printjson)"
kubectl exec "$POD_NAME-2" -- /usr/bin/mongo --eval="rs.slaveOk(); db.test.find().forEach(printjson)"
