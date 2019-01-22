# BaGet Helm Chart

[BaGet](https://loic-sharma.github.io/BaGet/) is a NuGet server built with ASP.Net Core and supporting Docker.

## TL;DR;

```console
$ helm install incubator/baget
```

## Introduction

This chart creates a BaGet instance on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites Details

* Kubernetes 1.6 (for `pod affinity` support)
* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/baget
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

### Cleanup orphaned Persistent Volumes

This chart uses `StatefulSets` for Concourse Workers. Deleting a `StatefulSet` will not delete associated Persistent Volumes.

Do the following after deleting the chart release to clean up orphaned Persistent Volumes.

```console
$ kubectl delete pvc -l app=${RELEASE-NAME}-worker
```

## Configuration

The following table lists the configurable parameters of the Concourse chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `image.repository` | BaGet Docker image repository | `bnmcg/baget` |
| `image.tag` | BaGet version | `v0.1.32-prerelease` |
| `image.pullPolicy` | image pull policy | `IfNotPresent` |
| `service.type` | Kubenetes service type | `ClusterIP` |
| `service.port` | Kubenetes service port | `80` |
| `persistence.enabled` | Persist cached and uploaded packages | `true` |
| `persistence.accessMode` | PV access mode | `ReadWriteOnce` |
| `persistence.size` | Amount of size to allocate to persistent storage | `1Gi` |
| `persistence.storageClass` | Kubernetes StorageClass to provision | `` |
| `apiKey` | API key that will be required for pushing packages. Leave blank to enable anonymous pushes | `` |
| `database.type` | Type of database to connect to. Only Sqlite supported | `Sqlite` |
| `database.connectionString` | Database connection string | `Data Source=/var/baget/baget.db` |
| `storage.type` | How to store persistent files. Only FileSystem supported | `FileSystem` |
| `storage.path` | Where to store persistent files. A 'packages' subdirectory is created here | `/var/baget` |
| `search.type` | Search type. Only Database supported | `Database` |
| `mirror.enabled` | Whether to cache upstream packages | `false` |
| `mirror.packageSource` | Where to request upstream packages from | `https://api.nuget.org/v3/index.json` |
| `ingress.enabled` | Whether to enable a Kubernetes ingress | `false` |
| `ingress.annotations` | Annotations to attach to the ingress | `{}` |
| `ingress.path` | Ingress URL path | `/` |
| `ingress.tls` | Ingress TLS configuration | `[]]` |
| `resources` | Resource allocations | `{}` |
| `nodeSelector` | Kubernetes node selector | `{}` |
| `tolerations` | Kubernetes scheduling tolerations | `[]` |
| `affinity` | Kubernetes scheduling affinity | `false` |

Any BaGet specific parameters are taken directly from [AppSettings.json](https://github.com/loic-sharma/BaGet/blob/master/src/BaGet/appsettings.json). You should refer to the [BaGet configuration documentation](https://loic-sharma.github.io/BaGet/configuration/) for more detail.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/baget
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Persistence

This chart mounts a Persistent Volume for storing uploaded and mirrored packages, as well as the BaGet SQLite database. The volume is created using dynamic volume provisioning.

```yaml
## Persistent Volume Storage configuration.
## ref: https://kubernetes.io/docs/user-guide/persistent-volumes
##
persistence:
  ## Enable persistence using Persistent Volume Claims.
  ##
  enabled: true

  ## Worker Persistence configuration.
  ##
  worker:
    ## Persistent Volume Storage Class.
    ##
    class: generic

    ## Persistent Volume Access Mode.
    ##
    accessMode: ReadWriteOnce

    ## Persistent Volume Storage Size.
    ##
    size: "20Gi"
```