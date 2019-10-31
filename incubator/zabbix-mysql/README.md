# Zabbix mysql

[Zabbix](https://www.zabbix.com/) is a monitoring system.

Zabbix can use postgresql or mysql. This chart implementes the mysql flavor of zabbix.

## TL;DR;

```console
$ helm install incubator/zabbix-mysql
```

## Introduction

This chart bootstraps a [Zabbix](https://www.zabbix.com/documentation/4.4/manual/installation/containers) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also uses the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Zabbix application.


## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta4+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/zabbix-mysql
```

The command deploys Zabbix on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the WordPress chart and their default values.

|            Parameter                       |                                  Description                                 |                           Default                            |
| ------------------------------------------ | ---------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `image.zabbix_server_mysql.registry`       | Zabbix server mysql image registry                                           | `docker.io`                                                  |
| `image.zabbix_server_mysql.repository`     | Zabbix server image name                                                     | `zabbix/zabbix-server-mysql`                                 |
| `image.zabbix_server_mysql.tag`            | Zabbix server image tag                                                      | `{TAG_NAME}`                                                 |
| `image.zabbix_server_mysql.pullPolicy`     | Image pull policy                                                            | `IfNotPresent`                                               |
| `image.zabbix_server_mysql.pullSecrets`    | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods)      |
| `image.zabbix_web_nginx_mysql.registry`    | Zabbix web mysql image registry                                              | `docker.io`                                                  |
| `image.zabbix_web_nginx_mysql.repository`  | Zabbix web image name                                                        | `zabbix/zabbix-web-nginx-mysql`                              |
| `image.zabbix_web_nginx_mysql.tag`         | Zabbix web image tag                                                         | `{TAG_NAME}`                                                 |
| `image.zabbix_web_nginx_mysql.pullPolicy`  | Image pull policy                                                            | `IfNotPresent`                                               |
| `image.zabbix_web_nginx_mysql.pullSecrets` | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods)      |
| `image.zabbix_agent.registry`              | Zabbix agent image registry                                                  | `docker.io`                                                  |
| `image.zabbix_agent.repository`            | Zabbix agent image name                                                      | `zabbix/zabbix-agent`                                        |
| `image.zabbix_agent.tag`                   | Zabbix agent image tag                                                       | `{TAG_NAME}`                                                 |
| `image.zabbix_agent.pullPolicy`            | Image pull policy                                                            | `IfNotPresent`                                               |
| `image.zabbix_agent.pullSecrets`           | Specify docker-registry secret names as an array                             | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride.`                            | Strings to partially override fullname templates with a string (will prepend the release name) | `nil`                                      |
| `fullnameOverride.`                        | Strings to fully override fullname templates with a string                                     | `nil`                                      |
| `replicaCount.zabbix_web_nginx_mysql`      | Number of Web Pods to run                                                    | `2`                                                          |
| `service.zabbix_server_mysql.type`         | Kubernetes Service type                                                      | `ClusterIP`                                                  |
| `service.zabbix_server_mysql.port`         | Service TCP port                                                             | `10051`                                                      |
| `service.zabbix_web_nginx_mysql.type`      | Kubernetes Service type                                                      | `ClusterIP`                                                  |
| `service.zabbix_web_nginx_mysql.port`      | Service HTTP port                                                            | `80`                                                         |
| `zabbix_web_nginx.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                          | `20`                                                         |
| `zabbix_web_nginx.livenessProbe.periodSeconds`        | How often to perform the probe                                    | `10`                                                         |
| `zabbix_web_nginx.livenessProbe.timeoutSeconds`       | When the probe times out                                          | `5`                                                          |
| `zabbix_web_nginx.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                        | `6`                                                          |
| `zabbix_web_nginx.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                       | `1`                                                          |
| `zabbix_web_nginx.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                         | `10`                                                         |
| `zabbix_web_nginx.readinessProbe.periodSeconds`       | How often to perform the probe                                    | `10`                                                         |
| `zabbix_web_nginx.readinessProbe.timeoutSeconds`      | When the probe times out                                          | `5`                                                          |
| `zabbix_web_nginx.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                        | `6`                                                          |
| `zabbix_web_nginx.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                       | `1`                                                          |
| `zabbix_server_mysql.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                       | `60`                                                         |
| `zabbix_server_mysql.livenessProbe.periodSeconds`        | How often to perform the probe                                 | `10`                                                         |
| `zabbix_server_mysql.livenessProbe.timeoutSeconds`       | When the probe times out                                       | `5`                                                          |
| `zabbix_server_mysql.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                     | `6`                                                          |
| `zabbix_server_mysql.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                    | `1`                                                          |
| `zabbix_server_mysql.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                      | `10`                                                         |
| `zabbix_server_mysql.readinessProbe.periodSeconds`       | How often to perform the probe                                 | `10`                                                         |
| `zabbix_server_mysql.readinessProbe.timeoutSeconds`      | When the probe times out                                       | `5`                                                          |
| `zabbix_server_mysql.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                     | `6`                                                          |
| `zabbix_server_mysql.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                    | `1`                                                          |
| `ingress.enabled`                         | Enable ingress controller resource                                            | `false`                                                      |
| `ingress.certManager`                     | Add annotations for cert-manager                                              | `false`                                                      |
| `ingress.hostname`                        | Default host for the ingress resource                                         | `zabbix.local`                                               |
| `ingress.annotations`                     | Ingress annotations                                                           | `[]`                                                         |
| `ingress.hosts[0].name`                   | Hostname to your zabbix installation                                          | `zabbix.local`                                               |
| `ingress.hosts[0].path`                   | Path within the url structure                                                 | `/`                                                          |
| `ingress.tls[0].hosts[0]`                 | TLS hosts                                                                     | `zabbix.local`                                               |
| `ingress.tls[0].secretName`               | TLS Secret (certificates)                                                     | `zabbix.local-tls`                                           |
| `ingress.secrets[0].name`                 | TLS Secret Name                                                               | `nil`                                                        |
| `ingress.secrets[0].certificate`          | TLS Secret Certificate                                                        | `nil`                                                        |
| `ingress.secrets[0].key`                  | TLS Secret Key                                                                | `nil`                                                        |
| `schedulerName`                           | Name of the alternate scheduler                                               | `nil`                                                        |
| `persistence.storageClass`                | PVC Storage  Class                                                            | `nil` (uses alpha storage class annotation)                  |
| `persistence.alertscripts.enabled`        | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.alertscripts.accessMode`     | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.alertscripts.size`           | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.alertscripts.claimName`      | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.externalscripts.enabled`     | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.externalscripts.accessMode`  | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.externalscripts.size`        | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.externalscripts.claimName`   | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.enc.enabled`                 | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.enc.accessMode`              | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.enc.size`                    | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.enc.claimName`               | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.mibs.enabled`                | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.mibs.accessMode`             | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.mibs.size`                   | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.mibs.claimName`              | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.modules.enabled`             | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.modules.accessMode`          | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.modules.size`                | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.modules.claimName`           | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.snmptraps.enabled`           | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.snmptraps.accessMode`        | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.snmptraps.size`              | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.snmptraps.claimName`         | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.ssh_keys.enabled`            | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.ssh_keys.accessMode`         | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.ssh_keys.size`               | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.ssh_keys.claimName`          | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.ssl.certs.enabled`           | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.ssl.certs.accessMode`        | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.ssl.certs.size`              | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.ssl.certs.claimName`         | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.ssl.keys.enabled`            | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.ssl.keys.accessMode`         | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.ssl.keys.size`               | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.ssl.keys.claimName`          | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.ssl.ssl_ca.enabled`          | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.ssl.ssl_ca.accessMode`       | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.ssl.ssl_ca.size`             | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.ssl.ssl_ca.claimName`        | PVC Storage Name                                                              | `alertscripts`                                               |
| `persistence.userscripts.enabled`         | Enable persistence using PVC                                                  | `false`                                                      |
| `persistence.userscripts.accessMode`      | PVC Access Mode                                                               | `ReadWriteOnce`                                              |
| `persistence.userscripts.size`            | PVC Storage Request                                                           | `100Mi`                                                      |
| `persistence.userscripts.claimName`       | PVC Storage Name                                                              | `alertscripts`                                               |
| `nodeSelector`                            | Node labels for pod assignment                                                | `{}`                                                         |
| `tolerations`                             | List of node taints to tolerate                                               | `[]`                                                         |
| `affinity`                                | Map of node/pod affinities                                                    | `{}`                                                         |
| `podAnnotations`                          | Pod annotations                                                               | `{}`                                                         |
| `updateStrategy`                          | Set up update strategy                                                        | `RollingUpdate` for web and `Recreate` for server            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set zabbix_vars.zbx_server_name=zabbix \
    incubator/zabbix-mysql
```

The above command sets the visible Zabbix installation name in right top corner of the web interface.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/zabbix-mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Production configuration

- Number of Zabbix web pods to run
```diff
- replicaCount:
-   zabbix_web_nginx_mysql: 1
+ replicaCount:
+   zabbix_web_nginx_mysql: 2
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your WordPress application.

To enable ingress integration, please set `ingress.enabled` to `true`

