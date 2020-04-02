# SysFlow

The [SysFlow Telemetry Pipeline](https://github.com/sysflow-telemetry) is a framework for monitoring cloud workloads and for creating performance and security analytics. The goal of this project is to build all the plumbing required for system telemetry so that users can focus on writing and sharing analytics on a scalable, common open-source platform. The backbone of the telemetry pipeline is a new data format called SysFlow, which lifts raw system event information into an abstraction that describes process behaviors, and their relationships with containers, files, and network. This object-relational format is highly compact, yet it provides broad visibility into container clouds. We have also built several APIs that allow users to process SysFlow with their favorite toolkits.

## Chart Description

This chart adds the SysFlow agent with containers, sf-collector and sf-exporter, to all nodes in your cluster via a DaemonSet.

## Prerequisites

- S3 compliant object store
- Create Cloud Object Store HMAC Access ID, and Secret Key

Currently tested with IBM’s cloud object store, and minio object store (https://docs.min.io/)

Setup IBM Cloud Object store: https://cloud.ibm.com/docs/services/cloud-object-storage/iam?topic=cloud-object-storage-getting-started

Get credentials for IBM Cloud Object store: https://cloud.ibm.com/docs/services/cloud-object-storage/iam?topic=cloud-object-storage-service-credentials

## Installing the Chart

To install the chart with the release name `sysflow`, just run:

```bash
$ helm install --name sysflow \
    --set sfexporter.s3Endpoint=YOUR-URL-HERE \
    --set sfexporter.s3AccessKey=YOUR-KEY-HERE \
    --set sfexporter.s3SecretKey=YOUR-KEY-HERE \
    incubator/sysflow
```

After a few seconds, you should see containers appearing as SysFlow agents.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `sysflow` deployment:

```bash
$ helm uninstall sysflow
```

The command removes all the Kubernetes components associated with the chart and deletes the Helm release.

## Configuration

The following table lists the configurable parameters of the SysFlow chart and their default values.

| Parameter                     | Description                                                          | Default                                     |
| ---                           | ---                                                                  | ---                                         |
| `sfcollector.repository`      | The image repository to pull from                                    | `sysflowtelemetry/sf-collector`             |
| `sfcollector.tag`             | The image tag to pull                                                | `latest`                                    |
| `sfcollector.interval`        | Timeout in seconds to start roll a new trace files                   | `300`                                       |
| `sfcollector.outDir`          | Output directory, where traces are written to inside container       | `/mnt/data/`                                |
| `sfcollector.filter`          | Collection filter                                                    | `"container.type!=host and container.name!=sfexporter and container.name!=sfcollector"`                                      |
| `sfcollector.criPath`         | Use this criPath if running docker runtime                           |                                           |
| `sfexporter.repository`       | The image repository to pull from                                    | `sysflowtelemetry/sf-exporter`              |
| `sfexporter.tag`              | The image tag to pull                                                | `latest`                                    |
| `sfexporter.interval`         | Export interval in seconds                                           | `30`                                        |
| `sfexporter.outDir`           | Directory where traces are read from inside container                | `/mnt/data/`                                |
| `sfexporter.s3Endpoint`       | Object store address (must be overridden)                            | `localhost`                                          |
| `sfexporter.s3Port`           | Object store port                                                    | `443`                                       |
| `sfexporter.s3Bucket`         | Object store bucket where to push traces                             | `sf-monitoring`                             |
| `sfexporter.s3Location`       | Object store location                                                |                                           |
| `sfexporter.s3AccessKey`      | Object store access key (must be overridden)                         |                                           |
| `sfexporter.s3SecretKey`      | Object store secret key (must be overridden)                         |                                           |
| `sfexporter.s3Secure`         | Object store connection, 'true' if TLS-enabled, 'false' otherwise    | `true`                                      |
| `resources.requests.cpu`      | CPU requested for being run in a node                                | `600m`                                      |
| `resources.requests.memory`   | Memory requested for being run in a node                             | `512Mi`                                     |
| `resources.limits.cpu`        | CPU limit                                                            | `2000m`                                     |
| `resources.limits.memory`     | Memory limit                                                         | `1536Mi`                                    |

## Upgrading to the Lastest Version

First of all ensure you have the lastest chart version

```bash
$ helm repo update
```

In case you deployed the chart with a values.yaml.local file, you just need to modify (or add if it's missing) the `sfcollector.tag` field and execute:

```bash
$ helm install --name sysflow -f values.yaml.local incubator/sysflow
```
> **Tip**: You can use the default [values.yaml](values.yaml)

