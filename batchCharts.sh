#!/bin/bash

## Constants
CHANGES_SCRIPT="$(pwd)/changes.sh"
FORKED_REPO=~/projects/forkHelmCharts
COMMIT_MESSAGE=""
TARGET="stable"
SEMVER_TARGET=""

## Color palette
RESET='\033[0m'
RED='\033[38;5;1m'
GREEN='\033[38;5;2m'
YELLOW='\033[38;5;3m'

## Logging functions
output() {
    echo -e "$1"
}
log() {
    printf "%b\n" "${*}" >&2
}
info() {
    log "${GREEN}INFO ${RESET} ==> ${*}"
}
warn() {
    log "${YELLOW}WARN ${RESET} ==> ${*}"
}
error() {
    log "${RED}ERROR ${RESET} ==> ${*}"
}

## Git functions
update_master() {
    git checkout master
    git fetch upstream master
    git pull upstream master
    git push origin master
}

print_menu() {
  SCRIPT=$(basename "$0")
  output "${RED}NAME${RESET}"
  output "    $(basename -s .sh "$0") - Charts batch editing script"
  output "    $SCRIPT [${BLUE}-h${RESET}] [${BLUE}-m ${GREEN}\"commit message\"${RESET}] [${BLUE}-t ${GREEN}\"target\"${RESET}] [${BLUE}-s ${GREEN}\"semver target\"${RESET}]"
  output ""
  output "${RED}SINOPSIS${RESET}"
  output ""
  output "    The options are as follow:"
  output ""
  output "      ${BLUE}-m, --message   ${GREEN}[commit_message]${RESET}      Commit message to use"
  output "      ${BLUE}-t, --target    ${GREEN}[target]${RESET}              Target (incubator/stable)"
  output "      ${BLUE}-s, --semver    ${GREEN}[semver_target]${RESET}       Semver Target (patch/minor/major)"
  output ""
  output "${RED}EXAMPLES${RESET}"
  output "      $SCRIPT -h"
  output "      $SCRIPT --message \"Add new parameter\" --target \"stable\" --semver \"minor\""
}

INITIAL_ARGUMENTS="$#"
HELP_REQUESTED=0
if ! options=$(getopt -o hm:t:s: -l help,message:,target:,semver: -- "$@"); then
  exit 1
fi
eval set -- $options
while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help) HELP_REQUESTED=1 ;;
    -m|--message) COMMIT_MESSAGE="$2" ;;
    -t|--target) TARGET="$2" ;;
    -s|--semver) SEMVER_TARGET="$2" ;;
    (--) shift; break;;
    (-*) error "unrecognized option $1"; exit 1;;
    (*) break;;
  esac
  shift
done

if [[ "$HELP_REQUESTED" -eq 1 || "$INITIAL_ARGUMENTS" -eq 0 ]]; then
  print_menu
  exit 0
fi

SEMVER=3
case "$SEMVER_TARGET" in
  major)
    SEMVER=1; info "Major version target";;
  minor)
    SEMVER=2; info "Minor version target";;
  *) info "Patch version target";;
esac

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

cd $FORKED_REPO/$TARGET || exit
update_master

for item in *; do
  if [ -d "$item" ]; then
    cd "$item" || exit
    if  grep -q 'containers@bitnami.com' 'Chart.yaml'; then
      CHART="$(basename "$(pwd)")"
      info "Bitnami chart found: ${CHART}"
      git checkout -b "${CHART}"
      info "-- Applying your changes..."
      . $CHANGES_SCRIPT
      info "-- Changes have been applied"
      CURRENT_VERSION="$(grep 'version:' 'Chart.yaml' | cut -d' ' -f2)"
      NEW_VERSION="$(increment_version "$CURRENT_VERSION" "$SEMVER")"
      info "-- Bumping version from ${CURRENT_VERSION} to ${NEW_VERSION}"
      sed -i -e "s/${CURRENT_VERSION}/${NEW_VERSION}/g" Chart.yaml
      git add . && git commit -m "[stable/${CHART}] $COMMIT_MESSAGE" -s && git push origin "${CHART}"
      git checkout master && git pull
    fi
    cd .. || exit
  fi
done
