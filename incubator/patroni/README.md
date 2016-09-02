# Patroni Helm Chart

This directory contains a Kubernetes chart to deploy a five node patroni cluster using a petset.

## Prerequisites Details
* Kubernetes 1.3 with alpha APIs enable
* PV support on the underlying infrastructure

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

## Todo
* Make namespace configurable

## Chart Details
This chart will do the following:

* Implement a HA scalable PostgreSQL cluster using Kubernetes PetSets

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release patroni-x.x.x.tgz
```

## Configuration

The following tables lists the configurable parameters of the patroni chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `Name`                  | Service name                        | `patroni`                                           |
| `Namespace`             | Service namespace                   | `default`                                           |
| `Spilo.Image`           | Container image name                | `registry.opensource.zalan.do/acid/spilo-9.5`       |
| `Spilo.Version`         | Container image tag                 | `1.0-p5`                                            |
| `ImagePullPolicy`       | Container pull policy               | `IfNotPresent`                                      |
| `Replicas`              | k8s petset replicas                 | `5`                                                 |
| `Component`             | k8s selector key                    | `patroni`                                           |
| `Resources.Cpu`         | container requested cpu             | `100m`                                              |
| `Resources.Memory`      | container requested memory          | `512Mi`                                             |
| `Resources.Storage`     | Persistent volume size              | `1Gi`                                               |
| `Credentials.Superuser` | password for the superuser          | `tea`                                               |
| `Credentials.Admin`     | password for the admin user         | `cola`                                              |
| `Credentials.Standby`   | password for the replication user   | `pinacolada`                                        |
| `Etcd.Discovery`        | domain name serving DNS records for etcd              | `etcd.default.svc.cluster.local`  |
| `GCS.Credentials`       | Google service account key file for authentication    | `<needs to be defined>`           |
| `GCS.Bucket`            | GCS bucket name to stream WAL files and base backups  | `some-google-bucket`              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml patroni-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)
