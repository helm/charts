# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Hoverfly

[Hoverfly](https://hoverfly.io/) is a lightweight, open source API simulation tool. Using Hoverfly, you can create realistic simulations of the APIs your application depends on.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install incubator/hoverfly
```

## Introduction

This chart bootstraps a [Hoverfly](https://hoverfly.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/hoverfly
```

The command deploys Hoverfly on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hoverfly chart and their default values.

| Parameter                         | Description                                | Default                                                   |
| --------------------------------- | ------------------------------------------ | --------------------------------------------------------- |
| `image.repository`                | Hoverfly Image name                        | `docker.io/spectolabs/hoverfly`                           |
| `image.tag`                       | Hoverfly Image tag                         | `v1.1.1`                                             |
| `hoverflyFlags`                   | Flags to start Hoverfly with, eg. '-auth'  | `""`                                                      |
| `healthcheckEndpoint`             | Admin API path for Kubernetes healthcheck  | `/api/health`                                             |
| `service.type`                    | Kubernetes Service type                    | `ClusterIP`                                               |
| `service.adminPort`               | Container Admin port                       | `8888`                                                    |
| `service.proxyPort`               | Container Proxy port                       | `8500`                                                    |
| `service.externalAdminPort`       | Service Admin port                         | `8888`                                                    |
| `service.externalProxyPort`       | Service Proxy port                         | `8500`                                                    |
| `resources`                       | CPU/Memory resource requests/limits        | Memory: `200Mi`, CPU: `0.2`                               |
| `openshift.route.admin.enabled`   | Create an Openshift route for the Hoverfly Admin Interface | `false` |
| `openshift.route.admin.hostname`  | Specify the route URL for the Hoverfly Admin Interface     | `""` |
| `openshift.route.proxy.enabled`   | Create an Openshift route for the Hoverfly Proxy Endpoint  | `false` |
| `openshift.route.proxy.hostname`  | Specify the route URL for the Hoverfly Proxy Interface     | `""` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set hoverflyFlags='-webserver -journal-size 0' \
    incubator/hoverfly
```

The above command starts Hoverfly in webserver mode and disable journal. You can find all the available flags [here](https://hoverfly.readthedocs.io/en/latest/pages/reference/hoverfly/hoverflycommands.html)

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/hoverfly
```

> **Tip**: You can use the default [values.yaml](values.yaml)
