# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# kube-registry-proxy Helm Chart

* Installs the [kube-registry-proxy cluster addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/registry).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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
