#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
if [[ "$PWD" == "$DIR" ]]; then
  echo "This script should not be run from scripts. It should be run in the base of the mtls chart"
  exit 1
fi
mkdir -p output/ca/certs output/ca/crl output/ca/newcerts output/ca/private
chmod 700 output/ca/private
touch output/ca/index.txt
echo 1000 > output/ca/serial
cp $DIR/openssl.cnf output/ca/
sed -i "s|^dir = /root/ca|dir ="$PWD"/output/ca|g" output/ca/openssl.cnf
