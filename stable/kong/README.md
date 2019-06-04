## Kong

[Kong](https://KongHQ.com/) is an open-source API Gateway and Microservices
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

| Parameter                      | Description                                                                      | Default             |
| ------------------------------ | -------------------------------------------------------------------------------- | ------------------- |
| image.repository               | Kong image                                                                       | `kong`              |
| image.tag                      | Kong image version                                                               | `1.1`               |
| image.pullPolicy               | Image pull policy                                                                | `IfNotPresent`      |
| image.pullSecrets              | Image pull secrets                                                               | `null`              |
| replicaCount                   | Kong instance count                                                              | `1`                 |
| admin.useTLS                   | Secure Admin traffic                                                             | `true`              |
| admin.servicePort              | TCP port on which the Kong admin service is exposed                              | `8444`              |
| admin.containerPort            | TCP port on which Kong app listens for admin traffic                             | `8444`              |
| admin.nodePort                 | Node port when service type is `NodePort`                                        |                     |
| admin.hostPort                 | Host port to use for admin traffic                                               |                     |
| admin.type                     | k8s service type, Options: NodePort, ClusterIP, LoadBalancer                     | `NodePort`          |
| admin.loadBalancerIP           | Will reuse an existing ingress static IP for the admin service                   | `null`              |
| admin.loadBalancerSourceRanges | Limit admin access to CIDRs if set and service type is `LoadBalancer`            | `[]`                |
| admin.ingress.enabled          | Enable ingress resource creation (works with proxy.type=ClusterIP)               | `false`             |
| admin.ingress.tls              | Name of secret resource, containing TLS secret                                   |                     |
| admin.ingress.hosts            | List of ingress hosts.                                                           | `[]`                |
| admin.ingress.path             | Ingress path.                                                                    | `/`                 |
| admin.ingress.annotations      | Ingress annotations. See documentation for your ingress controller for details   | `{}`                |
| proxy.http.enabled             | Enables http on the proxy                                                        | true                |
| proxy.http.servicePort         | Service port to use for http                                                     | 80                  |
| proxy.http.containerPort       | Container port to use for http                                                   | 8000                |
| proxy.http.nodePort            | Node port to use for http                                                        | 32080               |
| proxy.http.hostPort            | Host port to use for http                                                        |                     |
| proxy.tls.enabled              | Enables TLS on the proxy                                                         | true                |
| proxy.tls.containerPort        | Container port to use for TLS                                                    | 8443                |
| proxy.tls.servicePort          | Service port to use for TLS                                                      | 8443                |
| proxy.tls.nodePort             | Node port to use for TLS                                                         | 32443               |
| proxy.tls.hostPort             | Host port to use for TLS                                                         |                     |
| proxy.type                     | k8s service type. Options: NodePort, ClusterIP, LoadBalancer                     | `NodePort`          |
| proxy.loadBalancerSourceRanges | Limit proxy access to CIDRs if set and service type is `LoadBalancer`            | `[]`                |
| proxy.loadBalancerIP           | To reuse an existing ingress static IP for the admin service                     |                     |
| proxy.externalIPs              | IPs for which nodes in the cluster will also accept traffic for the proxy        | `[]`                |
| proxy.externalTrafficPolicy    | k8s service's externalTrafficPolicy. Options: Cluster, Local                     |                     |
| proxy.ingress.enabled          | Enable ingress resource creation (works with proxy.type=ClusterIP)               | `false`             |
| proxy.ingress.tls              | Name of secret resource, containing TLS secret                                   |                     |
| proxy.ingress.hosts            | List of ingress hosts.                                                           | `[]`                |
| proxy.ingress.path             | Ingress path.                                                                    | `/`                 |
| proxy.ingress.annotations      | Ingress annotations. See documentation for your ingress controller for details   | `{}`                |
| env                            | Additional [Kong configurations](https://getkong.org/docs/latest/configuration/) |                     |
| runMigrations                  | Run Kong migrations job                                                          | `true`              |
| readinessProbe                 | Kong readiness probe                                                             |                     |
| livenessProbe                  | Kong liveness probe                                                              |                     |
| affinity                       | Node/pod affinities                                                              |                     |
| nodeSelector                   | Node labels for pod assignment                                                   | `{}`                |
| podAnnotations                 | Annotations to add to each pod                                                   | `{}`                |
| resources                      | Pod resource requests & limits                                                   | `{}`                |
| tolerations                    | List of node taints to tolerate                                                  | `[]`                |

### Admin/Proxy listener override

If you specify `env.admin_listen` or `env.proxy_listen`, this chart will use
the value provided by you as opposed to constructing a listen variable
from fields like `proxy.http.containerPort` and `proxy.http.enabled`. This allows
you to be more prescriptive when defining listen directives.

**Note:** Overriding `env.proxy_listen` and `env.admin_listen` will potentially cause 
`admin.containerPort`, `proxy.http.containerPort` and `proxy.tls.containerPort` to become out of sync, 
and therefore must be updated accordingly.

I.E. updatating to `env.proxy_listen: 0.0.0.0:4444, 0.0.0.0:4443 ssl` will need 
`proxy.http.containerPort: 4444` and `proxy.tls.containerPort: 4443` to be set in order 
for the service definition to work properly.

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
| postgresql.enabled                | Spin up a new postgres instance for Kong                               | `true`                |
| waitImage.repository              | Image used to wait for database to become ready                        | `busybox`             |
| waitImage.tag                     | Tag for image used to wait for database to become ready                | `latest`              |
| env.database                      | Choose either `postgres` or `cassandra`                                | `postgres`            |
| env.pg_user                       | Postgres username                                                      | `kong`                |
| env.pg_database                   | Postgres database name                                                 | `kong`                |
| env.pg_password                   | Postgres database password (required if you are using your own database)| `kong`               |
| env.pg_host                       | Postgres database host (required if you are using your own database)   | ``                    |
| env.pg_port                       | Postgres database port                                                 | `5432`                |
| env.cassandra_contact_points      | Cassandra contact points (required if you are using your own database) | ``                    |
| env.cassandra_port                | Cassandra query port                                                   | `9042`                |
| env.cassandra_keyspace            | Cassandra keyspace                                                     | `kong`                |
| env.cassandra_repl_factor         | Replication factor for the Kong keyspace                               | `2`                   |


All `kong.env` parameters can also accept a mapping instead of a value to ensure the parameters can be set through configmaps and secrets.

An example :

```yaml
kong:
  env:
     pg_user: kong
     pg_password:
       valueFrom:
         secretKeyRef:
            key: kong
            name: postgres
```
 

For complete list of Kong configurations please check https://getkong.org/docs/latest/configuration/.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kong --name my-release \
  --set=image.tag=1.1,env.database=cassandra,cassandra.enabled=true
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install stable/kong --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Kong Ingress Controller

Kong Ingress Controller's primary purpose is to satisfy Ingress resources
created in your Kubernetes cluster.
It uses CRDs for more fine grained control over routing and
for Kong specific configuration.
To deploy the ingress controller together with
kong run the following command:

```bash
# without a database
helm install stable/kong --set ingressController.enabled=true \
  --set postgresql.enabled=false --set env.database=off
# with a database
helm install stable/kong --set ingressController.enabled=true
```

If you like to use a static IP:

```shell
helm install stable/kong --set ingressController.enabled=true --set proxy.loadBalancerIP=[Your IP goes there] --set proxy.type=LoadBalancer --name kong --namespace kong
```

**Note**: Kong Ingress controller doesn't support custom SSL certificates
on Admin port. We will be removing this limitation in the future.

Kong ingress controller relies on several Custom Resource Definition objects to
declare the the Kong configurations and synchronize the configuration with the
Kong admin API. Each of this new objects  declared in Kubernetes have a
one-to-one relation with a Kong resource.
The custom resources are:

- KongConsumer
- KongCredential
- KongPlugin
- KongIngress

You can can learn about kong ingress custom resource definitions here:

- [https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/custom-resources.md]()

| Parameter        | Description                                 | Default                                                                      |
| ---------------  | -----------------------------------------   | ---------------------------------------------------------------------------- |
| enabled          | Deploy the ingress controller, rbac and crd | false                                                                        |
| replicaCount     | Number of desired ingress controllers       | 1                                                                            |
| image.repository | Docker image with the ingress controller    | kong-docker-kubernetes-ingress-controller.bintray.io/kong-ingress-controller |
| image.tag        | Version of the ingress controller           | 0.2.0                                                                        |
| readinessProbe   | Kong ingress controllers readiness probe    |                                                                              |
| livenessProbe    | Kong ingress controllers liveness probe     |                                                                              |
| ingressClass     | The ingress-class value for controller      | nginx
