# Kapacitor

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

The following tables lists the configurable parameters of the Kapacitor chart and 
the meaning of the field. The default values are listed in `values.yaml`.

```yaml
image.repository: Docker image repo to use
image.tag: Docker image tag to use
image.pullPolicy: Image pull policy (IfNotPresent, Always)
service.type: Type of service (NodePort, LoadBalancer)
persistence.enabled: Set to true to enable automatic provisioning of a persistent disk
persistence.storageClass: Sorage class for the persistent disk
persistence.accessMode: Access mode for the persistent disk
persistence.size: Size of the persistent disk in Gi or Mi
resources.requests.memory: Min amount of memory the pod requires
resources.requests.cpu: Min amount of cpu required by the pod
resources.limits.memory: Max amount of memory the pod requires
resources.limits.cpu: Max amount of cpu required by the pod

# This is the location where kapacitor will look for an Influxdb
# instance to create a subscription on.
influxURL: An InfluxDB url with port. 
```

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

The chart optionally mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.