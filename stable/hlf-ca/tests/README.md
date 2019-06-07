# Chart testing

> Eventually this will be replaced with an integration test, likely running with `pytest`

Commands should be run from the root folder of the repository.

## Root CA

### Pre-install

Due to presence of dependencies, please run inside the chart dir:

    helm dependency update

### Install

Install Root CA

    helm install ./hlf-ca -n rca --namespace test -f ./hlf-ca/tests/values/root.yaml

    export RCA_POD=$(kubectl get pods -n test -l "app=hlf-ca,release=rca" -o jsonpath="{.items[0].metadata.name}")

Check that server is running

    kubectl logs -n test $RCA_POD | grep "Listening on"

### Bootstrap ID

Check that we don't have a certificate for the bootstrap identity and create it.

    kubectl exec -n test $RCA_POD -- cat /var/hyperledger/fabric-ca/msp/signcerts/cert.pem

    kubectl exec -n test $RCA_POD -- bash -c 'fabric-ca-client enroll -d -u http://$CA_ADMIN:$CA_PASSWORD@$SERVICE_DNS:7054'

## Intermediate CA

### Install

    helm install ./hlf-ca -n ica --namespace test -f ./hlf-ca/tests/values/intermediate.yaml

    export ICA_POD=$(kubectl get pods -n test -l "app=hlf-ca,release=ica" -o jsonpath="{.items[0].metadata.name}")

Check the server is running

    kubectl logs -n test $ICA_POD | grep "Listening on"

### Bootstrap ID

Check that we don't have a certificate for the bootstrap identity and create it.

    kubectl exec -n test $ICA_POD -- cat /var/hyperledger/fabric-ca/msp/signcerts/cert.pem

    kubectl exec -n test $ICA_POD -- bash -c 'fabric-ca-client enroll -d -u http://$CA_ADMIN:$CA_PASSWORD@$SERVICE_DNS:7054'

### Register an enroll an identity

Check that an organisation does not exist

    kubectl exec -n test $ICA_POD -- fabric-ca-client identity list --id org-admin

Register Organisation Admin if the previous command did not work

    kubectl exec -n test $ICA_POD -- fabric-ca-client register --id.name org-admin --id.secret OrgAdm1nPW --id.attrs 'admin=true:ecert'

Enroll the Organisation Admin identity (typically we would use a more secure password than `OrgAdm1nPW`, etc.)

    kubectl exec -n test $ICA_POD -- bash -c 'fabric-ca-client enroll -u http://org-admin:OrgAdm1nPW@$SERVICE_DNS:7054 -M ./TestMSP'

Check that the new identity is present in the Intermediate CA

    kubectl exec -n test $ICA_POD -- fabric-ca-client identity list --id org-admin

### Cleanup

Delete charts we installed

    helm delete --purge ica rca

Currently, the Persistent Volume Claim for the PostgreSQL database does not get deleted automatically.

    kubectl -n test delete pvc data-rca-postgresql-0
