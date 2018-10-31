# COSBench Helm Chart

[COSBench](https://github.com/intel-cloud/cosbench), is a benchmark tool for cloud object storage services. It is compatible with OpenStack Swift, Amazon S3, Scality Zenko, Ceph, CDMI, Google Cloud Storage, and other services.

## TL;DR;

```console
$ helm install stable/cosbench
```

## Introduction

This chart bootstraps a [COSBench](https://github.com/intel-cloud/cosbench) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/cosbench
```

The command above deploys COSBench on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the COSBench chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`serviceAccounts.controller.create` | If true, create the controller service account | `true`
`serviceAccounts.controller.name` | name of the controller service account to use or create | `{{ cosbench.controller.fullname }}`
`serviceAccounts.driver.create` | If true, create the driver service account | `true`
`serviceAccounts.driver.name` | name of the driver service account to use or create | `{{ cosbench.driver.fullname }}`
`controller.image.repository` | controller image repository | `zenko/zenko-cosbench`
`controller.image.tag` | controller image tag | `0.0.6`
`controller.image.pullPolicy` | controller image pullPolicy | `IfNotPresent`
`controller.service.type` | controller service type | `ClusterIP`
`controller.service.port` | controller service port | `19088`
`controller.ingress.enabled` | If true, controller ingress will be created | `false`
`controller.ingress.annotations` | controller ingress annotations | `{}`
`controller.ingress.hosts` | controller ingress hostnames | `[]`
`controller.ingress.tls` | controller ingress TLS configuration | `[]`
`controller.logLevel` | controller log level | `DEBUG`
`driver.replicaCount` | number of driver replicas | `3`
`driver.image.repository` | driver image repository | `zenko/zenko-cosbench`
`driver.image.tag` | driver image tag | `0.0.6`
`driver.image.pullPolicy` | driver image pullPolicy | `IfNotPresent`
`driver.service.type` | driver service type | `ClusterIP`
`driver.service.port` | driver service port | `18088`
`driver.logLevel` | driver log level | `DEBUG`
`driver.antiAffinity` | driver antiAffinity type | `soft`
`driver.hostAliases` | driver aliases for IPs in /etc/hosts | `[]`
`driver.resources.requests` | driver resource requests | Memory: `2Gi`, CPU: `500m`
`driver.resources.limits` | driver resource limits | Memory: `4Gi`, CPU: `1`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/cosbench --name my-release \
    --set driver.replicaCount=5
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/cosbench --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
