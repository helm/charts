# kube-state-metrics Helm Chart

* Installs the [kube-state-metrics agent](https://github.com/kubernetes/kube-state-metrics).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/kube-state-metrics
```

## Configuration

| Parameter                 | Description                                             | Default                                     |
|---------------------------|---------------------------------------------------------|---------------------------------------------|
| `image.repository`        | The image repository to pull from                       | gcr.io/google_containers/kube-state-metrics |
| `image.tag`               | The image tag to pull from                              | v1.0.1                                      |
| `image.pullPolicy`        | Image pull policy                                       | IfNotPresent                                |
| `service.port`            | The port of the container                               | 8080                                        |
| `prometheusScrape`        | Whether or not enable prom scrape                       | True                                        |
| `rbac.create`             | If true, create & use RBAC resources                    | False                                       |
| `rbac.serviceAccountName` | ServiceAccount to be used (ignored if rbac.create=true) | default                                     |
