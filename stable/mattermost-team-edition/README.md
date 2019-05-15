# DEPRECATED - Mattermost Team Edition

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/mattermost/mattermost-helm
- **Charts repo:** https://helm.mattermost.com

```bash
$ helm repo add mattermost https://helm.mattermost.com
```

[Mattermost](https://mattermost.com/) is a hybrid cloud enterprise messaging workspace that brings your messaging and tools together to get more done, faster.

## TL;DR;

```bash
$ helm install stable/mattermost-team-edition \
  --set mysql.mysqlUser=sampleUser \
  --set mysql.mysqlPassword=samplePassword \
```

## Introduction

This chart creates a [Mattermost Team Edition](https://mattermost.com/) deployment on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mattermost-team-edition
```

The command deploys Mattermost on the Kubernetes cluster in the default configuration. The [configuration](#configuration)
section lists the parameters that can be configured during installation.

## Upgrading the Chart to 3.0.0+

Breaking Helm chart changes was introduced with version 3.0.0. The easiest
method of resolving them is to simply upgrade the chart and let it fail with and
provide you with a custom message on what you need to change in your
configuration. Note that this failure will occur before any changes have been
made to the k8s cluster.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Mattermost Team Edition chart and their default values.

Parameter                             | Description                                                                                     | Default
---                                   | ---                                                                                             | ---
`configJSON`                          | The `config.json` configuration to be used by the mattermost server. The values you provide will by using Helm's merging behavior override individual default values only. See the [example configuration](#example-configuration) and the [Mattermost documentation](https://docs.mattermost.com/administration/config-settings.html) for details. |  See `configJSON` in [values.yaml](https://github.com/helm/charts/blob/master/stable/mattermost-team-edition/values.yaml)
`image.repository`                    | Container image repository                                                                      | `mattermost/mattermost-team-edition`
`image.tag`                           | Container image tag                                                                             | `5.9.0`
`image.imagePullPolicy`               | Container image pull policy                                                                     | `IfNotPresent`
`initContainerImage.repository`       | Init container image repository                                                                 | `appropriate/curl`
`initContainerImage.tag`              | Init container image tag                                                                        | `latest`
`initContainerImage.imagePullPolicy`  | Container image pull policy                                                                     | `IfNotPresent`
`revisionHistoryLimit`                | How many old ReplicaSets for Mattermost Deployment you want to retain                           | `1`
`ingress.enabled`                     | If `true`, an ingress is created                                                                | `false`
`ingress.hosts`                       | A list of ingress hosts                                                                         | `[mattermost.example.com]`
`ingress.tls`                         | A list of [ingress tls](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) items | `[]`
`mysql.enabled`                       | Enables deployment of a mysql server                                                            | `true`
`mysql.mysqlRootPassword`             | Root Password for Mysql (Optional)                                                              | ""
`mysql.mysqlUser`                     | Username for Mysql (Required)                                                                   | ""
`mysql.mysqlPassword`                 | User Password for Mysql (Required)                                                              | ""
`mysql.mysqlDatabase`                 | Database name (Required)                                                                        | "mattermost"
`externalDB.enabled`                  | Enables use of an preconfigured external database server                                        | `false`
`externalDB.externalDriverType`       | `"postgres"` or `"mysql"`                                                                       | ""
`externalDB.externalConnectionString` | See the section about [external databases](#External-Databases).                                | ""
`extraEnvVars`                        | Extra environments variables to be used in the deployments                                      | `[]`
`extraInitContainers`                 | Additional init containers                                                                      | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set image.tag=5.7.0 \
  --set mysql.mysqlUser=sampleUser \
  --set mysql.mysqlPassword=samplePassword \
  stable/mattermost-team-edition
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mattermost-team-edition
```

### Example configuration

A basic example of a `.yaml` file with values that could be passed to the `helm`
command with the `-f` or `--values` flag to get started.

```yaml
ingress:
  enabled: true
  hosts:
    - mattermost.example.com

configJSON:
  ServiceSettings:
    SiteURL: "https://mattermost.example.com"
  TeamSettings:
    SiteName: "Mattermost on Example.com"
```

### External Databases
There is an option to use external database services (PostgreSQL or MySQL) for your Mattermost installation.
If you use an external Database you will need to disable the MySQL chart in the `values.yaml`

```Bash
mysql:
  enabled: false
```

#### PostgreSQL
To use an external **PostgreSQL**, You need to set Mattermost **externalDB** config

**IMPORTANT:** Make sure the DB is already created before deploying Mattermost services

```Bash
externalDB:
  enabled: true
  externalDriverType: "postgres"
  externalConnectionString: "postgres://<USERNAME>:<PASSWORD>@<HOST>:5432/<DATABASE_NAME>?sslmode=disable&connect_timeout=10"
```

#### MySQL
To use an external **MySQL**, You need to set Mattermost **externalDB** config

**IMPORTANT:** Make sure the DB is already created before deploying Mattermost services

```Bash
externalDB:
  enabled: true
  externalDriverType: "mysql"
  externalConnectionString: "<USERNAME>:<PASSWORD>@tcp(<HOST>:3306)/<DATABASE_NAME>?charset=utf8mb4,utf8&readTimeout=30s&writeTimeout=30s"
```

#### Limitations

For the Team Edition you can have just one replica running.
