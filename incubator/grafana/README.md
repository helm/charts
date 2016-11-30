# Grafana Helm Chart

* Installs the web dashboarding system [Grafana](http://grafana.org/)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/grafana
```

## Configuration

| Parameter                    | Description                                         | Default                                             |
| ---------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| `imageName`                  | Container image to run                              | grafana/grafana                                     |
| `adminUser`                  | Admin user username                                 | admin                                               |
| `adminPassword`              | Admin user password                                 | admin                                               |
| `persistence.enabled`        | Create a volume to store data                       | true                                                |
| `persistence.size`           | Size of persistent volume claim                     | 1Gi RW                                              |
| `persistence.storageClass`   | Type of persistent volume claim                     | `volume.alpha.kubernetes.io/storage-class: default` |
| `persistence.accessMode`     | ReadWriteOnce or ReadOnly                           | ReadWriteOnce                                       |
| `cpu`                        | Container requested cpu                             | 100m                                                |
| `memory`                     | Container requested memory                          | 100M                                                |
