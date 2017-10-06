#!/bin/bash
# Copyright 2017 The Kubernetes Authors All rights reserved.
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

# Compare to the merge-base rather than master to limit scanning to changes
# this PR/changeset is introducing. Making sure the comparison is to the
# upstream charts repo rather than a fork.

exitCode=0

# Run is a wrapper around the execution of functions. It captures non-zero exit
# codes and remembers an error happened. This enables running all the linters
# and capturing if any of them failed.
run() {
  $@
  local ret=$?
  if [ $ret -ne 0 ]; then
    exitCode=1
  fi
}

git remote add k8s https://github.com/kubernetes/charts
git fetch k8s master
CHANGED_FOLDERS=`git diff --find-renames --name-only $(git merge-base k8s/master HEAD) stable/ incubator/ | awk -F/ '{print $1"/"$2}' | uniq`

# Exit early if no charts have changed
if [ -z "$CHANGED_FOLDERS" ]; then
  echo "No changes to charts found"
  exit 0
fi

for directory in ${CHANGED_FOLDERS}; do
  if [ "$directory" == "incubator/common" ]; then
    continue
  elif [ -d $directory ]; then
    run helm lint ${directory}

    # If a Chart.yaml file is present lint it. Otherwise report an error
    # because one should exist
    if [ -e ${directory}/Chart.yaml ]; then
      run yamllint -c test/circle/lintconf.yml ${directory}/Chart.yaml
    else
      echo "Error ${directory}/Chart.yaml file is missing"
      exitCode=1
    fi

    # If a values.yaml file is present lint it. Otherwise report an error
    # because one should exist
    if [ -e ${directory}/values.yaml ]; then
      run yamllint -c test/circle/lintconf.yml ${directory}/values.yaml
    else
      echo "Error ${directory}/values.yaml file is missing"
      exitCode=1
    fi
  fi
done

exit $exitCode