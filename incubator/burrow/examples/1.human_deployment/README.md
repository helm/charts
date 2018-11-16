The steps to utilize the chart with a human deploying the blockchain network to the Kubernetes cluster and then deploying smart contracts and configuring the accounts on the blockchain, the following sequence can be utilized.

## Prerequisites

The easiest way to interact with `burrow` is via the [monax](https://github.com/monax/monax) toolkit. This command line application is built to provide a seamless toolkit for developers seeking to provision and operate burrow networks. The below deployment sequence relies upon a developer having that toolkit installed on their local machine.

This sequence also requires the very fine [jq](https://stedolan.github.io/jq/) binary to be installed.

## Deployment Sequence

The following is an example deployment sequence.

```bash
CHAIN_NODES=4
CHAIN_ID=myTestChain
monax chains make $CHAIN_ID \
  --account-types=Root:1,Validator:$CHAIN_NODES

genesisFile=$(cat \
  $HOME/.monax/chains/$CHAIN_ID/$(echo $CHAIN_ID \
  | tr '[:upper:]' '[:lower:]')_root_000/genesis.json \
  | jq -rc '@base64')

keysFilesPrefix="keysFiles."
keysFiles=""
for d in $HOME/.monax/chains/$CHAIN_ID/*validator*/; do
  key=key-$(basename $d | cut -d "_" -f 3)
  val=$(cat $d/priv_validator.json | jq -rc '@base64')
  keysFiles+=$keysFilesPrefix$key=$val,
done

helm install \
  --set chain.name=$CHAIN_ID \
  --set chain.id=$CHAIN_ID \
  --set chain.numberOfNodes=$CHAIN_NODES \
  --set genesisFile=$genesisFile \
  --set $keysFiles \
  incubator/burrow

unset $keysFiles
```
