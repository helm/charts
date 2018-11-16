#!/bin/bash

# set docker repository
DOCKER_REPO=quay.io/your_user_name

# image name
IMAGE=my_image

# use buildkite commit hash as a TAG
TAG=${BUILDKITE_COMMIT::8}

# make tmp folder
mkdir /tmp
cd /tmp

#  clone repo
env SSH_AUTH_SOCK= GIT_SSH_COMMAND='ssh -v -i ./buildkite' git clone ${BUILDKITE_REPO}

# cd to pulled repo folder
cd ${BUILDKITE_PIPELINE_SLUG}

# checkout branch
git checkout ${BUILDKITE_BRANCH}

# build docker image
echo -e "\n--- Building :docker: image ${IMAGE}:${TAG}"
docker build -t ${IMAGE}:${TAG} .

# cleaning up repo folder
echo "--- Cleaning up git repo folder ${BUILDKITE_PIPELINE_SLUG}"
rm -rf /tmp/${BUILDKITE_PIPELINE_SLUG}

# tag docker image
docker tag ${IMAGE}:${TAG} ${DOCKER_REPO}/${IMAGE}:${TAG}

# push to repository
echo "--- Pushing :docker: image ${DOCKER_REPO}/${IMAGE}:${TAG} to registry"
docker push ${DOCKER_REPO}/${IMAGE}:${TAG}

# local clean up
echo "--- Cleaning up :docker: image ${DOCKER_REPO}/${IMAGE}:${TAG}"
docker rmi -f ${DOCKER_REPO}/${IMAGE}:${TAG}
