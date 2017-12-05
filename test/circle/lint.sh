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

# Verify that the semver for the chart was increased
semvercompare() {
  printf "\nChecking the Chart version has increased for the chart at ${1}\n"

  # Checkout the Chart.yaml file on master to read the version for comparison
  # Sending the output to a file and the error to /dev/null so that these
  # messages do not clutter up the end user output
  $(git show k8s/master:$1/Chart.yaml 1> /tmp/Chart.yaml 2> /dev/null)

  ## If the chart is new git cannot checkout the chart. In that case return
  if [ $? -ne 0 ]; then
    echo "Unable to find Chart on master. New chart detected."
    return
  fi

  local oldVer=`yaml r /tmp/Chart.yaml version`
  local newVer=`yaml r $1/Chart.yaml version`

  # Pre-releases may not be API compatible. So, when tools compare versions
  # they often skip pre-releases. vert can force looking at pre-releases by
  # adding a dash on the end followed by pre-release. -0 on the end will force
  # looking for all valid pre-releases since a prerelease cannot start with a 0.
  # For example, 1.2.3-0 will include looking for pre-releases.
  local ret
  local out
  if [[ $oldVer == *"-"* ]]; then  # Found the - to denote it has a pre-release
    out=$(vert ">$oldVer" $newVer)
    ret=$?
  else
    # No pre-release was found so we increment the patch version and attach a
    # -0 to enable pre-releases being found.
    local ov=( ${oldVer//./ } )  # Turn the version into an array
    ((ov[2]++))                  # Increment the patch release
    out=$(vert ">${ov[0]}.${ov[1]}.${ov[2]}-0" $newVer)
    ret=$?
  fi

  if [ $ret -ne 0 ]; then
    echo "Error please increment the new chart version to be greater than the existing version of $oldVer"
    exitCode=1
  else
    echo "New higher version $newVer found"
  fi

  # Clean up
  rm /tmp/Chart.yaml
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
    printf "\nRunning helm dep build on the chart at ${directory}\n"
    run helm dep build ${directory}

    printf "\nRunning helm lint on the chart at ${directory}\n"
    run helm lint ${directory}

    yamllinter ${directory}

    semvercompare ${directory}

    # Check for the existance of the NOTES.txt file. This is required for charts
    # in this repo.
    if [ ! -f ${directory}/templates/NOTES.txt ]; then
      echo "Error NOTES.txt template not found. Please create one."
      echo "For more information see https://docs.helm.sh/developing_charts/#chart-license-readme-and-notes"
      exitCode=1
    fi

  fi
done

exit $exitCode