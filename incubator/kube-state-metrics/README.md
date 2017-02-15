# kube-state-metrics Helm Chart

* Installs the [kube-state-metrics agent](https://github.com/kubernetes/kube-state-metrics).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/kube-state-metrics
```

## Configuration

| Parameter          | Description                         | Default                                      |
|--------------------|-------------------------------------|----------------------------------------------|
| `image.repository` | The image repository to pull from   | gcr.io/google_containers/kube-state-metrics  |
| `image.tag`        | The image tag to pull from          | v0.4.1                                       |
| `image.pullPolicy` | Image pull policy                   | IfNotPresent                                 |
| `service.name`     | Name of the service                 | kube-state-metrics                           |
| `service.port`     | The port of the container           | 8080                                         |
| `prometheusScrape` | Whether or not enable prom scrape   | True                                         |
