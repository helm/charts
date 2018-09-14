# Fluentd Splunk HEC

This chart installs a [Fluentd](https://www.fluentd.org/) daemonset containing the [Splunk HEC plugin](https://github.com/fluent/fluent-plugin-splunk). This is for sending logs to a [Splunk HTTP events collector](http://docs.splunk.com/Documentation/Splunk/latest/Data/AboutHEC). It is meant to be a drop in replacement for for the default logging daemonset on a cluster, e.g. for fluentd-gcp on GKE.

## TL;DR;

```console
$ helm install stable/fluentd-splunk-hec
```

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release` and default configuration:

```console
$ helm install --name my-release stable/fluentd-splunk-hec
```

You will likely want to set at least set `splunk_hec.host` and `splunk_hec.token`:

```console
helm install --name my-release stable/fluentd-splunk-hec --set splunk_hec.host=my-splunk-endpoint.my-domain.com --set splunk_hec.token=abcdefg-1234-1234-abcd-abcdefg
```

## Uninstalling the Chart

To delete the chart:

```console
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the Fluentd splunk-hec chart and their default values.

| Parameter                          | Description                                        | Default                               |
| ---------------------------------- | -------------------------------------------------- | --------------------------------------|
| `annotations`                      | Optional daemonset annotations                     | `NULL`                                |
| `ssl_cert_bundle_path`             | Path to SSL certificates bundle on the node        | `/etc/ssl/certs/ca-bundle.crt`        |
| `fluentd_settings.uid`             | UID that fluentd will use                          | `0`                                   |
| `fluentd_settings.args`            | Arguments for fluentd                              | `--no-supervisor -q`                  |
| `splunk_hec.host`                  | Your Splunk HEC endpoint host                      | `hec.example.com`                     |
| `splunk_hec.port`                  | Your Splunk HEC endpoint port                      | `8088`                                |
| `splunk_hec.token`                 | Your Splunk HEC token                              | `change_me`                           |
| `splunk_hec.use_ssl`               | Whether to use SSL                                 | `true`                                |
| `splunk_hec.ssl_verify`            | Whether to verify the SSL cert of the HEC endpoint | `true`                                |
| `splunk_hec.source_name`           | Splunk source name                                 | `fluentd-splunk-hec`                  |
| `splunk_hec.source_type`           | Splunk source type                                 | `fluentd-splunk-hec`                  |
| `image.repository`                 | Image                                              | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag`                        | Image tag                                          | `v0.12.43-splunkhec`                  |
| `image.pullPolicy`                 | Image pull policy                                  | `IfNotPresent`                        |
| `rbac.create`                      | RBAC                                               | `true`                                |
| `resources.limits.cpu`             | CPU limit                                          | `100m`                                |
| `resources.limits.memory`          | Memory limit                                       | `500Mi`                               |
| `resources.requests.cpu`           | CPU request                                        | `100m`                                |
| `resources.requests.memory`        | Memory request                                     | `200Mi`                               |
| `livenessProbe.enabled`            | Whether to enable livenessProbe                    | `true`                                |   
| `tolerations`                      | Optional daemonset tolerations                     | `NULL`                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters:

```console
$ helm install --name my-release stable/fluentd-splunk-hec --values values.yaml
```
