#!/bin/bash -xe
UPSTREAM_BRANCH="origin/master"
CHANGED_FOLDERS=`git diff --name-only ${UPSTREAM_BRANCH} | grep / | awk -F/ '{print \$1}' | uniq`

for directory in ${CHANGED_FOLDERS}; do
  "./linux-amd64/helm lint ${directory}"
done
