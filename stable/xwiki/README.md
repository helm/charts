# Helm XWiki chart

Installs XWiki on a kubernetes cluster using the [`xwiki`](https://hub.docker.com/_/xwiki) image from `hub.docker.com` by default.

## Requirements

- Postgres only, and you have to take care by yourself that it exists and is configured according to the values you set for this chart.

## Limitations

- Using persistence you can't change the `db.*` parameters. This is a limitation of the underlying container which does not change the configuration file once written.
- Using more than one Pod is currently not supported, so load-balancing between Xwiki instances is not possible.

## Parameters

| Parameter                   | Description                                          | Default                 |
| --------------------------- | ---------------------------------------------------- | ----------------------- |
| `affinity`                  | Define a Pod [`affinity`](https://is.gd/AtiuUg)      |  `{}`                   |
| `db.database`               | The database name                                    | `xwiki`                 |
| `db.host`                   | The database host                                    | `localhost`             |
| `db.pass`                   | The database password                                | `xwiki`                 |
| `db.user`                   | The database user name                               | `xwiki`                 |
| `image.pullPolicy`          | container image [`pullPolicy`](https://is.gd/5tfCPv) | `Always`                |
| `image.repository`          | container image repository                           | `xwiki`                 |
| `image.tag`                 | container image tag                                  | `10.11-postgres-tomcat` |
| `ingress.enabled`           | Enable ingress                                       | `false`                 |
| `ingress.annotations`       | Define ingress annotations                           | `{}`                    |
| `ingress.hosts`             | Define ingress hosts                                 | `[chart-example.local]` |
| `ingress.path`              | Set ingress path                                     | `/`                     |
| `ingress.tls`               | Define ingress [TLS fields](https://is.gd/SkhKxV)    | `[]`                    |
| `livenessProbe`             | Define a [liveness probe](https://is.gd/z0lJO3)      | unset                   |
| `nodeSelector`              | Define a Pod [`nodeSelector`](https://is.gd/AtiuUg)  |  `{}`                   |
| `persistence.enabled`       | Enable persistence using PVC                         | `false`                 |
| `persistence.accessModes`   | PVC Access Modes for PostgreSQL volume               | `[ReadWriteOnce]`       |
| `persistence.existingClaim` | Provide an existing `PersistentVolumeClaim`          | `false`                 |
| `persistence.size`          | PVC Storage Request for PostgreSQL volume            | `1Gi`                   |
| `persistence.storageClass`  | PVC Storage Class for PostgreSQL volume              | `false`                 |
| `readinessProbe`            | Define a [readiness probe](https://is.gd/z0lJO3)     | unset                   |
| `resources`                 | Define Pod [`resources`](https://is.gd/pZtMlt)       |  `{}`                   |
| `service.type`              | Define the service type                              |  `ClusterIP`            |
| `service.port`              | Define the service port                              |  `80`                   |
| `tolerations`               | Define Pod [`tolerations`](https://is.gd/XaLbxF)     |  `[]`                   |
