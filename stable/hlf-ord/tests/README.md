# Chart testing

> Eventually this will be replaced with an integration test, likely running with `pytest`

Commands should be run from the root folder of the repository.

## Orderer

### Set up cryptographic material

#### Orderer Org admin

    ORG_CERT=$(ls ./hlf-ord/tests/fixtures/crypto/admin/*.pem)

    kubectl create secret generic -n test hlf--ord-admincert --from-file=cert.pem=$ORG_CERT

    CA_CERT=$(ls ./hlf-ord/tests/fixtures/crypto/ca/*.pem)

    kubectl create secret generic -n test hlf--ord-cacert --from-file=cacert.pem=$CA_CERT

#### Orderer node

    NODE_CERT=$(ls ./hlf-ord/tests/fixtures/crypto/orderer/*.pem)

    kubectl create secret generic -n test hlf--ord0-idcert --from-file=cert.pem=$NODE_CERT

    NODE_KEY=$(ls ./hlf-ord/tests/fixtures/crypto/orderer/*_sk)

    kubectl create secret generic -n test hlf--ord0-idkey --from-file=key.pem=$NODE_KEY

#### Genesis block

    kubectl create secret generic -n test hlf--genesis --from-file=./hlf-ord/tests/fixtures/crypto/genesis.block

### Install

Install helm chart of orderer.

    helm install ./hlf-ord -n ord0 --namespace test -f ./hlf-ord/tests/values/orderer.yaml

    export ORD_POD=$(kubectl get pods --namespace test -l "app=hlf-ord,release=ord0" -o jsonpath="{.items[0].metadata.name}")

Check that server is running

    kubectl logs -n test $ORD_POD | grep 'completeInitialization'

### Cleanup

Delete charts we installed

    helm delete --purge ord0

Delete the secrets we created

    kubectl -n test delete secret hlf--ord-admincert hlf--ord-cacert hlf--ord0-idcert hlf--ord0-idkey hlf--genesis
