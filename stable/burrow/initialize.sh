#!/usr/bin/env bash

# Preflight checks
if [[ "$(which mktemp)" == "" ]]
then
  echo "Please install mktemp and then rerun me. Exiting."
  exit 1
fi
if [[ "$(which burrow)" == "" ]]
then
  echo "Please install Hyperledger Burrow and then rerun me. Exiting."
  exit 1
fi

export CHAIN_NODES=${CHAIN_NODES:-4}
export CHAIN_NAME=${CHAIN_NAME:-"my-release"}
if [ -z $CHAIN_OUTPUT_DIRECTORY ]; then
  export CHAIN_OUTPUT_DIRECTORY=`pwd`
fi

set -e

title="Initializing $((CHAIN_NODES)) Validator Nodes"
echo -e "\n${title}\n${title//?/-}\n"

echo "Writing kubernetes template files for validators secrets, and configmaps."
keysTemplate=$(mktemp)
valsTemplate=$(mktemp)
genSpec=$(mktemp)
genesis=$(mktemp)
keys=$(mktemp -d)


cat >$keysTemplate <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: << .Config.ChainName >>-keys
data:
  <<- \$keys:=.Keys ->>
  <<- range .Keys ->>
    <<- if index \$keys .Address >>
    << .Address >>.json: << base64 (index \$keys .Address).KeyJSON >>
    <<- end ->>
  <<- end ->>
  <<- range .Validators ->>
    <<- if index \$keys .NodeAddress >>
    nodekey-<< .Name >>: << base64 (index \$keys .NodeAddress).KeyJSON >>
    <<- end ->>
  <<- end ->>
EOF

cat >$valsTemplate <<EOF
chain:
  nodes: $CHAIN_NODES

validatorAddresses:
  <<- range .Config.Validators >>
  << .Name >>:
    Address: << .Address ->>
    <<if .NodeAddress >>
    NodeAddress: << .NodeAddress >>
    <<- end ->>
  <<- end >>
EOF

echo "Building the genesis spec with burrow ($(burrow --version))."
burrow spec \
  --toml \
  --validator-accounts=$CHAIN_NODES \
  $CHAIN_SPEC_FILES > $genSpec

echo "Creating keys and necessary deploy files..."
burrow configure \
  --generate-node-keys \
  --chain-name=$CHAIN_NAME \
  --keysdir=$keys \
  --genesis-spec=$genSpec \
  --config-template-in=$keysTemplate \
  --config-out=$CHAIN_OUTPUT_DIRECTORY/chain-info.yaml \
  --config-template-in=$valsTemplate \
  --config-out=$CHAIN_OUTPUT_DIRECTORY/initialize.yaml \
  --separate-genesis-doc=$genesis >/dev/null

echo "Saved Kubernetes specification as $CHAIN_OUTPUT_DIRECTORY/chain-info.yaml"
echo "Saved example 'values.yaml' as $CHAIN_OUTPUT_DIRECTORY/initialize.yaml"

cat >>$CHAIN_OUTPUT_DIRECTORY/chain-info.yaml <<EOF

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CHAIN_NAME-genesis
data:
  genesis.json: |
    `cat $genesis | jq -rc .`
EOF

echo "Garbage collecting..."
rm $keysTemplate
rm $valsTemplate
rm $genSpec
rm $genesis
rm -r $keys

echo -e "Done\n"
