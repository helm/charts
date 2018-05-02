The steps to utilize the chart with a service (predominantly a CI/CD service) deploying the blockchain network to the Kubernetes cluster and then deploying smart contracts and configuring the accounts on the blockchain, the following sequence can be utilized.

## Prerequisites

The easiest way to interact with `burrow` is via the [monax](https://github.com/monax/monax) toolkit. This command line application is built to provide a seamless toolkit for developers seeking to provision and operate burrow networks. The below deployment sequence relies upon a developer having that toolkit installed on their local machine. This sequence also requires the very fine [jq](https://stedolan.github.io/jq/) binary to be installed.

Monax offers a [docker image](https://quay.io/repository/monax/monax?tag=latest&tab=tags) that includes various tools necessary for deploying blockchains and contracts to Kubernetes clusters via a CI/CD system. If your CI/CD system offers an ability to utilize a custom docker image as the base of the CI/CD sequence then the easiest way to utilize this chart is to use the image: `quay.io/monax/monax-$VERSION-platform_deployer`. That image includes both the monax binary and the jq binary which will be used below.

Obviously the container performing the CI/CD sequence will need to be able to connect with tiller within the cluster you are seeking to deploy to with the proper credentials.

## Deployment Script

The following is an example `.gitlab-ci.yml` that can be used, obviously if you use a different CI/CD system you will need to adjust the fields accordingly to fit your system. However, the yaml below should be approachable for most operators.

```yaml
image: quay.io/monax/monax:0.18.0-platform_deployer

stages:
  - test
  - deploy

before_script:
  - monax init --yes --pull-images=false

variables:
  DOCKER_DRIVER: overlay2
  MONAX_PULL_APPROVE: "true"

test:
  stage: test
  script:
    - true

deploy:
  stage: deploy
  only:
    - master@YOUR_REPO
  environment:
    name: production
    url: https://YOUR_URL
  variables:
    CHAIN_SOURCE_DIRECTORY: "deploy/chain"
    CHAIN_DEPLOY_NAME: "YOUR_NAME"
    CHAIN_ID: "YOUR_ID"
    CHAIN_NODES: 7
    KUBERNETES_NAMESPACE: "YOUR_NAMESPACE"
    ORGANIZATION_NAME: "YOUR_ORG"
  script:
    - deploy/deploy
  after_script:
    - rm -rf $HOME/.monax/keys; true
  retry: 1
```

The following is a sample deploy/deploy script that could be used.

```bash
#!/usr/bin/env bash
start=`pwd`
export MONAX_PULL_APPROVE="true"

main() {
  make_chain
  deploy_chain
  exit 0
}

make_chain() {
  monax chains make $CHAIN_ID \
    --account-types=Full:0,Validator:$CHAIN_NODES 2>/dev/null
  mv ~/.monax/chains/$CHAIN_ID/* $CHAIN_SOURCE_DIRECTORY/.
  rm -rf ~/.monax/chains/$CHAIN_ID
  cat $CHAIN_SOURCE_DIRECTORY/accounts.csv.default >> $CHAIN_SOURCE_DIRECTORY/accounts.csv
  GENESIS_FILE=$(monax chains make $CHAIN_ID \
    --known \
    --accounts $CHAIN_SOURCE_DIRECTORY/accounts.csv \
    --validators $CHAIN_SOURCE_DIRECTORY/validators.csv \
    | jq -rc '@base64')
  keysFilesPrefix="keysFiles."
  KEYS_FILES=""
  for d in $CHAIN_SOURCE_DIRECTORY/*validator*/; do
    key=key-$(basename $d | cut -d "_" -f 3)
    val=$(cat $d/priv_validator.json | jq -rc '@base64')
    KEYS_FILES+=$keysFilesPrefix$key=$val,
  done
  rm -rf $CHAIN_SOURCE_DIRECTORY/*validator*/ && unset keysFilesPrefix
}

deploy_chain() {
  set +e
  helm delete --purge $CHAIN_DEPLOY_NAME
  set -e
  helm install \
    --name $CHAIN_DEPLOY_NAME \
    --values $CHAIN_SOURCE_DIRECTORY/values.yaml \
    --namespace $KUBERNETES_NAMESPACE \
    --set chain.name=$CHAIN_ID \
    --set chain.id=$CHAIN_ID \
    --set chain.numberOfNodes=$CHAIN_NODES \
    --set nameOverride=$CHAIN_ID \
    --set organization=$ORGANIZATION_NAME \
    --set genesisFile=$GENESIS_FILE \
    --set $KEYS_FILES \
    incubator/burrow
  unset $KEYS_FILES
}

set -e
main $@
```

A few notes about the above script.

* `CHAIN_SOURCE_DIR`: It is likely convenient when running this chart via CI/CD system to establish within the application's repository a place where default files such as a configured values.yaml and also a csv with accounts can be kept. The above script utilizes such a directory.
* `values.yaml`: The above script utilizes a relatively fixed values.yaml that is kept within the application repository. This is used to configure variables that move infrequently such as the `image.tag` or ingress|persistence which is utilized by the cluster.
* `accounts.csv.default`: The chain that is made uses dynamic validator keys and combines those with fixed keys that are used by the application developers. These keys have been collected during the development process and a .csv was built in the form that is outputted by `monax chains make`. This enables a combination of the accounts with a simple `cat ... >> ...` call as demonstrated in the script.
