# Chart testing

> Eventually this will be replaced with an integration test, likely running with `pytest`

Commands should be run from the root folder of the repository.

## Peer

### Set up cryptographic material

#### Peer Org admin

    ORG_CERT=$(ls ./hlf-peer/tests/fixtures/crypto/admin/*.pem)

    kubectl create secret generic -n test hlf--peer-admincert --from-file=cert.pem=$ORG_CERT

    ORG_KEY=$(ls ./hlf-peer/tests/fixtures/crypto/admin/*_sk)

    kubectl create secret generic -n test hlf--peer-adminkey --from-file=key.pem=$ORG_KEY

    CA_CERT=$(ls ./hlf-peer/tests/fixtures/crypto/ca/*.pem)

    kubectl create secret generic -n test hlf--peer-cacert --from-file=cacert.pem=$CA_CERT

#### Peer node

    NODE_CERT=$(ls ./hlf-peer/tests/fixtures/crypto/peer/*.pem)

    kubectl create secret generic -n test hlf--peer0-idcert --from-file=cert.pem=$NODE_CERT

    NODE_KEY=$(ls ./hlf-peer/tests/fixtures/crypto/peer/*_sk)

    kubectl create secret generic -n test hlf--peer0-idkey --from-file=key.pem=$NODE_KEY

#### Genesis block

    kubectl create secret generic -n test hlf--channel --from-file=./hlf-peer/tests/fixtures/crypto/mychannel.tx

### Install

Install helm chart of peer.

    helm install ./hlf-peer -n peer0 --namespace test -f ./hlf-peer/tests/values/peer.yaml

    export PEER_POD=$(kubectl get pods --namespace test -l "app=hlf-peer,release=peer0" -o jsonpath="{.items[0].metadata.name}")

Check that server is running

    kubectl logs -n test $PEER_POD | grep 'Starting peer'

### Cleanup

Delete charts we installed

    helm delete --purge peer0

Delete the secrets we created

    kubectl -n test delete secret hlf--peer-admincert hlf--peer-adminkey hlf--peer-cacert hlf--peer0-idcert hlf--peer0-idkey hlf--channel
