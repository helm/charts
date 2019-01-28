# stable/envoy

[Envoy](https://www.envoyproxy.io/) is an open source edge and service proxy, designed for cloud-native applications.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/envoy --name my-release
```

The command deploys envoy on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the envoy chart and their default values.

Parameter | Description | Default
--- | --- | ---
`files.envoy\.yaml` | content of a full envoy configuration file as documented in https://www.envoyproxy.io/docs/envoy/latest/configuration/configuration | See [values.yaml](values.yaml)
`templates.envoy\.yaml` | golang template of a full configuration file. Use the `{{ .Values.foo.bar }}` syntax to embed chart values | See [values.yaml](values.yaml)

All other user-configurable settings, default values and some commentary about them can be found in [values.yaml](values.yaml).
