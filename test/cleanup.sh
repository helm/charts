#!/bin/bash
# Copyright 2018 The Kubernetes Authors All rights reserved.
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

# This script looks for orphaned helm releases and namespace in the CI system
# and cleans them up. It only needs to be run periodically.
# Orphaned releases are seen as those greater than 5 hours old.

# NOTE: This script is designed to be run in Darwin (MacOS) and GNU/Linux systems.
# Since date commands can vary between systems there has not been testing outside
# of these.

# Opt-in to installing Helm if not local
if [ -n "${INSTALL_HELM}" ]; then
  HELM_URL=https://storage.googleapis.com/kubernetes-helm
  HELM_TARBALL=helm-v2.7.2-linux-amd64.tar.gz

  # THis is the same place CI normally installs Helm
  pushd /opt
    wget -q ${HELM_URL}/${HELM_TARBALL}
    tar xzfv ${HELM_TARBALL}
    PATH=/opt/linux-amd64/:$PATH
  popd
fi

helm ls | while read line; do

  rel=$(echo $line | awk '{ print $1 }')
  ns=$(echo $line | awk '{ print $10 }')

  # Skip the header row
  if [[ "$rel" == "NAME" ]]; then
    continue
  fi

  # Get the date parts
  month=$(echo $line | awk '{ print $4 }')
  day=$(echo $line | awk '{ print $5 }')
  year=$(echo $line | awk '{ print $7 }')
  tod=$(echo $line | awk '{ print $6 }')

  # Mac and Linux use different date commands due to their heritage (GNU vs BSD)
  # Here we detect the OS to run two different commands as this may be run on
  # differing systems
  unamestr=`uname`
  if [[ "$unamestr" == 'Darwin' ]]; then
    # The cut is calculated as now minus 5 hours
    cut=$(date -j -v-5H +%s)
    comdate=$(date -j -f "%b %d %Y %T" "$month $day $year $tod" +"%s")
  else
    # The cut is calculated as now minus 5 hours
    cut=$(date --date="now - 5 hours" +%s)
    comdate=$(date --date="$month $day $year $tod" +%s)
  fi

  # Compare the dates to find those items to act on
  if [ $comdate -ge $cut ]; then
    echo "Not purging $rel as it may still be running"
  else
    echo "Purging $rel as it should no longer be in use"
    echo "$rel is from $month $day $year $tod"
    helm delete --purge $rel
    kubectl delete ns $ns
  fi

done