# apache-ignite

This is a helm chart for [Apache Ignite](https://ignite.apache.org/)

Apache Ignite is an open-source distributed database, caching and processing
platform designed to store and compute on large volumes of data across a
cluster of nodes.

## Install

```console
$ helm install --name my-release stable/ignite
```

## Configuring persistence

Data persistence and WAL persistence can be enabled by specifying appropriate
variables. Please note that default persistence configuration is for AWS EBS.

```console
helm install --name my-release \
    --set persistence.enabled=true \
    --set persistence.size=100Gi \
    --set wal_persistence.enabled=true \
    --set wal_persistence.size=8Gi \
    stable/ignite
```

To configure persistence for other volume plugins you should edit
`persistence.provisioner` and `persistence.provisioner_parameters` variables.
(and the same variables for `wal_persistence` section).
