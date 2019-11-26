# Drupal

[Postput](https://github.com/postput/postput) is a cloud native storage operator - Upload, download and perform on-the-fly operations on your files

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/postput
```

## Introduction

This chart bootstraps a [Postput API](https://github.com/postput/api) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Postgresql](https://github.com/helm/charts/tree/master/stable/postgresql) which is required for storing information about storages.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/postput
```

The command deploys [Postput APÏ](https://github.com/postput/api/) on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the postput chart and their default values.

| Parameter                         | Description                                | Default                                                   |
| --------------------------------- | ------------------------------------------ | --------------------------------------------------------- |
| `replicaCount`                    | The number of replicas in the postput deployment               | `1`                                                     |
| `fullnameOverride`                | String to fully override postput.fullname template with a string                                     | `nil` |
| `nameOverride`                    | String to partially override postput.fullname template with a string (will prepend the release name) | `nil` |
| `imageOverride`         | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                  | Postput image registry                      | ``                                               |
| `image.repository`                | Postput Image name                          | `postput/postput`                                          |
| `image.tag`                       | Postput Image tag                           | `latest`                                              |
| `image.pullPolicy`                | Postput image pull policy                   | `Always`                                            |
| `image.pullSecrets`               | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)  |
| `env[0].name`                     | Environment variable name passed to each pod of the cluster              | `POSTGRESQL_PORT`                                                       |
| `env[0].value`                    | Environment variable value passed to each pod of the cluster              | `5432`                                                       |
| `customStorages`                  | Flat JSON of your storages                 | `nil`                                                     |
| `customStoragesMountPath`         | Path where `customStorages` will be mounted            | `/`                                                       |
| `ingress.enabled`                 | Enable ingress controller resource         | `false`                                                   |
| `ingress.annotations`             | Annotations for the Ingress | `[]`                                                      |
| `ingress.hosts[0].name`           | Hostname to your postput installation       | `www.yourdomain.com`                                            |
| `ingress.hosts[0].paths[0]`       | Path within the url structure              | `["/"]`                                                       |
| `ingress.tls[0].secretName`       | Utilize TLS backend in ingress             | `your-secret-name-tls`                                                   |
| `ingress.tls[0].hosts[0]`         | Hostname managed by this `secretName`           | `["www.yourdomain.com"]`                                                   |
| `postgresql.enabled`           | Existing username in the external db       | `bn_drupal`                                               |
| `postgresql.fullnameOverride`       | Password for the above username            | `nil`                                                     |
| `postgresql.persistence.enabled`       | Name of the existing database              | `bitnami_drupal`                                          |
| `postgresql.global.postgresql.postgresqlDatabase`                 | Whether to use the MariaDB chart           | `true`                                                    |
| `postgresql.global.postgresql.postgresqlUsername`                 | Whether to use the MariaDB chart           | `true`                                                    |
| `postgresql.global.postgresql.postgresqlPassword`                 | Whether to use the MariaDB chart           | `true`                                                    |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                            |
| `service.port`                    | Service HTTP port                          | `80`                                                      |
| `service.nodePort`                | Kubernetes node port                  | `""`                                                      |
| `resources`                       | CPU/Memory resource requests/limits        | Memory: `512Mi`, CPU: `300m`                              |
| `affinity`                        | Map of node/pod affinities                 | `{}`                                                      |
| `nodeSelector`                    | Map of node selector                 | `{}`                                                      |

The above parameters map to the env variables defined in [postput/api](https://github.com/postput/api/)

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set replicaCount=2,nameOverride=my-postput \
    incubator/postput
```


> **Tip**: You can use the default [values.yaml](values.yaml)

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
1. Note that the `image.pullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

```yaml
image:
  pullSecrets:
    - name: SECRET_NAME
```