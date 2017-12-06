# CouchDB

Apache CouchDB is a database featuring seamless multi-master sync, that scales
from big data to mobile, with an intuitive HTTP/JSON API and designed for
reliability.

This chart deploys a CouchDB cluster as a StatefulSet. It creates a ClusterIP
Service in front of the deployment for load balancing by default, but can also
be configured to deploy other Service types or an Ingress controller. The
default persistence mechanism is simply the ephemeral local filesystem, but
production deployments should set `persistentVolume.enabled` to `true` to attach
storage volumes to each Pod in the deployment.

## TL;DR

```bash
$ helm install incubator/couchdb
```

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/couchdb
```

The command deploys CouchDB on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists 
the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the most commonly configured parameters of the
CouchDB chart and their default values:

|           Parameter             |             Description                               |                Default                 |
|---------------------------------|-------------------------------------------------------|----------------------------------------|
| `clusterSize`                   | The initial number of nodes in the CouchDB cluster    | 3                                      |
| `couchdbConfig`                 | Map allowing override elements of server .ini config  | {}                                     |
| `erlangFlags`                   | Map of flags supplied to the underlying Erlang VM     | name: couchdb, setcookie: monster
| `persistentVolume.enabled`      | Boolean determining whether to attach a PV to each node | false
| `persistentVolume.size`         | If enabled, the size of the persistent volume to attach                          | 10Gi

A variety of other parameters are also configurable. See the comments in the
`values.yaml` file for further details:

|           Parameter             |                Default                 |
|---------------------------------|----------------------------------------|
| `helperImage.repository`        | kocolosk/couchdb-statefulset-assembler |
| `helperImage.tag`               | 0.1.0                                  |
| `helperImage.pullPolicy`        | IfNotPresent                           |
| `image.repository`              | couchdb                                |
| `image.tag`                     | 2.1.1                                  |
| `image.pullPolicy`              | IfNotPresent                           |
| `ingress.enabled`               | false                                  |
| `ingress.hosts`                 | chart-example.local                    |
| `ingress.annotations`           |                                        |
| `ingress.tls`                   |                                        |
| `persistentVolume.accessModes`  | ReadWriteOnce                          |
| `persistentVolume.storageClass` | Default for the Kube cluster           |
| `podManagementPolicy`           | Parallel                               |
| `resources`                     |                                        |
| `service.enabled`               | true                                   |
| `service.type`                  | ClusterIP                              |
| `service.externalPort`          | 5984                                   |

## TODO

* Configure administrator account credentials using Secrets
