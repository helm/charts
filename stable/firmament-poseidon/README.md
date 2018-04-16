# firmament-poseidon

The Firmament/Poseidon scheduler incubation project is to bring integration of Firmament Scheduler [OSDI paper](https://www.usenix.org/conference/osdi16/technical-sessions/presentation/gog) in Kubernetes.

## TL;DR;

```console
$ helm install stable/firmament-poseidon
```

## Introduction

This chart bootstraps the poseidon and firmament deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/firmament-poseidon --name my-release
```
The command deploys firmament and poseidon on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Access control
It is critical for the Kubernetes custer to correctly setup access control of poseidon.

It is highly recommended to use RBAC with minimal privileges needed for poseidon to run.  

## Configuration

The following table lists the configurable parameters of the poseidon-firmament chart and their default values.

| Parameter                           | Description                                                                                                                 | Default                                                                  |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `poseidon.repository`               | Repository for poseoidon container image                                                                                    | `gcr.io/poseidon-173606/poseidon`                                        |
| `poseidon.tag`                      | Image tag                                                                                                                   | `latest`                                                                 |
| `poseidon.pullPolicy`               | Image pull policy                                                                                                           | `IfNotPresent`                                                           |
| `poseidon.extraContainerArgs`       | Additional container arguments                                                                                              | `poseidon`                                                               |
| `firmament.repository`              | Repository for firmament container image                                                                                    | `huaweifirmament/firmament`                                              |
| `firmament.tag`                     | Image tag                                                                                                                   | `latest`                                                                 |
| `firmament.pullPolicy`              | Image pull policy                                                                                                           | `IfNotPresent`                                                           |
| `firmament.extraContainerArgs`      | Additional container arguments                                                                                              | `firmament-scheduler`                                                    |
| `service.port`                      | Service port to expose                                                                                                      | `80`                                                                     |
| `service.type`                      | Type of service to create                                                                                                   | `ClusterIP`                                                              |
| `rbac.create`                       | Create & use RBAC resources                                                                                                 | `true`                                                                   |
| `serviceAccount.create`             | Whether a new service account name that the agent will use should be created.                                               | `true`                                                                   |
| `serviceAccount.name`               | Service account to be used. If not set and serviceAccount.create is `true` a name is generated using the fullname template. | `poseidon`                                                               |

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/firmament-poseidon --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
