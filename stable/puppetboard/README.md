# puppetboard

[Puppetboard](https://github.com/voxpupuli/puppetboard) is a web interface to
[PuppetDB](https://puppet.com/docs/puppetdb/), the latter of which is used in
larger Puppet deployments to hold information about the nodes being managed by
Puppet. Puppetboard is a friendly web front-end to much of the information
available in PuppetDB.

## Prerequisites

- Kubernetes 1.7+
- PuppetDB 3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/puppetboard
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the puppetboard chart
and their default values.

| Parameter                     | Description                                                       | Default               |
| ---------                     | -----------                                                       | -------               |
| `image.repository`            | Image repository                                                  | `bootc/puppetboard`   |
| `image.tag`                   | Image tag                                                         | `0.3.0`               |
| `image.pullPolicy`            | Image pull policy                                                 | `IfNotPresent`        |
| `replicaCount`                | Number of puppetboard replicas                                    | `1`                   |
| `nameOverride`                | Override the name of the chart                                    |                       |
| `fullnameOverride`            | Override the fullname of the chart                                |                       |
| `puppetDbHost`                | PuppetDB host                                                     | `puppetdb`            |
| `puppetDbPort`                | PuppetDB port number                                              | `8080`                |
| `secrets.clientTlsSecret`     | Kubernetes secret containing PuppetDB client certificate          |                       |
| `secrets.caCertsSecret`       | Kubernetes secret containing CA certificates for PuppetDB         |                       |
| `secrets.secretKey`           | Secret key used by Flask for session cookie integrity validation  |                       |
| `extraEnv`                    | Extra environment variables to pass to Puppetboard                |                       |
| `service.type`                | Kubernetes service type                                           | `ClusterIP`           |
| `service.port`                | TCP port number exposed by the service                            | `80`                  |
| `ingress.enabled`             | Enable ingress controller resource                                | `false`               |
| `ingress.annotations`         | Annotations for this ingress record                               | `{}`                  |
| `ingress.path`                | Path within the url structure                                     | `/`                   |
| `ingress.hosts[0]`            | Hostname for Puppetboard                                          | `puppetboard.local`   |
| `ingress.tls`                 | Ingress TLS configuraton (see below)                              | `[]`                  |
| `ingress.tls[0].secretName`   | Ingress TLS secret name                                           |                       |
| `ingress.tls[0].hosts[0]`     | Ingress TLS Virtual hosts to multiplex using SNI                  |                       |
| `resources`                   | CPU/memory resource requests/limits                               |                       |
| `nodeSelector`                | Node labels for pod assignment                                    | `{}`                  |
| `tolerations`                 | Node tolerations for pod assignment                               | `[]`                  |
| `affinity`                    | Affinity settings for pod assignment                              | `{}`                  |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/puppetboard
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Contributing

This chart is maintained at [github.com/helm/charts](https://github.com/helm/charts).
