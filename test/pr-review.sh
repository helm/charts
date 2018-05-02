#!/bin/bash -xe

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

usage() {
  echo "Usage: $0 PR_NUMBER" 1>&2;
  exit 1;
}

if [ -z "${PULL_NUMBER}" ]; then
  if [ -z "$1" ];then
    usage
  fi
  PR_NUMBER=$1
fi

export VERIFICATION_PAUSE=${VERIFICATION_PAUSE:=180}

BRANCH_NAME=pr-${PULL_NUMBER}
CURRENT_BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
if [ "${BRANCH_NAME}" = "$CURRENT_BRANCH_NAME" ];then
  echo "Checking out master so that we can overwrite the current branch"
  git checkout master
fi

git fetch -f origin pull/${PULL_NUMBER}/head:${BRANCH_NAME}
git checkout ${BRANCH_NAME}
git rebase master
export BUILD_ID=0
./test/e2e.sh
git checkout master
git branch -D ${BRANCH_NAME}
