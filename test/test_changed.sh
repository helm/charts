#!/bin/bash -xe
UPSTREAM_BRANCH="upstream/master"

CHANGED_FOLDERS=`git diff --name-only ${UPSTREAM_BRANCH} | grep -v test | grep / | uniq | awk -F/ '{print $2}'`
for directory in ${CHANGED_FOLDERS}; do
  "/opt/linux-amd64/helm lint ${directory}"
done
