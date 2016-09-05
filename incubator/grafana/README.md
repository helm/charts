# Grafana Helm Chart

* Installs the web dashboarding system [Grafana](http://grafana.org/)

## Configuration

| Parameter                  | Description                                       | Default                  |
|----------------------------|---------------------------------------------------|--------------------------|
| `imageName`                | Container image to run                            | grafana/grafana          |
| `adminUser`                | Admin user username                               | admin                    |
| `adminPassword`            | Admin user password                               | admin                    |
| `persistence.enabled`      | Create a volume to store data                     | true                     |
| `persistence.size`         | Size of persistent volume claim                   | 1Gi RW                   |
| `persistence.storageClass` | Type of persistent volume claim                   | generic                  |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly                         | ReadWriteOnce            |
