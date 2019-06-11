# Step Certificates

An online certificate authority and related tools for secure automated
certificate management, so you can use TLS everywhere.

To learn more, visit https://github.com/smallstep/certificates.

## TL;DR

```console
helm install step-certificates
```

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release step-certificates
```

The command deploys Step certificates on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Step certificates
chart and their default values.

| Parameter                   | Description                                                                       | Default                       |
|-----------------------------|-----------------------------------------------------------------------------------|-------------------------------|
| `ca.name`                   | Name for you CA                                                                   | `Step Certificates`           |
| `ca.address`                | TCP address where Step CA runs                                                    | `:9000`                       |
| `ca.dns`                    | DNS of Step CA, if empty it will be inferred                                      | `""`                          |
| `ca.url`                    | URL of Step CA, if empty it will be inferred                                      | `""`                          |
| `ca.password`               | Password for the CA keys, if empty it will be automatically generated             | `""`                          |
| `ca.provisioner.name`       | Name for the default provisioner                                                  | `admin`                       |
| `ca.provisioner.password`   | Password for the default provisioner, if empty it will be automatically generated | `""`                          |
| `ca.db.enabled`             | If true, step certificates will be configured with a database                     | `true`                        |
| `ca.db.persistent`          | If true a persistent volume will be used to store the db                          | `true`                        |
| `ca.db.accessModes`         | Persistent volume access mode                                                     | `["ReadWriteOnce"]`           |
| `ca.db.size`                | Persistent volume size                                                            | `10Gi`                        |
| `service.type`              | Service type                                                                      | `ClusterIP`                   |
| `service.port`              | Incoming port to access Step CA                                                   | `443`                         |
| `service.targetPort`        | Internal port where Step CA runs                                                  | `9000`                        |
| `replicaCount`              | Number of Step CA replicas. Only one replica is currently supported.              | `1`                           |
| `image.repository`          | Repository of the Step CA image                                                   | `smallstep/step-ca`           |
| `image.tag`                 | Tag of the Step CA image                                                          | `latest`                      |
| `image.pullPolicy`          | Step CA image pull policy                                                         | `IfNotPresent`                |
| `bootstrapImage.repository` | Repository of the Step CA bootstrap image                                         | `smallstep/step-ca-bootstrap` |
| `bootstrapImage.tag`        | Tag of the Step CA bootstrap image                                                | `latest`                      |
| `bootstrapImage.pullPolicy` | Step CA bootstrap image pull policy                                               | `IfNotPresent`                |
| `nameOverride`              | Overrides the name of the chart                                                   | `""`                          |
| `fullnameOverride`          | Overrides the full name of the chart                                              | `""`                          |
| `ingress.enabled`           | If true Step CA ingress will be created                                           | `false`                       |
| `ingress.annotations`       | Step CA ingress annotations (YAML)                                                | `{}`                          |
| `ingress.hosts`             | Step CA ingress hostNAMES (YAML)                                                  | `[]`                          |
| `ingress.tls`               | Step CA ingress TLS configuration (YAML)                                          | `[]`                          |
| `resources`                 | CPU/memory resource requests/limits (YAML)                                        | `{}`                          |
| `nodeSelector`              | Node labels for pod assignment (YAML)                                             | `{}`                          |
| `tolerations`               | Toleration labels for pod assignment (YAML)                                       | `[]`                          |
| `affinity`                  | Affinity settings for pod assignment (YAML)                                       | `{}`                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
helm install --name my-release \
  --set provisioner.password=secretpassword,provisioner.name=Foo \
  step-certificates
```

The above command sets the Step Certificates main provisioner `Foo` with the key
password `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml step-certificates
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Notes

At this moment only one replica is supported, step certificates supports
multiple ones using MariaDB or MySQL.
