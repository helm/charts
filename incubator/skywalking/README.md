# Apache Skywalking Helm Chart

[Apache SkyWalking](https://skywalking.apache.org/) is application performance monitor tool for distributed systems, especially designed for microservices, cloud native and container-based (Docker, K8s, Mesos) architectures.

## Introduction

This chart bootstraps a [Apache SkyWalking](https://skywalking.apache.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

 - Kubernetes 1.9.6+ 
 - PV dynamic provisioning support on the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release skywalking
```

The command deploys Apache Skywalking on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Skywalking chart and their default values.

| Parameter                             | Description                                                        | Default                             |
|---------------------------------------|--------------------------------------------------------------------|-------------------------------------|
| `nameOverride`                        | Override name                                                      | `nil`                               |
| `serviceAccounts.oap`                 | Name of the OAP service account to use or create                   | `nil`                               |
| `oap.name`                            | OAP deployment name                                                | `oap`                               |
| `oap.image.repository`                | OAP container image name                                           | `apache/skywalking-oap-server`      |
| `oap.image.tag`                       | OAP container image tag                                            | `6.1.0`                             |
| `oap.image.pullPolicy`                | OAP container image pull policy                                    | `IfNotPresent`                      |
| `oap.ports.grpc`                      | OAP grpc port for tracing or metric                                | `11800`                             |
| `oap.ports.rest`                      | OAP http port for Web UI                                           | `12800`                             |
| `oap.replicas`                        | OAP k8s deployment replicas                                        | `2`                                 |
| `oap.service.type`                    | OAP svc type                                                       | `ClusterIP`                         |
| `oap.javaOpts`                        | Parameters to be added to `JAVA_OPTS`environment variable for OAP  | `-Xms2g -Xmx2g`                     |
| `oap.antiAffinity`                    | OAP anti-affinity policy                                           | `soft`                              |
| `oap.nodeAffinity`                    | OAP node affinity policy                                           | `{}`                                |
| `oap.nodeSelector`                    | OAP labels for master pod assignment                               | `{}`                                |
| `oap.tolerations`                     | OAP tolerations                                                    | `[]`                                |
| `oap.resources`                       | OAP node resources requests & limits                               | `{} - cpu limit must be an integer` |
| `oap.env`                             | OAP environment variables                                          | `[]`                                |
| `ui.name`                             | Web UI deployment name                                             | `ui`                                |
| `ui.replicas`                         | Web UI k8s deployment replicas                                     | `1`                                 |
| `ui.image.repository`                 | Web UI container image name                                        | `apache/skywalking-ui`              |
| `ui.image.tag`                        | Web UI container image tag                                         | `6.1.0`                             |
| `ui.image.pullPolicy`                 | Web UI container image pull policy                                 | `IfNotPresent`                      |
| `ui.ingress.enabled`                  | Create Ingress for Web UI                                          | `false`                             |
| `ui.ingress.annotations`              | Associate annotations to the Ingress                               | `{}`                                |
| `ui.ingress.path`                     | Associate path with the Ingress                                    | `/`                                 |
| `ui.ingress.hosts`                    | Associate hosts with the Ingress                                   | `[]`                                |
| `ui.ingress.tls`                      | Associate TLS with the Ingress                                     | `[]`                                |
| `ui.service.type`                     | Web UI svc type                                                    | `ClusterIP`                         |
| `ui.service.externalPort`             | external port for the service                                      | `80`                                |
| `ui.service.internalPort`             | internal port for the service                                      | `8080`                              |
| `ui.service.externalIPs`              | external IP addresses                                              | `nil`                               |
| `ui.service.loadBalancerIP`           | Load Balancer IP address                                           | `nil`                               |
| `ui.service.annotations`              | Kubernetes service annotations                                     | `{}`                                |
| `ui.service.loadBalancerSourceRanges` | Limit load balancer source IPs to list of CIDRs (where available)) | `[]`                                |
| `elasticsearch.enabled`               | Spin up a new elasticsearch cluster for SkyWalking                 | `true`                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install skywalking  --name=myrelease --set nameOverride=newSkywalking
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install skywalking --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### RBAC Configuration
Roles and RoleBindings resources will be created automatically for `OAP` .

> **Tip**: You can refer to the default `oap-role.yaml` file in [templates](templates/) to customize your own.

### Ingress TLS
If your cluster allows automatic create/retrieve of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(skywalking ui) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls skywalking-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the skywalking-ui Ingress TLS section of your custom `values.yaml` file:

```yaml
ui:
  ingress:
    ## If true, Skywalking ui server Ingress will be created
    ##
    enabled: true

    ## Skywalking ui server Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - skywalking.domain.com

    ## Skywalking ui server Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: skywalking-tls
        hosts:
          - skywalking.domain.com
```
