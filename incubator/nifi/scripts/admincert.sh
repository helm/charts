#!/bin/bash

set -u

CURRENT_DIR="$(cd `dirname $0` && pwd)"

source $CURRENT_DIR/functions.sh

argcheck $@

CERT_DIR=$CURRENT_DIR/tmp/cert
mkdir -p $CERT_DIR

kubectl_download_secret "${RELEASE_NAME}-apache-nifi-ca-cert-admin" keystore.pkcs12 $CERT_DIR/keystore.pkcs12
kubectl_download_secret "${RELEASE_NAME}-apache-nifi-ca-cert-admin" config.json $CERT_DIR/config.json
kubectl_download_secret "${RELEASE_NAME}-apache-nifi-ca-cert-admin" nifi-cert.pem $CERT_DIR/nifi-cert.pem

NIFI_URL=${NIFI_URL:-}

if [[ -z $NIFI_URL ]]; then
  CURRENT_CONTEXT=$(kubectl config current-context)
  if [[ -n $PROXY_HOST ]]; then
    NIFI_URL=https://$PROXY_HOST
  else
    echo "Unknown context, unable to determine loadbalancer service"
    exit 1
  fi
fi
echo "Checking certificate"

export PASS=$(jq -r .keyStorePassword "$CERT_DIR/config.json" | tee "$CERT_DIR/keystore.pass")

openssl pkcs12 -in "$CERT_DIR/keystore.pkcs12" -out "$CERT_DIR/key.pem" -nocerts -nodes -password "env:PASS"
openssl pkcs12 -in "$CERT_DIR/keystore.pkcs12" -out "$CERT_DIR/crt.pem" -clcerts -nokeys -password "env:PASS"

curl -kv "$NIFI_URL" --connect-timeout 1 --max-time 3 --cert $CURRENT_DIR/tmp/cert/crt.pem --cert-type PEM --key $CURRENT_DIR/tmp/cert/key.pem --key-type PEM 1>"$CERT_DIR/curl.log" 2>&1

CURL_ERROR=$?
if [[ $CURL_ERROR -gt 0 ]]; then
  echo "Certificate check was unsuccessful, see: $CERT_DIR/curl.log"
  exit $CURL_ERROR
else
  echo "Certificate check succeeded!"
  cat <<EOF

UI:
  ${NIFI_URL}/nifi
Certificate:
  # open and add this to the System keychain and configure application access for the key
  $CERT_DIR/keystore.pkcs12
Password:
  $CERT_DIR/keystore.pass

Alternatively add cert and key to the keychain from the command line:
  sudo security import $CERT_DIR/crt.pem -k /Library/Keychains/System.keychain -A
  sudo security import $CERT_DIR/key.pem -k /Library/Keychains/System.keychain -A
  sudo security add-trusted-cert -d -k /Library/Keychains/System.keychain $CERT_DIR/nifi-cert.pem
EOF
fi
