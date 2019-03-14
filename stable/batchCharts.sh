#!/bin/bash

SEMVER=2

increment_version() {
  # Get flags.
  local flag_remove_leading_zeros=0
  local flag_drop_trailing_zeros=0
  while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "--" ]; then
      shift
      break
    elif [ "$1" == "-l" ]; then
      flag_remove_leading_zeros=1
    elif [ "$1" == "-t" ]; then
      flag_drop_trailing_zeros=1
    else
      return 1
    fi
    shift
  done

  # Get arguments.
  if [ ${#@} -lt 1 ]; then
    return 1
  fi
  local v="${1}"             # version string
  local targetPos=${2-last}  # target position
  local minPos=${3-${2-0}}   # minimum position

  # Split version string into array using its periods.
  local IFSbak; IFSbak=IFS; IFS='.' # IFS restored at end of func to
  read -ra v <<< "$v"               #  avoid breaking other scripts.

  # Determine target position.
  if [ "${targetPos}" == "last" ]; then
    if [ "${minPos}" == "last" ]; then
      minPos=0
    fi
    targetPos=$((${#v[@]}>minPos?${#v[@]}:minPos));
  fi
  if [[ ! ${targetPos} -gt 0 ]]; then
    return 1
  fi
  (( targetPos--  )) || true # offset to match array index

  # Make sure minPosition exists.
  while [ ${#v[@]} -lt ${minPos} ]; do
    v+=("0")
  done

  # Increment target position.
  v[$targetPos]=$(printf %0${#v[$targetPos]}d $((10#${v[$targetPos]}+1)));

  # Remove leading zeros, if -l flag passed.
  if [ $flag_remove_leading_zeros == 1 ]; then
    for (( pos=0; pos<${#v[@]}; pos++ )); do
      v[$pos]=$((${v[$pos]}*1))
    done
  fi

  # If targetPosition was not at end of array, reset following positions to
  #   zero (or remove them if -t flag was passed).
  if [[ ${flag_drop_trailing_zeros} -eq "1" ]]; then
    for (( p=$((${#v[@]}-1)); p>targetPos; p-- )); do
      unset v["$p"]
    done
  else
    for (( p=$((${#v[@]}-1)); p>targetPos; p-- )); do
      v[$p]=0
    done
  fi

  echo "${v[*]}"
  IFS=IFSbak
  return 0
}

SEMVER=2
for item in *; do
  if [ -d "$item" ]; then
    cd "$item" || exit
    if  grep -q 'containers@bitnami.com' 'Chart.yaml'; then
      CHART="$(basename "$(pwd)")"
      echo "Bitnami chart found: ${CHART}"
      git checkout -b "${CHART}"
      CURRENT_VERSION="$(grep 'version:' 'Chart.yaml' | cut -d' ' -f2)"
      NEW_VERSION="$(increment_version "$CURRENT_VERSION" "$SEMVER")"
      echo "-- Bumping version from ${CURRENT_VERSION} to ${NEW_VERSION}"
      sed -i -e "s/${CURRENT_VERSION}/${NEW_VERSION}/g" Chart.yaml
    fi
    cd .. || exit
  fi
done
