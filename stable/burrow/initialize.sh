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
export CHAIN_NAME=${CHAIN_NAME:-"my-release-burrow"}
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

function finish {
  rm $keysTemplate
  rm $valsTemplate
  rm $genSpec
  rm $genesis
  rm -r $keys
}
trap finish EXIT

setup="setup.yaml"
values="addresses.yaml"

cat >$keysTemplate <<EOF
{{- range \$index, \$val := .Validators -}}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $.ChainName }}-keys-{{ printf "%03d" \$index }}
data:
{{- \$keys := $.Keys -}}

{{- if index \$keys $val.Address }}
  {{ \$val.Address }}.json: {{ base64 (index \$keys \$val.Address).KeyJSON }}
{{- end -}}

{{- if index \$keys $val.NodeAddress }}
  node_key.json: {{ base64 (index \$keys \$val.NodeAddress).KeyJSON }}
{{- end }}

---
{{ end -}}
EOF

cat >$valsTemplate <<EOF
validators:
  {{- range .Validators }}
  - name: {{ .Name }}
    address: {{ .Address -}}
    {{ if .NodeAddress }}
    nodeAddress: {{ .NodeAddress }}
    {{- end -}}
  {{- end }}
EOF

echo "Building the genesis spec with burrow ($(burrow --version))."
burrow spec \
  --toml \
  --validator-accounts=$CHAIN_NODES \
  $CHAIN_SPEC_FILES > $genSpec

echo "Creating keys and necessary deploy files..."
burrow configure \
  --chain-name=$CHAIN_NAME \
  --keys-dir=$keys \
  --genesis-spec=$genSpec \
  --config-template-in=$keysTemplate \
  --config-out=$CHAIN_OUTPUT_DIRECTORY/$setup \
  --config-template-in=$valsTemplate \
  --config-out=$CHAIN_OUTPUT_DIRECTORY/$values \
  --separate-genesis-doc=$genesis >/dev/null

echo "Saved keys and genesis as $CHAIN_OUTPUT_DIRECTORY/$setup"
echo "Saved example 'values.yaml' as $CHAIN_OUTPUT_DIRECTORY/$values"

cat >>$CHAIN_OUTPUT_DIRECTORY/$setup <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CHAIN_NAME-genesis
data:
  genesis.json: |
    `cat $genesis | jq -rc .`
EOF

echo -e "Done\n"
