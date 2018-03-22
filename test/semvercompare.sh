#!/bin/bash
# Copyright 2017 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

semvercompareOldVer=""
semvercompareNewVer=""

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

  semvercompareOldVer=`yaml r /tmp/Chart.yaml version`
  semvercompareNewVer=`yaml r $1/Chart.yaml version`

  # Pre-releases may not be API compatible. So, when tools compare versions
  # they often skip pre-releases. vert can force looking at pre-releases by
  # adding a dash on the end followed by pre-release. -0 on the end will force
  # looking for all valid pre-releases since a prerelease cannot start with a 0.
  # For example, 1.2.3-0 will include looking for pre-releases.
  local ret
  local out
  if [[ $semvercompareOldVer == *"-"* ]]; then  # Found the - to denote it has a pre-release
    out=$(vert ">$semvercompareOldVer" $semvercompareNewVer)
    ret=$?
  else
    # No pre-release was found so we increment the patch version and attach a
    # -0 to enable pre-releases being found.
    local ov=( ${semvercompareOldVer//./ } )  # Turn the version into an array
    ((ov[2]+=1))                  # Increment the patch release
    out=$(vert ">${ov[0]}.${ov[1]}.${ov[2]}-0" $semvercompareNewVer)
    ret=$?
  fi

  if [ $ret -ne 0 ]; then
    echo "Error please increment the new chart version to be greater than the existing version of $semvercompareOldVer"
    exitCode=1
  else
    echo "New higher version $semvercompareNewVer found"
  fi

  # Clean up
  rm /tmp/Chart.yaml
}