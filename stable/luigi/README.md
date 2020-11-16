# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# ⚠️ Chart Deprecated

# Luigi Scheduler

[Luigi](https://github.com/spotify/luigi) is a Python module that helps you build complex pipelines of batch jobs. It handles dependency resolution, workflow management, visualization etc. It also comes with Hadoop support built in.

## TL;DR;

```console
$ helm install incubator/luigi
```

## Introduction

This chart bootstraps a [Luigi](https://github.com/spotify/luigi) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/luigi
```
## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Luigi Configuration

[Luigi](https://github.com/spotify/luigi) configs are set as a block of text through a configmap and mouted as a file in /etc/luigi. Any value in this text block should match the defined luigi configuration. There are several values here that will have to match our kubernetes configuration.

## Configuration

The following table lists the configurable parameters of the Luigi chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `image.repository`                   | Luigi image                                | `getpolymorph/luigi`                                       |
| `image.tag`                          | Luigi image tag                            | `2.7.2`                                                    |
| `image.pullPolicy`                   | Luigi image pull policy                    | `IfNotPresent`                                                   |
| `service.name`                       | Luigi service name                         | `luigi`                                                    |
| `service.type`                       | The kube service type                      | `LoadBalancer`                                             |
| `service.externalPort`               | The service external port                  | `3000`                                                     |
| `service.internalPort`               | The service internal port                  | `8082`                                                     |
| `service.config`                     | The luigi service configs                  | View this default in the values.yaml file                  |
| `persistence.enabled`                | Persistence flag                           | `false`                                                    |
| `ingressUI.enabled`                  | UI Ingress Flag                            | `false`                                                    |
| `ingressAPI.enabled`                 | API Ingress Flag                           | `false`                                                    |

Dependent charts can also have values overwritten. Preface values with postgresql.* or redis.*

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set persistence.enabled=false,email.host=email \
    stable/luigi
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/luigi
```

Read through the [values.yaml](values.yaml) file. It has several commented out suggested values.

## Persistence

Luigi requires a pickled state file. To maintain state after a restart you'll need to enable persistence.
`--set persistence.enabled=true`

## Ingress

This chart provides support for two Ingress resources. This is to allow authentication in the ui via reverse proxy with something like oauth-proxy and a separate form of authentication for luigi worker access.
