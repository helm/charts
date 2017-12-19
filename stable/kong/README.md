## Kong

[Kong](https://getkong.org/) is an open-source API Gateway and Microservices
Management Layer, delivering high performance and reliability.

## TL;DR;

```bash
$ helm install stable/kong
```

## Introduction

This chart bootstraps all the components needed to run Kong on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
  if persistence is needed

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/kong
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

### General Configuration Parameters

The following tables lists the configurable parameters of the Kong chart
and their default values.

| Parameter                         | Description                                                            | Default               |
| ------------------------------    | --------------------------------------------------------------------   | -------------------   |
| image.repo                        | Kong image                                                             | `kong`                |
| image.tag                         | Kong image version                                                     | `latest`              |
| image.pullPolicy                  | Image pull policy                                                      | `IfNotPresent`        |
| replicaCount                      | Kong instance count                                                    | `1`                   |
| admin.servicePort                 | TCP port on which the Kong admin service is exposed                    | `8001`                |
| admin.serviceSSLPort              | Secure TCP port on which the Kong admin service is exposed             | `8444`                |
| admin.containerPort               | TCP port on which Kong app listens for admin traffic                   | `8001`                |
| admin.containerSSLPort            | Secure TCP port on which Kong app listens for admin traffic            | `8444`                |
| admin.type                        | k8s service type, Options: NodePort, ClusterIP, LoadBalancer                       | `NodePort`            |
| admin.loadBalancerIP              | Will reuse an existing ingress static IP for the admin service         | `null`                |
| admin.useTLS                      | Secure admin traffic                                                   | `true`                |
| proxy.servicePort                 | TCP port on which the Kong proxy service is exposed                    | `8000`                |
| proxy.serviceSSLPort              | Secure TCP port on which the Kong Proxy Service is exposed             | `8443`                |
| proxy.containerPort               | TCP port on which the Kong app listens for Proxy traffic               | `8000`                |
| proxy.containerSSLPort            | Secure TCP port on which the Kong app listens for Proxy traffic        | `8443`                |
| proxy.type                        | k8s service type. Options: NodePort, ClusterIP, LoadBalancer            | `NodePort`            |
| proxy.loadBalancerIP              | Will reuse an existing ingress static IP for the admin service         | `null`                |
| proxy.useTLS                      | Secure Proxy traffic                                                   | `true`                |
| customConfig                      | Additional [Kong configurations](https://getkong.org/docs/latest/configuration/)               |
| runMigrations                     | Run Kong migrations job                                                | `true`                |
| readinessProbe                    | Kong readiness probe                                                   |                       |
| livenessProbe                     | Kong liveness probe                                                    |                       |
| affinity                          | Node/pod affinities                                                    |                       |
| nodeSelector                      | Node labels for pod assignment                                         | `{}`                  |
| podAnnotations                    | Annotations to add to each pod                                         | `{}`                  |
| resources                         | Pod resource requests & limits                                         | `{}`                  |
| tolerations                       | List of node taints to tolerate                                        | `[]`                  |

### Database-specific parameters

Kong has a choice of either Postgres or Cassandra as a backend datatstore.
This chart allows you to choose either of them with the `kong.database.type`
parameter.  Postgres is chosen by default.

Additionally, this chart allows you to use your own database or spin up a new
instance by using the `postgres.enabled` or `cassandra.enabled` parameters.
Enabling both will create both databases in your cluster, but only one
will be used by Kong based on the `database.type` parameter.
Postgres is enabled by default.

| Parameter                         | Description                                                            | Default               |
| ------------------------------    | --------------------------------------------------------------------   | -------------------   |
| cassandra.enabled                 | Spin up a new cassandra cluster for Kong                               | `false`               |
| postgres.enabled                  | Spin up a new postgres instance for Kong                               | `true `               |
| database.type                     | Choose either `postgres` or `cassandra`                                | `postgres`               |
| database.postgres.username        | Postgres username                                                      | `kong`                |
| database.postgres.database        | Postgres database name                                                 | `kong`                |
| database.postgres.password        | Postgres database password                                             | `kong`                |
| database.postgres.host            | Postgres database host (required if you are using your own database)   | ``                    |
| database.postgres.port            | Postgres database port                                                 | `5432`                |
| database.cassandra.contactPoints  | Cassandra contact points (required if you are using your own database) | ``                    |
| database.cassandra.port           | Cassandra query port                                                   | `9042`                |
| database.cassandra.keyspace       | Cassandra keyspace                                                     | `kong`                |
| database.cassandra.replication    | Replication factor for the Kong keyspace                               | `2`                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kong --name my-release \
  --set=image.tag=0.11.2,database.type=caasandra,cassandra.enabled=true
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kong --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
