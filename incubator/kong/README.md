# Kong

[Kong](https://getkong.org/) is a scalable, open source API Layer (also known as an API Gateway, 
or API Middleware). Kong runs in front of any RESTful API and is extended through Plugins, which 
provide extra functionality and services beyond the core platform. See 
[What is Kong?](https://getkong.org/about/) for more information.

__DISCLAIMER:__ This Helm Chart was created using Kong documentation, but it is not an officially 
supported or maintained Mashape product.

## Introduction

This Chart bootstraps Kong as a Kubernetes deployment with support for proxy and admin endpoints.

__NOTE:__ This Chart can be configured to use Kong supported data stores of PostgreSQL or Cassandra
but it does not intend to manage or deploy those sources. See the 
[PostgreSQL Chart](https://github.com/kubernetes/charts/tree/master/stable/postgresql) 
for existing support for PostgreSQL.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PostgreSQL or Cassandra data store
- You are deploying the Chart to a cluster with a cloud provider capable of provisioning an
external load balancer (e.g. AWS or GKE)

## Installing the Chart

To install the Chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --wait --name my-release incubator/kong
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the Chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Kong Chart and their default values.

### General Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cpuRequest` | Initial share of CPU requested per Kong pod | `200m` |
| `memoryRequest` | Initial share of memory requested per Kong pod | `100Mi` |
| `cpuLimit` | CPU limit per Kong pod | `200m` |
| `memoryLimit` | Memory limit per Kong pod | `150Mi` |
| `image.repository` | The image repository to pull from | `kong` (official repo) |
| `image.tag` | The image tag to pull from | `0.10.0` |
| `replicas` | The number of replicas to run; __NOTE:__ Currently Kong may experience problems during database migrations if more than the default of one replica is used, see `TODO` section | `1` |
| `logLevel` | Log level of the Nginx server | `warn` |
| `proxy.service.type` | A valid Kubernetes service type for the Kong proxy Service definition | `LoadBalancer` |
| `proxy.service.loadBalancerSourceRanges` | Allow access from these source IP ranges to the Kong proxy Service, specified as an array; __NOTE:__ must be supported by your cloud provider | `[ 0.0.0.0/0 ]` |
| `proxy.service.port` | Port exposed by Kong proxy Service | `8000` |
| `proxy.service.sslPort` | SSL port exposed by Kong proxy Service | `8443` |
| `proxy.service.annotations` | Annotations for the Kong proxy Service definition, specified as a map | None |
| `proxy.service.labels` | Additional labels for the Kong Service definition, specified as a map | None |
| `admin.service.type` | A valid Kubernetes service type for the Kong admin Service definition | `LoadBalancer` |
| `admin.service.loadBalancerSourceRanges` | Allow access from these source IP ranges to the Kong admin Service, specified as an array; __NOTE:__ must be supported by your cloud provider | `[ 0.0.0.0/0 ]` |
| `admin.service.port` | Port exposed by Kong admin Service | `8001` |
| `admin.service.annotations` | Annotations for the Kong admin Service definition, specified as a map | None |
| `admin.service.labels` | Additional labels for the Kong admin definition, specified as a map | None |

### Data Store Configuration

The Kong data store is configurable as PostgreSQL or Cassandra. Only one should be configured
while the configuration for the other should be left out entirely.

__NOTE:__ If both are specified, the Chart will default to using PostgreSQL. If neither are specified
then Kong itself will default to PostgreSQL and the Chart will deploy but will likely fail to run
successfully (unless there happens to be a PostgreSQL server running on the container `localhost`).

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgres.host` | Host of the Postgres server | Kong default (`127.0.0.1`) |
| `postgres.port` | Port of the Postgres server | Kong default (`5432`) |
| `postgres.user` | Postgres user | Kong default (`kong`) |
| `postgres.password` | Postgres user's password | Kong default (`kong`) |
| `postgres.database` | Database to connect to | Kong default (`kong`) |
| `postgres.ssl` | Toggles client-server TLS connections between Kong and PostgreSQL | Kong default (`off`) |
| `postgres.sslVerify` | Toggles server certificate verification if `postgres.ssl` is enabled.| Kong default (`off`) |
| `cassandra.contactPoints` | Comma-separated list of contacts points to your cluster | Kong default (`127.0.0.1`) |
| `cassandra.port` | Port on which your nodes are listening | Kong default (`9042`) |
| `cassandra.keyspace` | Keyspace to use in your cluster. Will be created if doesn't exist | Kong default (`kong`) |
| `cassandra.consistency` | Consistency setting to use when reading/writing | Kong default (`ONE`) |
| `cassandra.timeout` | Timeout (in ms) for reading/writing | Kong default (`5000`) |
| `cassandra.ssl` | Enable SSL connections to the nodes | Kong default (`off`) |
| `cassandra.sslVerify` | If cassandra_ssl is enabled, toggle server certificate verification. See lua_ssl_trusted_certificate setting | Kong default (`off`) |
| `cassandra.username` | Username when using the PasswordAuthenticator scheme | Kong default (`kong`) |
| `cassandra.password` | Password when using the PasswordAuthenticator scheme | Kong default (`kong`) |
| `cassandra.replStrategy` | If creating the keyspace for the first time, specify a replication strategy | Kong default (`SimpleStrategy`) |
| `cassandra.replFactor` | Specify a replication factor for the SimpleStrategy | Kong default (`1`) |
| `cassandra.dataCenters` | Specify data centers for the NetworkTopologyStrategy | Kong default (`dc1:2,dc2:3`) |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the Chart. For example,

```console
$ helm install --wait --name my-release -f values.yaml incubator/kong
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Linking to Kubernetes Services

As of v0.10.0, Kong includes internal DNS resolution (A and SRV records). To link Kong to
Kubernetes Services, use a Kong `upstream_url` pointing at `my-svc.my-namespace.svc.cluster.local`.
For example if you have a service named `backend1` in the `default` namespace then the 
`upstream_url` would look like `http://backend1.default.svc.cluster.local`.

See the Kubernetes
[DNS Pods and Services](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
documentation for more details.

## Kong Documentation

- [Generic information about Kong](https://getkong.org/)
- [Kong documentation](https://getkong.org/docs/)
- [Kong v0.10.x configuration](https://getkong.org/docs/0.10.x/configuration/)

## TODO

- [x] Basic setup and configuration
- [x] Postgres and Cassandra support
- [x] v0.10.0
- [ ] Ensure [Kong DB migrations only get run by single Kong instance](https://github.com/Mashape/kong/issues/2125#issuecomment-284880157)
- [ ] Enable [Docker logs](https://github.com/Mashape/docker-kong/issues/40)
- [ ] More options to secure admin endpoint such as internal network only
- [ ] Support for `cassandra_consistency`, `cassandra_lb_policy` and `cassandra_local_datacenter` configuration
- [ ] Ensure we don't have a [ghost instance problem](https://github.com/Mashape/kong/issues/2192)
- [ ] Ensure [clear text credentials generated by Kong](https://github.com/Mashape/kong/issues/1806) are cleared
- [ ] Optional Kong dashboard
