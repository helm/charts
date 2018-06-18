FROM golang:alpine

RUN apk update && apk --no-cache add --virtual .build-dep git make gcc \
    && go get github.com/percona/mongodb_exporter \
    && cd $GOPATH/src/github.com/percona/mongodb_exporter \
    && make build \
    && mv mongodb_exporter /bin \
    && rm -rf $GOPATH/src/* \
    && apk del .build-dep --purge

EXPOSE 9216

CMD  [ "/bin/mongodb_exporter" ]
