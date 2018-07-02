FROM golang:1.6
MAINTAINER Chris Dornsife <chris@applariat.com>

# Build container to have a consistent go build environment

COPY . /go/src/rethinkdb-probe
WORKDIR /go/src/rethinkdb-probe

RUN go get ./... \
    && CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-w -s' -o /target/rethinkdb-probe .
