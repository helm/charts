## Volcano

Volcano is a batch system built on Kubernetes. It provides a suite of mechanisms currently missing from
Kubernetes that are commonly required by many classes of batch & elastic workload including:

1. machine learning/deep learning,
2. bioinformatics/genomics, and 
3. other "big data" applications.

## Introduction

This chart bootstraps [volcano](https://github.com/volcano-sh/volcano) components like controller, scheduler and admission controller deployments using [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.13+ with CRD support

## Installing Chart

To install the chart with the release name `volcano-release`:

```bash
$ helm install --name volcano-release incubator/volcano
```

This command deploys volcano in kubernetes cluster with default configuration.  The [configuration](#configuration) section lists the parameters that can be configured during installation.


## Uninstalling the Chart

```bash
$ helm delete volcano-release --purge
```

## Configuration

The following are the list configurable parameters of Volcano Chart and their default values.

| Parameter|Description|Default Value|
|----------------|-----------------|----------------------|
|`basic.image_tag_version`| Docker image version Tag | `default`|
|`basic.controller_image_name`|Controller Docker Image Name|`volcanosh/vk-controllers`|
|`basic.scheduler_image_name`|Scheduler Docker Image Name|`volcanosh/vk-kube-batch`|
|`basic.admission_image_name`|Admission Controller Image Name|`volcanosh/vk-admission`|
|`basic.admission_secret_name`|Volcano Admission Secret Name|`volcano-admission-secret`|
|`basic.scheduler_config_file`|Configuration File name for Scheduler|`kube-batch.conf`|
|`basic.image_pull_secret`|Image Pull Secret|`""`|
|`basic.image_pull_policy`|Image Pull Policy|`IfNotPresent`|
|`basic.admission_app_name`|Admission Controller App Name|`volcano-admission`|
|`basic.controller_app_name`|Controller App Name|`volcano-controller`|
|`basic.scheduler_app_name`|Scheduler App Name|`volcano-scheduler`|

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name volcano-release --set basic.image_pull_policy=Always incubator/volcano
```

The above command set image pull policy to `Always`, so docker image will be pulled each time.


Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name volcano-release -f values.yaml incubator/volcano
```

> **Tip**: You can use the default [values.yaml](values.yaml)