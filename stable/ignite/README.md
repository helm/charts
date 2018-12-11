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
    --set persistence.persistenceVolume.size=100Gi \
    --set persistence.walVolume.size=8Gi \
    stable/ignite
```

To configure persistence for other volume plugins you should edit
`persistence.persistenceVolume.provisioner` and `persistence.persistenceVolume.provisioner_parameters` variables.
(and the same variables for `persistence.walVolume` section). The chart creates 2 StorageClass resources, you can read about it's configurartion [here](https://kubernetes.io/docs/concepts/storage/storage-classes/).
