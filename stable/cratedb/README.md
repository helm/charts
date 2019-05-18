# CrateDB

CrateDB is a distributed SQL database built on top of a NoSQL foundation. It combines the familiarity of SQL with the scalability and data flexibility of NoSQL, enabling developers to:

 - Use SQL to process any type of data, structured or unstructured
 - Perform SQL queries at realtime speed, even JOINs and aggregates
 - Scale simply

This chart deploys a CrateDB cluster as a StatefulSet. It creates a External
Service that does load balancing by default. The default persistence mechanism 
is simply the ephemeral local filesystem, but production deployments should 
set `persistentVolume.enabled` to `true` to attach storage volumes to each Pod 
in the Deployment.

### TL;DR

```bash
$ helm install incubator/cratedb
```

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- If deploying in production environment, you need to have persistent volumes

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name my-crate incubator/cratedb
```

This Helm chart deploys crateDB on the Kubernetes cluster in a default
configuration. The [configuration](#configuration) section lists
the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

> **Tip** List installed crateDB release `helm list | grep crate`

> **Tip** get history of chart version/ status/ etc... CrateDB releases `helm history my-crate` 

## Uninstalling the Chart

To uninstall/delete the `my-crate` Deployment:

```bash
$ helm delete my-crate
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.
( If your used persistence volumes then removing those will depends on your pv policy)

## Upgrading an existing Release to a new major version

A major chart version change (like v0.1.0 -> v1.0.0) indicates that there may be
incompatible or breaking changes that require manual actions.

### 0.1.0
This is the initial version of the crateDB chart with the minimal configuration/ settings.

## How to delete the crateDB StatefulSet
```bash
$ kubectl delete statefulsets --cascade=false my-crate
```

## Configuration

The following table lists main configurable most common parameters of the CrateDB chart and their default values:

| Parameter                       | Description                                           | Default                            |
|---------------------------------|-------------------------------------------------------|------------------------------------|
| `clusterSize`                   | The initial number of nodes in the CrateDB cluster    | 3                                  |
| `clusterName`                   | name given for the new CrateDB cluster                | cratedb-cluster                    |
| `namespace`                     | namespace that you want to install crateDB            | default                            |
| `cratadbStatefulsetName`        | Name for the CrateDB statefulset                      | crate-set                          |
| `heapSize`                      | Size of the heap that your want to set for the CrateDB (megabytes) | 256m                  |
| `resources`                     | resources requests/limits can be defined as your requirement | {}                          |
| `persistentVolume.enabled`      | enable persistent volumes ( this must be true if your are running in production | false    |
| `persistentVolume.accessModes`  | access mode                                           | ReadWriteOnce                      |
| `persistentVolume.size`         | disk size ( production environment you have to specify according to your requirement | 5Gi |
| `cratedbConfig.dataPath`        |  CrateDB configuration, data path                     | /data                              |
| `cratedbConfig.volumeMountName` | mount volume name                                     | data                               |
| `affinity`                      | pod affinity                                          | {}                                 |
| `nameOverride`                  | override chart name                                   | ""                                 |
| `fullnameOverride`              | override chart full name                              | ""                                 |

Following table contains other parameters are also configurable in chart, but most of the time you may don't need to modify

| Parameter                                        | Description                          |                 Default            |
|--------------------------------------------------|--------------------------------------|------------------------------------|
| `cratedbConfig.discovery.recoverAfterNodes`      |  CrateDB recover when found this much of nodes | 2                        |
| `cratedbConfig.discovery.zen.minimumMasterNodes` |  minimum master nodes                | 2                                  |
| `cratedbConfig.discovery.zen.hostsProvider`      |  host provider                       | srv                                |  
| `internalService.port`                           | port for the internal service, this is the port for inter-node communication| 4300  |
| `internalService.portName`                       | name for the internal service port   | crate-internal                     |
| `internalService.name`                           | name for the inter-node communication service  | crate-internal-service   |
| `externalService.name`                           | name for the external service        | crate-external-service             |
| `externalService.webUiPort`                      | port for the webUI for the CrateDB   | 4200                               |
| `externalService.webPortName`                    | name of the port for the webUI for the CrateDB | crate-web                |
| `externalService.pgsqlWirePort`                  | PostgreSQL wire protocol port        | 5432                               |
| `labels`                                         | Your labels that you want to put in the resources | {}                    |
| `image.repository`                               | CrateDB image                        | crate                              |
| `image.tag`                                      | version/ tag of the image            | 3.2.7                              |
| `image.pullPolicy`                               | image pull policy                    | IfNotPresent                       |










