#!/bin/sh

apk update
apk add curl

curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9
.10.2/dig.tgz|tar -xzv -C /usr/local/bin/

if [ `dig @127.0.0.1 -p 8600 consul.service.consul +short | wc -l` -ge "3" ]
then
    echo "OK. consul.service.consul returning at least 3 records."
else
    echo "ERROR. consul.service.consul returning less than 3 records."
    exit 1
fi
