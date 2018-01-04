# Metabase

[Metabase](http://metabase.com) is the easy, open source way for everyone in your company to ask questions and learn from data.

## TL;DR;

```bash
$ helm install stable/metabase
```

## Introduction

This chart bootstraps a [Metabase](https://github.com/metabase/metabase) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/metabase
```

The command deploys Metabase on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Metabase chart and their default values.

| Parameter              | Description                                                | Default           |
|------------------------|------------------------------------------------------------|-------------------|
| replicaCount           | desired number of controller pods                          | 1                 |
| image.repository       | controller container image repository                      | metabase/metabase |
| image.tag              | controller container image tag                             | v0.26.2           |
| image.pullPolicy       | controller container image pull policy                     | IfNotPresent      |
| listen.host            | Listening on a specific network host                       | 0.0.0.0           |
| listen.port            | Listening on a specific network port                       | 3000              |
| ssl.enabled            | Enable SSL to run over HTTPS                               | false             |
| ssl.port               | SSL port                                                   | null              |
| ssl.keyStore           | The key store in JKS format                                | null              |
| ssl.keyStorePassword   | The password for key Store                                 | null              |
| database.type          | Backend database type                                      | h2                |
| database.encryptionKey | Secret key for encrypt sensitive information into database | null              |
| database.host          | Database host                                              | null              |
| database.port          | Database port                                              | null              |
| database.dbname        | Database name                                              | null              |
| database.username      | Database username                                          | null              |
| database.password      | Database password                                          | null              |
| password.complexity    | Complexity requirement for Metabase account's password     | normal            |
| password.length        | Minimum length required for Metabase account's password    | 6                 |
| timeZone               | Service time zone                                          | UTC               |
| emojiLogging           | Get a funny emoji in service log                           | true              |
| javaToolOptions        | JVM options                                                | null              |
| pluginsDirectory       | A directory with Metabase plugins                          | null              |
| service.type           | ClusterIP, NodePort, or LoadBalancer                       | ClusterIP         |
| service.externalPort   | Service external port                                      | 80                |
| service.internalPort   | Service internal port, should be the same as `listen.port` | 3000              |
| ingress.enabled        | Enable ingress controller resource                         | false             |
| ingress.hosts          | Ingress resource hostnames                                 | null              |
| ingress.annotations    | Ingress annotations configuration                          | null              |
| ingress.tls            | Ingress TLS configuration                                  | null              |
| resources              | Server resource requests and limits                        | {}                |

The above parameters map to the env variables defined in [metabase](http://github.com/metabase/metabase). For more information please refer to the [metabase documentations](http://www.metabase.com/docs/v0.24.2/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set timeZone=US/Pacific,password.complexity=strong,password.length=10 \
    stable/metabase
```

The above command sets the time zone to `US/Pacific`, `strong` user password complexity and minimum length at `10`

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/metabase
```

> **Tip**: You can use the default [values.yaml](values.yaml)
