# Kylo

[Kylo](https://nifi.apache.org/) is a data lake management software platform and framework for enabling scalable enterprise-class data lakes on Apache Hadoop and Spark.

## Introduction

Chart bootstraps Kylo and it's associated dependencies into a Kubernetes cluster.

Dependencies include:

* ActiveMQ
* ElasticSearch
* NiFi
* Kylo Services
* Kylo UI
* ZooKeeper

__NOTE:__ Operators will typically wish to install this component into the `Kylo` namespace

## Prerequisites

- Kubernetes 1.6+ if you want to enable RBAC

## Installing the Chart

To install the chart with the release name `kylo`:

```bash
$ helm repo add govcloud https://govcloud.github.io/charts
$ helm install govcloud/kylo --name kylo --namespace kylo
```

If you do not specify a name, helm will select a name for you.

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete --purge kylo
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Traefik chart and their default values.

| Parameter                       | Description                                                          | Default                                   |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------------------------- |
| `kylo.image.repository`         | Kylo image name                                                      | `govcloud/docker-kylo`                    |
| `kylo.image.tag`                | The version of the official Traefik image to use                     | `ui`                                      |
| `kylo.image.pullPolicy`         | The image pull policy                                                | `Always`                                  |
| `replicas`                      | The number of replicas to be assigned                                | `1`                                       |
| `kylo.ingress.domain`           | The domain name                                                      | `kylo.k8s.cloud.statcan.ca`               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For example the following is how to install Kylo locally:

```bash
helm install --name kylo \
             --namespace kylo \
             --set serviceType=NodePort \
             --set ingress.enabled=false \
             -f values.yaml .
```
