# Domoticz Helm Chart

* Installs [Domoticz](https://www.domoticz.com), a Home Automation System.

## TL;DR;

```console
$ helm install incubator/domoticz
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/domoticz
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `server.image`                        | Container image to run              | zeiot/rpi-domoticz:3.5877                         |
| `server.resources`                    | Server resource requests and limits | requests: {cpu: 100m, memory: 100Mi}              |
