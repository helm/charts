# Kafka Manager Helm Chart

[Kafka Manager](https://github.com/yahoo/kafka-manager) is a tool for managing [Apache Kafka](http://kafka.apache.org/).

## TL;DR;

```bash
$ helm install stable/kafka-manager
```

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/kafka-manager
```

The command deploys Kafka Manager on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Kafka Manager chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`serviceAccount.create` | If true, create a service account for kafka-manager | `true`
`serviceAccount.name` | Name of the service account to create or use | `{{ kafka-manager.fullname }}`
`livenessProbe` | Liveness probe configurations | `{ "httpGet": { "path": "/api/health", "port": "kafka-manager" }, "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10 }`
`readinessProbe` | Readiness probe configurations | `{ "httpGet": { "path": "/api/health", "port": "kafka-manager" } }`
`image.repository` | Container image repository | `zenko/kafka-manager`
`image.tag` | Container image tag | `1.3.3.22`
`image.pullPolicy` | Container image pull policy | `IfNotPresent`
`zkHosts` | Zookeeper hosts required by the kafka-manager | `localhost:2181`
`clusters` | Configuration of the clusters to manage | `{}`
`applicationSecret` | Kafka-manager application secret | `""`
`basicAuth.enabled` | If true, enable basic authentication | `false`
`basicAuth.username` | Username for basic auth | `admin`
`basicAuth.password` | Password for basic auth | `""`
`basicAuth.ldap.enabled` | If true, enable LDAP authentication | `false`
`basicAuth.ldap.server` | FQDN of the LDAP server | `""`
`basicAuth.ldap.port` | Port used for LDAP | `""`
`basicAuth.ldap.username` | Optional LDAP DN to bind for query | `""`
`basicAuth.ldap.pasword`  | Optional LDAP password for the DN | `""`
`basicAuth.ldap.searchBaseDn` | LDAP search base | `""`
`basicAuth.ldap.searchFilter` | LDAP search filter for a valid account | `""`
`basicAuth.ldap.connectionPoolSize` | LDAP connection pool size | `10`
`basicAuth.ldap.ssl` | Enable LDAPS (not StartTLS) | `false`
`javaOptions` | Java runtime options | `""`
`service.type` | Kafka-manager service type | `ClusterIP`
`service.port` | Kafka-manager service port | `9000`
`service.annotations` | Optional service annotations | `{}`
`ingress.enabled` | If true, create an ingress resource | `false`
`ingress.annotations` | Optional ingress annotations | `{}`
`ingress.path` | Ingress path | `/`
`ingress.hosts` | Ingress hostnames | `kafka-manager.local`
`ingress.tls` | Ingress TLS configuration | `[]`
`resources` | Pod resource requests and limits | `{}`
`nodeSelector` | Node labels for pod assignment | `{}`
`tolerations` | Tolerations for pod assignment | `[]`
`affinity` | Affinity for pod assignment | `{}`
`zookeeper.enabled` | If true, deploy Zookeeper | `false`
`zookeeper.env` | Environmental variables for Zookeeper | `ZK_HEAP_SIZE: "1G"`
`zookeeper.persistence` | If true, enable persistence for Zookeeper | `false`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kafka-manager --name my-release \
    --set ingress.enabled=true
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kafka-manager --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
