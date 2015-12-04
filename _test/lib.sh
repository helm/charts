function move-files {
  helm doctor # need proper ~/.helm directory structure and config.yml

  log-info "Staging chart directory"
  rsync -av . ${HOME}/.helm/cache/charts/
}

function install-helm {
  # Uses HELM_ARTIFACT_REPO to determine which repository to grab helm from

  log-lifecycle "Installing helm into $(pwd)/.bin"

  mkdir -p .bin
  (
    cd .bin
    curl -s https://get.helm.sh | bash
  )
  export PATH="$(pwd)/.bin:${PATH}"

  move-files
}

function get-changed-charts {
  git diff --name-only HEAD origin/HEAD -- charts \
    | cut -d/ -f 1-2 \
    | sort \
    | uniq
}

function ensure-dirs-exist {
  local dirs="${@}"
  local pruned

  # ensure directories exist and just output directory name
  for dir in ${dirs}; do
    if [ -d ${dir} ]; then
      pruned+="$(basename "${dir}")\n"
    fi
  done

  echo -e "${pruned}"
}

function generate-test-plan {
  ensure-dirs-exist "$(get-changed-charts)"
}

function get-all-charts {
  local chartlist="$(find . -name Chart.yaml)"
  local cleanedlist

  local chart
  for chart in ${chartlist}; do
    cleanedlist+="$(basename $(dirname ${chart})) "
  done

  echo "${cleanedlist}"
}

function helm-test {
  log-warn "Start: ${1}"
  .bin/helm fetch "${1}"
  .bin/helm install "${1}"
  healthcheck "${1}"
  .bin/helm uninstall -y "${1}"
  log-warn "Done: ${1}"
}

function run-test-plan {
  local test_plan

  if is-pull-request; then
    test_plan="$(generate-test-plan)"
  else
    if [ -z "${TEST_CHARTS}" ]; then
      test_plan="$(get-all-charts)"
    else
      test_plan="${TEST_CHARTS}"
    fi
  fi

  log-lifecycle "Running test plan"
  log-info "Charts to be tested:"
  echo "${test_plan}"

  local plan
  for plan in ${test_plan}; do
    helm-test ${plan}
  done
}

function is-pull-request {
  if [ ! -z ${TRAVIS} ] && \
     [ ${TRAVIS_PULL_REQUEST} != false ]; then
    log-warn "This is a pull request."
    return 0
  else
    return 1
  fi
}

function is-pod-running {
  local name="${1}"

  if kubectl get pods "${name}" &> /dev/null; then
    log-info "Looking for pod named ${name}"
    local jq_name_query=".status.phase"
    kubectl get pods ${name} -o json | jq -r "${jq_name_query}" | grep -q "Running" && return 0
  fi

  log-info "Looking for label: app=${name}"
  local jq_app_label_query=".items[] | select(.metadata.labels.app == \"${name}\") | .status.phase"
  kubectl get pods -o json | jq -r "${jq_app_label_query}" | grep -q "Running" && return 0

  log-info "Looking for label: provider=${name}"
  local jq_provider_label_query=".items[] | select(.metadata.labels.provider == \"${name}\") | .status.phase"
  kubectl get pods -o json | jq -r "${jq_provider_label_query}" | grep -q "Running" && return 0

  log-info "Looking for label: name=${name}"
  local jq_provider_label_query=".items[] | select(.metadata.labels.name == \"${name}\") | .status.phase"
  kubectl get pods -o json | jq -r "${jq_provider_label_query}" | grep -q "Running" && return 0
}

function healthcheck {
  WAIT_TIME=1
  log-lifecycle "Checking: ${1}"
  until is-pod-running "${1}"; do
    sleep 1
     (( WAIT_TIME += 1 ))
     if [ ${WAIT_TIME} -gt ${HEALTHCHECK_TIMEOUT_SEC} ]; then
      return 1
    fi
  done
  log-lifecycle "Checked!: ${1}"
}

function log-lifecycle {
  echo "${bldblu}==> ${@}...${txtrst}"
}

function log-info {
  echo "${wht}--> ${@}${txtrst}"
}

function log-warn {
  echo "${bldred}--> ${@}${txtrst}"
}
