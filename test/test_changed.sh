#!/bin/bash -xe
UPSTREAM_BRANCH="upstream/master"

CHANGED_FOLDERS=`git diff --name-only ${UPSTREAM_BRANCH} | grep -v test | grep / | uniq`
for directory in ${CHANGED_FOLDERS}; do
  "helm lint ${directory}"
done
