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

- Kubernetes 1.8+ with Beta APIs enabled.
- PV provisioner support in the underlying infrastructure if persistence
  is needed for Kong datastore.

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

The following table lists the configurable parameters of the Kong chart
and their default values.

| Parameter                         | Description                                                            | Default               |
| ------------------------------    | --------------------------------------------------------------------   | -------------------   |
| image.repository                  | Kong image                                                             | `kong`                |
| image.tag                         | Kong image version                                                     | `0.14.1`              |
| image.pullPolicy                  | Image pull policy                                                      | `IfNotPresent`        |
| replicaCount                      | Kong instance count                                                    | `1`                   |
| admin.useTLS                      | Secure Admin traffic                                                   | `true`                |
| admin.servicePort                 | TCP port on which the Kong admin service is exposed                    | `8444`                |
| admin.containerPort               | TCP port on which Kong app listens for admin traffic                   | `8444`                |
| admin.nodePort                    | Node port when service type is `NodePort`                              |                       |
| admin.type                        | k8s service type, Options: NodePort, ClusterIP, LoadBalancer           | `NodePort`            |
| admin.loadBalancerIP              | Will reuse an existing ingress static IP for the admin service         | `null`                |
| admin.ingress.enabled             | Enable ingress resource creation (works with proxy.type=ClusterIP)     | `false`               |
| admin.ingress.tls                 | Name of secret resource, containing TLS secret                         |                       |
| admin.ingress.hosts               | List of ingress hosts.                                                 | `[]`                  |
| admin.ingress.path                | Ingress path.                                                          | `/`                   |
| admin.ingress.annotations         | Ingress annotations. See documentation for your ingress controller for details | `{}`          |
| proxy.useTLS                      | Secure Proxy traffic                                                   | `true`                |
| proxy.servicePort                 | TCP port on which the Kong Proxy Service is exposed                    | `8443`                |
| proxy.containerPort               | TCP port on which the Kong app listens for Proxy traffic               | `8443`                |
| proxy.nodePort                    | Node port when service type is `NodePort`                              |                       |
| proxy.type                        | k8s service type. Options: NodePort, ClusterIP, LoadBalancer           | `NodePort`            |
| proxy.loadBalancerIP              | To reuse an existing ingress static IP for the admin service           |                       |
| proxy.ingress.enabled             | Enable ingress resource creation (works with proxy.type=ClusterIP)     | `false`               |
| proxy.ingress.tls                 | Name of secret resource, containing TLS secret                         |                       |
| proxy.ingress.hosts               | List of ingress hosts.                                                 | `[]`                  |
| proxy.ingress.path                | Ingress path.                                                          | `/`                   |
| proxy.ingress.annotations         | Ingress annotations. See documentation for your ingress controller for details | `{}`          |
| env                               | Additional [Kong configurations](https://getkong.org/docs/latest/configuration/)               |
| runMigrations                     | Run Kong migrations job                                                | `true`                |
| readinessProbe                    | Kong readiness probe                                                   |                       |
| livenessProbe                     | Kong liveness probe                                                    |                       |
| affinity                          | Node/pod affinities                                                    |                       |
| nodeSelector                      | Node labels for pod assignment                                         | `{}`                  |
| podAnnotations                    | Annotations to add to each pod                                         | `{}`                  |
| resources                         | Pod resource requests & limits                                         | `{}`                  |
| tolerations                       | List of node taints to tolerate                                        | `[]`                  |

### Kong-specific parameters

Kong has a choice of either Postgres or Cassandra as a backend datatstore.
This chart allows you to choose either of them with the `env.database`
parameter.  Postgres is chosen by default.

Additionally, this chart allows you to use your own database or spin up a new
instance by using the `postgres.enabled` or `cassandra.enabled` parameters.
Enabling both will create both databases in your cluster, but only one
will be used by Kong based on the `env.database` parameter.
Postgres is enabled by default.

| Parameter                         | Description                                                            | Default               |
| ------------------------------    | --------------------------------------------------------------------   | -------------------   |
| cassandra.enabled                 | Spin up a new cassandra cluster for Kong                               | `false`               |
| postgresql.enabled                  | Spin up a new postgres instance for Kong                               | `true `               |
| env.database                      | Choose either `postgres` or `cassandra`                                | `postgres`            |
| env.pg_user                       | Postgres username                                                      | `kong`                |
| env.pg_database                   | Postgres database name                                                 | `kong`                |
| env.pg_password                   | Postgres database password (required if you are using your own database)| `kong`         |
| env.pg_host                       | Postgres database host (required if you are using your own database)   | ``                    |
| env.pg_port                       | Postgres database port                                                 | `5432`                |
| env.cassandra_contact_points      | Cassandra contact points (required if you are using your own database) | ``                    |
| env.cassandra_port                | Cassandra query port                                                   | `9042`                |
| env.cassandra_keyspace            | Cassandra keyspace                                                     | `kong`                |
| env.cassandra_repl_factor         | Replication factor for the Kong keyspace                               | `2`                   |

For complete list of Kong configurations please check https://getkong.org/docs/0.11.x/configuration/.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kong --name my-release \
  --set=image.tag=0.11.2,env.database=cassandra,cassandra.enabled=true
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kong --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
