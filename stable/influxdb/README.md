# InfluxDB

##  An Open-Source Time Series Database

[InfluxDB](https://github.com/influxdata/influxdb) is an open source time series database built by the folks over at [InfluxData](https://influxdata.com) with no external dependencies. It's useful for recording metrics, events, and performing analytics.

## QuickStart

```bash
$ helm install stable/influxdb --name foo --namespace bar
```

## Introduction

This chart bootstraps an InfluxDB deployment and service on a Kubernetes cluster using the Helm Package manager.

## Prerequisites

- Kubernetes 1.4+
- PV provisioner support in the underlying infrastructure (optional)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/influxdb
```

The command deploys InfluxDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the InfluxDB chart and 
their default values.

```yaml
image.repo: Docker image repo
image.tag: Docker image tag
image.pullPolicy: Kubernetes image pull policy
service.type: InfluxDB service type
persistence.enabled: Toggle persistent storage, uses PVC
persistence.storageClass: Storage class for persistent volume
persistence.accessMode: Access mode for persistent storage
persistence.size: Disk size for InfluxDB storage in Gi
resources.requests.memory: Min memory required for this deployment
resources.requests.cpu: Min cpu required for this deployment
resources.limits.memory: Max memory required for this deployment
resources.limits.cpu: Max cpu required for this deployment
# The configuration paramaters come from the InfluxDB configuration file
# ref: https://docs.influxdata.com/influxdb/v1.1/administration/config/
config.{value}
config.{section}.{value}

## For example to change the default API port you would set:
## config.http.bind_address: 8087
```

The [full image documentation](https://hub.docker.com/_/influxdb/) contains more information about running InfluxDB in docker.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.enabled=true,persistence.size=200Gi \
    stable/influxdb
```

The above command enables persistence and changes the size of the requested data volume to 200GB.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/influxdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [InfluxDB](https://hub.docker.com/_/influxdb/) image stores data in the `/var/lib/influxdb` directory in the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
