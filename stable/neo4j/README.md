# Neo4j

**This helm chart is deprecated**, replaced by 
[https://github.com/neo4j-contrib/neo4j-helm](https://github.com/neo4j-contrib/neo4j-helm)

## Overview

[Neo4j](https://neo4j.com/) is a highly scalable native graph database that
leverages data relationships as first-class entities, helping enterprises build
intelligent applications to meet today’s evolving data challenges.

## TL;DR;

```bash
$ helm install stable/neo4j
```

## Introduction

This chart bootstraps a [Neo4j](https://github.com/neo4j/docker-neo4j)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

This package is fairly similar to the Neo4j-maintained [GKE Marketplace](https://github.com/neo-technology/neo4j-google-k8s-marketplace) 
entry, which is also built on helm.  This package tries to avoid Kubernetes distribution-specific features to be general, while the other
is tailored specifically to GKE.

## Prerequisites

* Kubernetes 1.6+ with Beta APIs enabled
* PV provisioner support in the underlying infrastructure
* Requires the following variables
  You must add `acceptLicenseAgreement` in the values.yaml file and set it to `yes` or include `--set acceptLicenseAgreement=yes` in the command line of helm install to accept the license.
* This chart requires that you have a license for Neo4j Enterprise Edition.  Trial licenses 
[can be obtained here](https://neo4j.com/lp/enterprise-cloud/?utm_content=kubernetes)

## Installing the Chart

To install the chart with the release name `neo4j-helm`:

```bash
$ helm install my-neo4j stable/neo4j --set acceptLicenseAgreement=yes --set neo4jPassword=mySecretPassword
```

You must explicitly accept the neo4j license agreement for the installation to be successful.

The command deploys Neo4j on the Kubernetes cluster in the default configuration
but with the password set to `mySecretPassword`. The
[configuration](#configuration) section lists the parameters that can be
configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `neo4j-helm` deployment:

```bash
$ helm delete neo4j-helm --purge
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Neo4j chart and
their default values.

| Parameter                             | Description                                                                                                                             | Default                                         |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `image`                               | Neo4j image                                                                                                                             | `neo4j`                                         |
| `imageTag`                            | Neo4j version                                                                                                                           | `{VERSION}`                                     |
| `imagePullPolicy`                     | Image pull policy                                                                                                                       | `IfNotPresent`                                  |
| `podDisruptionBudget`                 | Pod disruption budget                                                                                                                   | `{}`                                            |
| `authEnabled`                         | Is login/password required?                                                                                                             | `true`                                          |
| `useAPOC`                             | Should the APOC plugins be automatically installed in the database?                                                                     | `true`                                          |
| `defaultDatabase`                     | The name of the default database to configure in Neo4j (dbms.default_database)                                                          | `neo4j`                                         |
| `neo4jPassword`                       | Password to log in the Neo4J database if password is required                                                                           | (random string of 10 characters)                |
| `core.configMap`                      | Configmap providing configuration for core cluster members.  If not specified, defaults that come with the chart will be used.          | `$NAME-neo4j-core-config`                       |
| `core.numberOfServers`                | Number of machines in CORE mode                                                                                                         | `3`                                             |
| `core.sideCarContainers`              | Sidecar containers to add to the core pod. Example use case is a sidecar which identifies and labels the leader when using the http API | `{}`                                            |
| `core.initContainers`                 | Init containers to add to the core pod. Example use case is a script that installs custom plugins/extensions                            | `{}`                                            |
| `core.persistentVolume.enabled`       | Whether or not persistence is enabled                                                                                                   | `true`                                          |
| `core.persistentVolume.storageClass`  | Storage class of backing PVC                                                                                                            | `standard` (uses beta storage class annotation) |
| `core.persistentVolume.size`          | Size of data volume                                                                                                                     | `10Gi`                                          |
| `core.persistentVolume.mountPath`     | Persistent Volume mount root path                                                                                                       | `/data`                                         |
| `core.persistentVolume.subPath`       | Subdirectory of the volume to mount                                                                                                     | `nil`                                           |
| `core.persistentVolume.annotations`   | Persistent Volume Claim annotations                                                                                                     | `{}`                                            |
| `readReplica.configMap`               | Configmap providing configuration for RR cluster members.  If not specified, defaults that come with the chart will be used.            | `$NAME-neo4j-replica-config`                    |
| `readReplica.numberOfServers`         | Number of machines in READ_REPLICA mode                                                                                                 | `0`                                             |
| `readReplica.autoscaling.enabled`  | Enable horizontal pod autoscaler  | `false`  |
| `readReplica.autoscaling.targetAverageUtilization`  | Target CPU utilization  | `70`  |
| `readReplica.autoscaling.minReplicas` | Min replicas for autoscaling  | `1`  |
| `readReplica.autoscaling.maxReplicas`  | Max replicas for autoscaling  | `3` |
| `readReplica.initContainers`          | Init containers to add to the replica pods. Example use case is a script that installs custom plugins/extensions                        | `{}`                                            |
| `resources`                           | Resources required (e.g. CPU, memory)                                                                                                   | `{}`                                            |
| `clusterDomain`                       | Cluster domain                                                                                                                          | `cluster.local`                                 |

The above parameters map to the env variables defined in the
[Neo4j docker image](https://github.com/neo4j/docker-neo4j).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```bash
$ helm install my-neo4j --set core.numberOfServers=5,readReplica.numberOfServers=3 stable/neo4j
```

The above command creates a cluster containing 5 core servers and 3 read
replicas.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
$ helm install --name neo4j-helm -f values.yaml stable/neo4j
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Once you have all 3 pods in running, you can run the "test.sh" script in this directory, which will verify the role attached to each pod and also test recovery of a failed/deleted pod. This script requires that the $RELEASE_NAME environment variable be set, in order to access the pods, if you have specified a custom `namespace` or `replicas` value when installing you can set those via `RELEASE_NAMESPACE` and `CORE_REPLICAS` environment variables for this script.

## Using Custom Configuration

The pods in two groups (Cores and read-replicas) are configured with regular ConfigMaps, which turn into environment variables.  Those
environment variables configure the Neo4j pods according to [Neo4j environment variable configuration](https://neo4j.com/docs/operations-manual/current/docker/configuration/#docker-environment-variables).

If you want to do custom configuration, just do so like this:

```
--set core.configMap=myConfigMapName --set readReplica.configMap=myReplicaConfigMap
```

And that will be used instead.   *Note*: configuration of some networking specific settings is still done at container start time,
and this very small set of variables may still be overridden by the helm chart, in particular advertised addresses & hostnames for the containers.

## Additional Documentation for Running Neo4j in Kubernetes

- [Neo4j Considerations in Orchestration Environments](https://medium.com/neo4j/neo4j-considerations-in-orchestration-environments-584db747dca5) which covers
how the smart-client routing protocol that Neo4j uses interacts with Kubernetes networking.  Make sure to read this if you are trying to expose the Neo4j database outside
of Kubernetes
- [How to Backup Neo4j Running in Kubernetes](https://medium.com/neo4j/how-to-backup-neo4j-running-in-kubernetes-3697761f229a)
- [How to Restore Neo4j Backups on Kubernetes](https://medium.com/google-cloud/how-to-restore-neo4j-backups-on-kubernetes-and-gke-6841aa1e3961)

## Upgrading

Version numbers here refer to helm chart versions, not Neo4j product versions.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
The 2.0.0 chart was based around Neo4j's 3.5.x product series.  The 3.0 chart is based around Neo4j's 4.0.x product
series, and there are *substantial differences* between these two.  Careful upgrade planning is advised before attempting
to upgrade an existing chart.  Consult [the upgrade guide](https://neo4j.com/docs/operations-manual/current/upgrade/) and
expect that additional configuration of this chart will be necessary.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 2.0.0. The following example assumes that the release name is neo4j:

```console
$ kubectl delete statefulset.apps neo4j-neo4j-core --cascade=false
$ kubectl delete deployments.apps neo4j-neo4j-replica --cascade=false
```
