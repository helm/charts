#!/bin/bash
# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
VERSION=v1.10
CONTAINER_NAME=test-image

usage() {
  echo "Usage: $0 [-p]" 1>&2;
  echo " -p PROJECT_ID"
  echo " -d will deploy to gcr.io"
  echo " -r REPO_IP will override gcr.io and deploy docker to local repo"
  exit 1;
}

if [ $? != 0 ] ; then usage ; fi

while getopts "p:hd" o; do
    case "${o}" in
        p)
         PROJECT_ID=${OPTARG}
         ;;
        d)
         DEPLOY=true
         ;;
        r)
         REPO_URL=${OPTARG}
         ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "$PROJECT_ID" ]; then
  usage
fi

REPO=gcr.io/$PROJECT_ID
DOCKER="${REPO}/${CONTAINER_NAME}:${VERSION}"

docker build -t ${DOCKER} .

if [ "${DEPLOY}" ]; then
  if [ -z $REPO_URL ]; then
    gcloud docker push ${DOCKER}
  else
    docker push ${DOCKER}
  fi
fi
