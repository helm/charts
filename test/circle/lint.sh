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

# Lint the Chart.yaml and values.yaml files for Helm
yamllinter() {
  printf "\nLinting the Chart.yaml and values.yaml files at ${1}\n"

  # If a Chart.yaml file is present lint it. Otherwise report an error
  # because one should exist
  if [ -e $1/Chart.yaml ]; then
    run yamllint -c test/circle/lintconf.yml $1/Chart.yaml
  else
    echo "Error $1/Chart.yaml file is missing"
    exitCode=1
  fi

  # If a values.yaml file is present lint it. Otherwise report an error
  # because one should exist
  if [ -e $1/values.yaml ]; then
    run yamllint -c test/circle/lintconf.yml $1/values.yaml
  else
    echo "Error $1/values.yaml file is missing"
    exitCode=1
  fi
}

# Validate the Chart.yaml
validate_chart_yaml() {

  run yamale -s test/circle/yaml-schemas/Chart.yaml ${1}/Chart.yaml

  echo "Validating maintainers names"

  for name in $(yaml r ${1}/Chart.yaml maintainers.[*].name|cut -d " " -f2); do
    if [ $(curl -s -o /dev/null -w "%{http_code}\n" -If https://github.com/${name}) -ne 200 ]; then
      echo "Error: Sorry ${name} is not a valid GitHub account. Please use a valid GitHub account to help us communicate with you in PR/issues."
      exitCode=1
    fi
  done
}

# include the semvercompare function
curDir="$(dirname "$0")"
source "$curDir/../semvercompare.sh"
if [[ -z ${1} ]]; then
  git remote add k8s https://github.com/kubernetes/charts
  git fetch k8s master
  CHANGED_FOLDERS=`git diff --find-renames --name-only $(git merge-base k8s/master HEAD) stable/ incubator/ | awk -F/ '{print $1"/"$2}' | uniq`
else
  CHANGED_FOLDERS=( ${1} "" )
fi

# Exit early if no charts have changed
if [ -z "$CHANGED_FOLDERS" ]; then
  echo "No changes to charts found"
  exit 0
fi

for directory in ${CHANGED_FOLDERS}; do
  if [ "$directory" == "incubator/common" ]; then
    continue
  elif [ -d $directory ]; then
    printf "\nRunning helm dep build on the chart at ${directory}\n"
    run helm dep build ${directory}

    printf "\nRunning helm lint on the chart at ${directory}\n"
    run helm lint ${directory}

    yamllinter ${directory}

    validate_chart_yaml ${directory}

    semvercompare ${directory}

    # Check for the existence of the NOTES.txt file. This is required for charts
    # in this repo.
    if [ ! -f ${directory}/templates/NOTES.txt ]; then
      echo "Error NOTES.txt template not found. Please create one."
      echo "For more information see https://docs.helm.sh/developing_charts/#chart-license-readme-and-notes"
      exitCode=1
    fi

  fi
done

exit $exitCode

