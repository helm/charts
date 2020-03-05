# DEPRECATED - Kapacitor

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/influxdata/helm-charts
- **Charts repo:** https://helm.influxdata.com/

##  An Open-Source Time Series ETL and Alerting Engine

[Kapacitor](https://github.com/influxdata/kapacitor) is an open-source framework built by the folks over at [InfluxData](https://influxdata.com) and written in Go for processing, monitoring, and alerting on time series data

## QuickStart

```bash
$ helm install stable/kapacitor --name foo --namespace bar
```

## Introduction

This chart bootstraps A Kapacitor deployment and service on a Kubernetes cluster using the Helm Package manager.

## Prerequisites

- Kubernetes 1.4+
- PV provisioner support in the underlying infrastructure (optional)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/kapacitor
```

The command deploys Kapacitor on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Kapacitor chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `image.repository` | Kapacitor image | `kapacitor` |
| `image.tag` | Kapacitor image version | `1.5.2-alpine` |
| `image.pullPolicy` | Kapacitor image pull policy |  `IfNotPresent` |
| `service.type` | Kapacitor web service type  | `ClusterIP` |
| `persistence.enabled` | Enable Kapacitor persistence using Persistent Volume Claims | `false` |
| `persistence.storageClass` | Kapacitor Persistent Volume Storage Class | `default` |
| `persistence.accessMode` | Kapacitor Persistent Volume Access Mode | `ReadWriteOnce` |
| `persistence.size` | Kapacitor Persistent Volume Storage Size | `8Gi` |
| `persistence.existingClaim` | Kapacitor existing PVC name | `nil` |
| `resources.request.memory` | Kapacitor memory request | `256Mi` |
| `resources.request.cpu` | Kapacitor cpu request | `0.1` |
| `resources.limits.memory` | Kapacitor memory limit | `2Gi` |
| `resources.limits.cpu` | Kapacitor cpu limit | `2` |
| `envVars` | Environment variables to set initial Kapacitor configuration (https://hub.docker.com/_/kapacitor/) | `{}` |
| `influxURL` | InfluxDB url used to interact with Kapacitor (also can be set with ```envVars.KAPACITOR_INFLUXDB_0_URLS_0```) | `http://influxdb-influxdb.tick:8086` |
| `existingSecret` | Name of an existing Secrect used to set the environment variables for the InfluxDB user and password. The expected keys in the secret are `influxdb-user` and `influxdb-password`. |

The configurable parameters of the Kapacitor chart and the default values are listed in `values.yaml`.

The [full image documentation](https://hub.docker.com/_/kapacitor/) contains more information about running Kapacitor in docker.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set influxURL=http://myinflux.mytld:8086,persistence.enabled=true \
    stable/kapacitor
```

The above command enables persistence and changes the size of the requested data volume to 200GB.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/kapacitor
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Kapacitor](https://hub.docker.com/_/kapacitor/) image stores data in the `/var/lib/kapacitor` directory in the container.

The chart optionally mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.
