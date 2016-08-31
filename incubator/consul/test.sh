#!/bin/sh

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

RELEASE=$1
NS=$2

if [ -z $RELEASE ]; then
	echo "Please specify Helm release name. eg. test.sh winsome-shark consul"
	exit 1
elif [ -z $NS ]; then
	echo "Please specify a Kubernetes namespace. eg. test.sh winsome-shark consul"
	exit 1
fi

for i in {0..2}; do
	if [ `kubectl exec $RELEASE-consul-$i consul members --namespace=$NS | grep server | wc -l` -ge "3" ]; then
    		echo "$RELEASE-consul-$i OK. consul members returning at least 3 records."
	else
    		echo "$RELEASE-consul-$i ERROR. consul members returning less than 3 records."
    		exit 1
	fi
done
