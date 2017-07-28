# Eventrouter: A simple event router for Kubernetes

Built by the [Heptio](https://www.heptio.com/) team.

This Chart installs a Kubernetes [Eventrouter](https://github.com/heptio/eventrouter)]. The event router serves as an active watcher of _event_ resource in the kubernetes system, which takes those events and _pushes_ them to a user specified _sink_.  This is useful for a number of different purposes, but most notably long term behavioral analysis of your workloads running on your kubernetes cluster. 

This chart installs the Eventrouter according to the following
pattern:

- A `ConfigMap` is used to store the _sink_ the router will send events to.
  ([templates/configmap.yaml](templates/configmap.yaml))
- A `Deployment` is used to create a Replica Set of EventRouter pods.
  ([templates/deployment.yaml](templates/deployment.yaml))

The [values.yaml](values.yaml) exposes the available configuration options in the
chart.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/eventrouter
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following tables lists some of the configurable parameters of the Eventrouter
chart and their default values.

| Parameter                        | Description                                                  | Default                                                    |
| -----------------------          | ----------------------------------                           | ---------------------------------------------------------- |
| `image`                          | Eventrouter image                                            | `gcr.io/heptio-images/eventrouter`                         |
| `imageTag`                       | Eventrouter image version                                    | `v0.1`                                                     |
| `sink`                           | Sink Eventrouter will use                                    | `stdout`                                                   |
| `namespace`                      | Namespace to install release into                            | `kube-system`