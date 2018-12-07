# Upgrading from version 1.1.x and up.

## Secret creation

Specify which release we want to work with:

```
export RELEASE='peer1'
export NAMESPACE='default'
export POD_NAME=$(kubectl -n ${NAMESPACE} get pods -l "app=hlf-peer,release=${RELEASE}" -o jsonpath="{.items[0].metadata.name}")
```

### Cred secret

Get relevant credentials

```
export CA_USERNAME=$(kubectl -n ${NAMESPACE} get secret ${RELEASE}-hlf-peer -o jsonpath="{.data.CA_USERNAME}" | base64 --decode; echo)
export CA_PASSWORD=$(kubectl -n ${NAMESPACE} get secret ${RELEASE}-hlf-peer -o jsonpath="{.data.CA_PASSWORD}" | base64 --decode; echo)
 ```

Save credentials in secret

```
kubectl -n ${NAMESPACE} create secret generic hlf--${RELEASE}-cred --from-literal=CA_USERNAME=$CA_USERNAME --from-literal=CA_PASSWORD=$CA_PASSWORD
```

### Cert secret

Get content of certificate file and save it as a secret:

```
export CONTENT=$(kubectl -n ${NAMESPACE} exec ${POD_NAME} -- cat /var/hyperledger/msp/signcerts/cert.pem)
kubectl -n ${NAMESPACE} create secret generic hlf--${RELEASE}-idcert --from-literal=cert.pem=$CONTENT
```

### Key secret

Get content of key file and save it as a secret:

```
export CONTENT=$(kubectl -n ${NAMESPACE} exec ${POD_NAME} -- bash -c 'cat /var/hyperledger/msp/keystore/*_sk')
kubectl -n ${NAMESPACE} create secret generic hlf--${RELEASE}-idkey --from-literal=key.pem=$CONTENT
```

### CA cert secret

Get content of key file and save it as a secret:

```
export CONTENT=$(kubectl -n ${NAMESPACE} exec ${POD_NAME} -- bash -c 'cat /var/hyperledger/msp/cacerts/*.pem')
kubectl -n ${NAMESPACE} create secret generic hlf--${RELEASE}-cacert --from-literal=cacert.pem=$CONTENT
```

### Intermediate CA cert secret

Get content of key file and save it as a secret (if you have used an intermediate CA):

```
export CONTENT=$(kubectl -n ${NAMESPACE} exec ${POD_NAME} -- bash -c 'cat /var/hyperledger/msp/intermediatecerts/*.pem')
kubectl -n ${NAMESPACE} create secret generic hlf--${RELEASE}-intcacert --from-literal=intermediatecacert.pem=$CONTENT
```

## Move old MSP material out

We can move the crypto material we created earlier to another directory in our Persistent Volume, so we can rollback if needed.

```
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- mv /var/hyperledger/msp /var/hyperledger/msp_old
```

## Upgrade the chart

You will need to update the chart to the latest version by editing the relevant values files:

```
secrets:
  ord:
    cred: hlf--peer1-cred
    cert: hlf--peer1-idcert
    key: hlf--peer1-idkey
    caCert: hlf--peer1-cacert
    intCaCert: hlf--peer1-caintcert  # If applicable
```

And running:

```
helm upgrade ${RELEASE} ./hlf-peer
```
