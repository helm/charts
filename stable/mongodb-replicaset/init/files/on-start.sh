#!/usr/bin/env bash

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

function join {
    local IFS="$1"; shift; echo "$*";
}

HOSTNAME=$(hostname)

# Read input from peer-finder
while read -ra LINE; do
    if [[ "${LINE}" == *"${HOSTNAME}"* ]]; then
        MY_NAME=$LINE
        continue
    fi
    PEERS=("${PEERS[@]}" $LINE)
done

# start a mongodb instance
/usr/bin/mongod --config=/config/mongod.conf &> /work-dir/log.txt &
until /usr/bin/mongo --eval 'printjson(db.serverStatus())'
do
  echo "Retrying..." >> /work-dir/log.txt
  sleep 2
done
echo "Initialized." >> /work-dir/log.txt

# try to find a master and add yourself to its replicaset.
for f in "${PEERS[@]}"
do
  /usr/bin/mongo --host="${f}" --eval="printjson(rs.isMaster())" | grep "\"ismaster\" : true"
  if [ $? -eq 0 ]; then
    echo "${f}" MASTER >> /work-dir/log.txt
    /usr/bin/mongo --host="${f}" --eval="printjson(rs.add('${MY_NAME}'))"
    exit 0
  fi
done

# else initiate a replicaset with yourself.
/usr/bin/mongo --eval="printjson(rs.status())" | grep "no replset config has been received"
if [ $? -eq 0 ]; then
  /usr/bin/mongo --eval="printjson(rs.initiate({'_id': '${RS}', 'members': [{'_id': 0, 'host': '${MY_NAME}'}]}))"
fi

# Do a clean shutdown of mongod
/usr/bin/mongo --eval "db.getSiblingDB('admin').shutdownServer({force: true})"
