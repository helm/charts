#!/bin/bash -xe
UPSTREAM_BRANCH="origin/master"

CHANGED_FOLDERS=`git diff --name-only ${UPSTREAM_BRANCH} | grep -v test | grep / | awk -F/ '{print $1"/"$2}' | uniq`
for directory in ${CHANGED_FOLDERS}; do
  /opt/linux-amd64/helm init --client-only
  /opt/linux-amd64/helm lint ${directory}
done
