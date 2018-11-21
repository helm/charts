# Chart testing

> Eventually this will be replaced with an integration test, likely running with `pytest`

Commands should be run from the root folder of the repository.

## Orderer

### Set up cryptographic material

#### Orderer Org admin

    ORG_CERT=$(ls ./EXTRA/crypto-config/ordererOrganizations/test.svc.cluster.local/users/Admin@test.svc.cluster.local/msp/admincerts/*.pem)

    kubectl create secret generic -n test hlf--ord-admincert --from-file=cert.pem=$ORG_CERT

    CA_CERT=$(ls ./EXTRA/crypto-config/ordererOrganizations/test.svc.cluster.local/users/Admin@test.svc.cluster.local/msp/cacerts/*.pem)

    kubectl create secret generic -n test hlf--ord-cacert --from-file=cacert.pem=$CA_CERT

#### Orderer node

    NODE_CERT=$(ls ./EXTRA/crypto-config/ordererOrganizations/test.svc.cluster.local/orderers/ord0-hlf-ord.test.svc.cluster.local/msp/signcerts/*.pem)

    kubectl create secret generic -n test hlf--ord0-idcert --from-file=cert.pem=$NODE_CERT

    NODE_KEY=$(ls ./EXTRA/crypto-config/ordererOrganizations/test.svc.cluster.local/orderers/ord0-hlf-ord.test.svc.cluster.local/msp/keystore/*_sk)

    kubectl create secret generic -n test hlf--ord0-idkey --from-file=key.pem=$NODE_KEY

#### Genesis block

    kubectl create secret generic -n test hlf--genesis --from-file=./EXTRA/genesis.block

### Install

Install helm chart of orderer.

    helm install ./hlf-ord -n ord0 --namespace test -f ./hlf-ord/tests/values/orderer.yaml

    export ORD_POD=$(kubectl get pods --namespace test -l "app=hlf-ord,release=ord0" -o jsonpath="{.items[0].metadata.name}")

Check that server is running

    kubectl logs -n test $ORD_POD | grep 'completeInitialization'

### Cleanup

Delete charts we installed

    helm delete --purge ord0
