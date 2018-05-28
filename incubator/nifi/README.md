# NiFi

[NiFi](https://nifi.apache.org/) is an easy to use, powerful, and reliable system to process and distribute data.

## Introduction

Chart bootstraps NiFi and it's associated dependency ZooKeeper into a Kubernetes cluster.

__NOTE:__ Operators will typically wish to install this component into the `NiFi` namespace

## Prerequisites

- Kubernetes 1.6+ if you want to enable RBAC

## Installing the Chart

To install the chart with the release name `nifi`:

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name nifi --namespace nifi incubator/nifi
```

If you do not specify a name, helm will select a name for you.

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete --purge nifi
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Traefik chart and their default values.

| Parameter                       | Description                                                          | Default                                   |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------------------------- |
| `nifi.image.repository`         | NiFi image name                                                      | `apache/nifi`                             |
| `nifi.image.tag`                | The version of the official Traefik image to use                     | `1.6.0`                                   |
| `nifi.image.pullPolicy`         | The image pull policy                                                | `Always`                                  |
| `nifi.replicas`                 | The number of replicas to be assigned                                | `1`                                       |
| `ingress.domain`                | The domain name                                                      | `nifi.example.com`                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For example on a local install:

```bash
$ helm install --name nifi --namespace nifi \
  --set serviceType=NodePort
```
