# Schema-Registry-UI Helm Chart
This helm chart creates a [Schema-Registry-UI server](https://github.com/Landoop/schema-registry-ui).

This is a web tool for the confluentinc/schema-registry in order to create / view / search / evolve / view history & configure Avro schemas of your Kafka cluster.


## Prerequisites
* Kubernetes 1.8
* A running Kafka Installation
* A running Zookeeper Installation
* A running Schema-Registry installation

## Chart Components
This chart will do the following:

* Create a Schema-Registry-UI deployment
* Create a Service configured to connect to the available Schema-Registry-UI pods on the configured
  client port.

## Installing the Chart
You can install the chart with the release name `srui` as below.

```console
$ helm install --name srui schema-registry-ui
```

If you do not specify a name, helm will select a name for you.

```console{%raw}
$ kubectl get all -l app=schema-registry-ui
NAME                          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/srui-schema-registry-ui   1         1         1            1           23m

NAME                                DESIRED   CURRENT   READY     AGE
rs/srui-schema-registry-ui-bcb4c994c   1         1         1         23m

NAME                                      READY     STATUS    RESTARTS   AGE
po/srui-schema-registry-ui-bcb4c994c-qjqbj   1/1       Running   1          23m
```

1. `deploy/srui-schema-registry-ui` is the Deployment created by this chart.
1. `rs/srui-schema-registry-ui-bcb4c994c` is the ReplicaSet created by this Chart's Deployment.
1. `po/srui-schema-registry-ui-bcb4c994c-qjqbj` is the Pod created by the ReplicaSet under this Chart's Deployment.

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml schema-registry-ui
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Parameters
The following table lists the configurable parameters of the SchemaRegistryUI chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | The number of `SchemaRegistryUI` Pods in the Deployment | `1` |
| `image.repository` | The `SchemaRegistryUI` image repository | `landoop/schema-registry-ui` |
| `image.tag` | The `SchemaRegistryUI` image tag | `0.9.5` |
| `image.imagePullPolicy` | Image Pull Policy | `IfNotPresent` |
| `schemaRegistry.url` | URL to the schema registry endpoint | `http://localhost` |
| `schemaRegistry.port` | Port for the schema registry | `8081` |
| `schemaRegistry.proxy` | Whether to proxy Schema Registry endpoint via the internal webserver | `false` |
| `schemaRegistry.allowGlobal` | Support for global compatibility level configuration support —i.e change the default compatibility level of your schema registry | `false` |
| `schemaRegistry.allowTransitive` | Support for transitive compatibility levels (Schema Registry version 3.1.1 or better) | `false` |
| `schemaRegistry.allowDeletion` | Support for Schema deletion (Schema Registry version 3.3.0 or better) | `false` |
| `schemaRegistry.readOnlyMode` | Support for readonly mode (overwrites settings for global compatibility configuration and schema deletion) | `false` |
| `service.type` | Type of the service | `LoadBalancer` |
| `service.port` | Port to use | `80` |
| `service.annotations` | Kubernetes service annotations | `{}` |
| `service.loadBalancerSourceRanges` | Limit load balancer source IPs to list of CIDRs (where available)) | None |
| `ingress.enabled` | Ingress rules. Disabled by default | `false` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.path` | Ingress path | `/` |
| `ingress.hosts` | Ingress accepted hostnames | `[schema-registry-ui.local]` |
| `ingress.tls` | Ingress TLS configuration | `/` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | List of node taints to tolerate | `[]` |
| `affinity` | Node/pod affinities | `{}` |
| `resources` | CPU/Memory resource requests/limits | `{}` |
