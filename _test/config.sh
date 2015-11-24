export TEST_ROOT_DIR="$(cd "$(dirname $(dirname $0))"; pwd)"
export HELM_ARTIFACT_REPO="${HELM_ARTIFACT_REPO:-helm-ci}"
CLUSTER_NAME="${CLUSTER_NAME:-helm-test-travis}"
GOOGLE_SDK_DIR="${HOME}/google-cloud-sdk"
export HELM_BIN="${TEST_ROOT_DIR}/helm.bin"
export TEST_DIR="${TEST_ROOT_DIR}/_test"
export SECRETS_DIR="${TEST_DIR}/secrets"
SKIP_DESTROY=${SKIP_DESTROY:-false}

export HEALTHCHECK_TIMEOUT_SEC=120

GCLOUD_CREDENTIALS_FILE="${GCLOUD_CREDENTIALS_FILE:-"${SECRETS_DIR}/gcloud-credentials.json"}"

GCLOUD_PROJECT_ID="${GCLOUD_PROJECT_ID:-${CLUSTER_NAME}}"
K8S_ZONE="${K8S_ZONE:-us-central1-b}"
K8S_CLUSTER_NAME="${K8S_CLUSTER_NAME:-${GCLOUD_PROJECT_ID}-$(openssl rand -hex 2)}"



# Text color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset

pass="${bldblu}-->${txtrst}"
warn="${bldred}-->${txtrst}"
ques="${bldblu}???${txtrst}"
