# Chaoskube Helm Chart

[chaoskube](https://github.com/linki/chaoskube) periodically kills random pods in your Kubernetes cluster.

## TL;DR;

```console
$ helm install incubator/chaoskube
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/chaoskube
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                 | Description                                         | Default                           |
|---------------------------|-----------------------------------------------------|-----------------------------------|
| `name`                    | container name                                      | chaoskube                         |
| `image`                   | docker image                                        | quay.io/linki/chaoskube           |
| `imageTag`                | docker image tag                                    | v0.3.1                            |
| `replicas`                | number of replicas to run                           | 1                                 |
| `interval`                | interval between pod terminations                   | 10m                               |
| `dryRun`                  | defines whether pods should actually be terminated  | false                             |
| `resources.cpu`           | cpu resource requests and limits                    | 10m                               |
| `resources.memory`        | memory resource requests and limits                 | 16Mi                              |
