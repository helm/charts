#!/usr/bin/env bash

# Author: Chris Dornsife chris@dornsife.com
# This will run a build container and extract a binary.
# This doesn't require the use of a mount so it can be used
# in a build pipeline such as bitbucket.
PROJ=rethinkdb-probe

HASH=`date +%s`
BUILD_NAME=${PROJ}-build-${HASH}

docker build -t ${BUILD_NAME} -f ./Dockerfile.build . || exit 1
docker create --name ${BUILD_NAME} ${BUILD_NAME} /bin/true || exit 1
docker cp ${BUILD_NAME}:/target/$PROJ ./$PROJ || exit 1
docker rm ${BUILD_NAME} || exit 1
docker rmi -f ${BUILD_NAME} || exit 1

chmod +x ./$PROJ
