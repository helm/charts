# kube-registry-proxy Helm Chart

* Installs the [kube-registry-proxy cluster addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/registry).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/kube-registry-proxy
```

## Configuration

| Parameter          | Description                                | Default                                      |
|--------------------|--------------------------------------------|----------------------------------------------|
| `image.repository` | The image repository to pull from          | k8s.gcr.io/kube-registry-proxy               |
| `image.tag`        | The image tag to pull from                 | 0.4                                          |
| `image.pullPolicy` | Image pull policy                          | IfNotPresent                                 |
| `registry.host`    | The hostname of the target registry        | "gcr.io"                                     |
| `registry.port`    | The port of the target registry            | \<blank>                                     |
| `hostPort`         | The port to accept connections on the node | 5555                                         |
| `hostIP`           | The interface address to bind on the node  | 127.0.0.1                                    |
