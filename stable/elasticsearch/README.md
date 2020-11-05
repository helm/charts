# Elasticsearch Helm Chart

This chart uses a standard Docker image of Elasticsearch (docker.elastic.co/elasticsearch/elasticsearch-oss) and uses a service pointing to the master's transport port for service discovery.
Elasticsearch does not communicate with the Kubernetes API, hence no need for RBAC permissions.

## This Helm chart is deprecated
As mentioned in #10543 this chart has been deprecated in favour of the official [Elastic Helm Chart](https://github.com/elastic/helm-charts/tree/master/elasticsearch).
We have made steps towards that goal by producing a [migration guide](https://github.com/elastic/helm-charts/blob/master/elasticsearch/examples/migration/README.md) to help people switch the management of their clusters over to the new Charts.
The Elastic Helm Chart supports version 6 and 7 of Elasticsearch and it was decided it would be easier for people to upgrade after migrating to the Elastic Helm Chart because it's upgrade process works better.
During deprecation process we want to make sure that Chart will do what people are using this chart to do.
Please look at the Elastic Helm Charts and if you see anything missing from please [open an issue](https://github.com/elastic/helm-charts/issues/new/choose) to let us know what you need.
The Elastic Chart repo is also in [Helm Hub](https://hub.helm.sh).

## Warning for previous users
If you are currently using an earlier version of this Chart you will need to redeploy your Elasticsearch clusters. The discovery method used here is incompatible with using RBAC.
If you are upgrading to Elasticsearch 6 from the 5.5 version used in this chart before, please note that your cluster needs to do a full cluster restart.
The simplest way to do that is to delete the installation (keep the PVs) and install this chart again with the new version.
If you want to avoid doing that upgrade to Elasticsearch 5.6 first before moving on to Elasticsearch 6.0.

## Prerequisites Details

* Kubernetes 1.10+
* PV dynamic provisioning support on the underlying infrastructure

## StatefulSets Details
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSets Caveats
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Todo

* Implement TLS/Auth/Security
* Smarter upscaling/downscaling
* Solution for memory locking

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable elasticsearch cluster using Kubernetes StatefulSets/Deployments
* Multi-role deployment: master, client (coordinating) and data nodes
* Statefulset Supports scaling down without degrading the cluster

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/elasticsearch
```

## Deleting the Charts

Delete the Helm deployment as normal

```
$ helm delete my-release
```

Deletion of the StatefulSet doesn't cascade to deleting associated PVCs. To delete them:

```
$ kubectl delete pvc -l release=my-release,component=data
```

## Configuration

The following table lists the configurable parameters of the elasticsearch chart and their default values.

|              Parameter               |                             Description                             |                       Default                       |
| ------------------------------------ | ------------------------------------------------------------------- | --------------------------------------------------- |
| `appVersion`                         | Application Version (Elasticsearch)                                 | `6.8.2`                                             |
| `image.repository`                   | Container image name                                                | `docker.elastic.co/elasticsearch/elasticsearch-oss` |
| `image.tag`                          | Container image tag                                                 | `6.8.2`                                             |
| `image.pullPolicy`                   | Container pull policy                                               | `IfNotPresent`                                      |
| `image.pullSecrets`                    | container image pull secrets                      | `[]`                          |
| `initImage.repository`               | Init container image name                                           | `busybox`                                           |
| `initImage.tag`                      | Init container image tag                                            | `latest`                                            |
| `initImage.pullPolicy`               | Init container pull policy                                          | `Always`                                            |
| `schedulerName`                      | Name of the k8s scheduler (other than default)                      | `nil`                                               |
| `cluster.name`                       | Cluster name                                                        | `elasticsearch`                                     |
| `cluster.xpackEnable`                | Writes the X-Pack configuration options to the configuration file   | `false`                                             |
| `cluster.config`                     | Additional cluster config appended                                  | `{}`                                                |
| `cluster.keystoreSecret`             | Name of secret holding secure config options in an es keystore      | `nil`                                               |
| `cluster.env`                        | Cluster environment variables                                       | `{MINIMUM_MASTER_NODES: "2"}`                       |
| `cluster.bootstrapShellCommand`      | Post-init command to run in separate Job                            | `""`                                                |
| `cluster.additionalJavaOpts`         | Cluster parameters to be added to `ES_JAVA_OPTS` environment variable | `""`                                              |
| `cluster.plugins`                    | List of Elasticsearch plugins to install                            | `[]`                                                |
| `cluster.loggingYml`                 | Cluster logging configuration for ES v2                             | see `values.yaml` for defaults                      |
| `cluster.log4j2Properties`           | Cluster logging configuration for ES v5 and 6                       | see `values.yaml` for defaults                      |
| `client.name`                        | Client component name                                               | `client`                                            |
| `client.replicas`                    | Client node replicas (deployment)                                   | `2`                                                 |
| `client.resources`                   | Client node resources requests & limits                             | `{} - cpu limit must be an integer`                 |
| `client.priorityClassName`           | Client priorityClass                                                | `nil`                                               |
| `client.heapSize`                    | Client node heap size                                               | `512m`                                              |
| `client.podAnnotations`              | Client Deployment annotations                                       | `{}`                                                |
| `client.nodeSelector`                | Node labels for client pod assignment                               | `{}`                                                |
| `client.tolerations`                 | Client tolerations                                                  | `[]`                                                |
| `client.terminationGracePeriodSeconds` | Client nodes: Termination grace period (seconds)                  | `nil`                                               |
| `client.serviceAnnotations`          | Client Service annotations                                          | `{}`                                                |
| `client.serviceType`                 | Client service type                                                 | `ClusterIP`                                         |
| `client.httpNodePort`                | Client service HTTP NodePort port number. Has no effect if client.serviceType is not `NodePort`.   | `nil`                                         |
| `client.loadBalancerIP`              | Client loadBalancerIP                                               | `{}`                                                |
| `client.loadBalancerSourceRanges`    | Client loadBalancerSourceRanges                                     | `{}`                                                |
| `client.antiAffinity`                | Client anti-affinity policy                                         | `soft`                                              |
| `client.nodeAffinity`                | Client node affinity policy                                         | `{}`                                                |
| `client.initResources`               | Client initContainer resources requests & limits                    | `{}`                                                |
| `client.hooks.preStop`               | Client nodes: Lifecycle hook script to execute prior the pod stops  | `nil`                                               |
| `client.hooks.preStart`              | Client nodes: Lifecycle hook script to execute after the pod starts | `nil`                                               |
| `client.additionalJavaOpts`          | Parameters to be added to `ES_JAVA_OPTS` environment variable for client | `""`                                           |
| `client.ingress.enabled`             | Enable Client Ingress                                               | `false`                                             |
| `client.ingress.user`                | If this & password are set, enable basic-auth on ingress            | `nil`                                               |
| `client.ingress.password`            | If this & user are set, enable basic-auth on ingress                | `nil`                                               |
| `client.ingress.annotations`         | Client Ingress annotations                                          | `{}`                                                |
| `client.ingress.hosts`               | Client Ingress Hostnames                                            | `[]`                                                |
| `client.ingress.tls`                 | Client Ingress TLS configuration                                    | `[]`                                                |
| `client.exposeTransportPort`         | Expose transport port 9300 on client service (ClusterIP)            | `false`                                             |
| `master.initResources`               | Master initContainer resources requests & limits                    | `{}`                                                |
| `master.additionalJavaOpts`          | Parameters to be added to `ES_JAVA_OPTS` environment variable for master | `""`                                           |
| `master.exposeHttp`                  | Expose http port 9200 on master Pods for monitoring, etc            | `false`                                             |
| `master.name`                        | Master component name                                               | `master`                                            |
| `master.replicas`                    | Master node replicas (deployment)                                   | `2`                                                 |
| `master.resources`                   | Master node resources requests & limits                             | `{} - cpu limit must be an integer`                 |
| `master.priorityClassName`           | Master priorityClass                                                | `nil`                                               |
| `master.podAnnotations`              | Master Deployment annotations                                       | `{}`                                                |
| `master.nodeSelector`                | Node labels for master pod assignment                               | `{}`                                                |
| `master.tolerations`                 | Master tolerations                                                  | `[]`                                                |
| `master.terminationGracePeriodSeconds` | Master nodes: Termination grace period (seconds)                  | `nil`                                               |
| `master.heapSize`                    | Master node heap size                                               | `512m`                                              |
| `master.name`                        | Master component name                                               | `master`                                            |
| `master.persistence.enabled`         | Master persistent enabled/disabled                                  | `true`                                              |
| `master.persistence.name`            | Master statefulset PVC template name                                | `data`                                              |
| `master.persistence.size`            | Master persistent volume size                                       | `4Gi`                                               |
| `master.persistence.storageClass`    | Master persistent volume Class                                      | `nil`                                               |
| `master.persistence.accessMode`      | Master persistent Access Mode                                       | `ReadWriteOnce`                                     |
| `master.readinessProbe`              | Master container readiness probes                                   | see `values.yaml` for defaults                      |
| `master.antiAffinity`                | Master anti-affinity policy                                         | `soft`                                              |
| `master.nodeAffinity`                | Master node affinity policy                                         | `{}`                                                |
| `master.podManagementPolicy`         | Master pod creation strategy                                        | `OrderedReady`                                      |
| `master.updateStrategy`              | Master node update strategy policy                                  | `{type: "onDelete"}`                                |
| `master.hooks.preStop`               | Master nodes: Lifecycle hook script to execute prior the pod stops  | `nil`                                               |
| `master.hooks.preStart`              | Master nodes: Lifecycle hook script to execute after the pod starts | `nil`                                               |
| `data.initResources`                 | Data initContainer resources requests & limits                      | `{}`                                                |
| `data.additionalJavaOpts`            | Parameters to be added to `ES_JAVA_OPTS` environment variable for data | `""`                                             |
| `data.exposeHttp`                    | Expose http port 9200 on data Pods for monitoring, etc              | `false`                                             |
| `data.replicas`                      | Data node replicas (statefulset)                                    | `2`                                                 |
| `data.resources`                     | Data node resources requests & limits                               | `{} - cpu limit must be an integer`                 |
| `data.priorityClassName`             | Data priorityClass                                                  | `nil`                                               |
| `data.heapSize`                      | Data node heap size                                                 | `1536m`                                             |
| `data.hooks.drain.enabled`           | Data nodes: Enable drain pre-stop and post-start hook               | `true`                                              |
| `data.hooks.preStop`                 | Data nodes: Lifecycle hook script to execute prior the pod stops. Ignored if `data.hooks.drain.enabled` is `true` | `nil` |
| `data.hooks.preStart`                | Data nodes: Lifecycle hook script to execute after the pod starts. Ignored if `data.hooks.drain.enabled` is `true` | `nil`|
| `data.persistence.enabled`           | Data persistent enabled/disabled                                    | `true`                                              |
| `data.persistence.name`              | Data statefulset PVC template name                                  | `data`                                              |
| `data.persistence.size`              | Data persistent volume size                                         | `30Gi`                                              |
| `data.persistence.storageClass`      | Data persistent volume Class                                        | `nil`                                               |
| `data.persistence.accessMode`        | Data persistent Access Mode                                         | `ReadWriteOnce`                                     |
| `data.readinessProbe`                | Readiness probes for data-containers                                | see `values.yaml` for defaults                      |
| `data.podAnnotations`                | Data StatefulSet annotations                                        | `{}`                                                |
| `data.nodeSelector`                  | Node labels for data pod assignment                                 | `{}`                                                |
| `data.tolerations`                   | Data tolerations                                                    | `[]`                                                |
| `data.terminationGracePeriodSeconds` | Data termination grace period (seconds)                             | `3600`                                              |
| `data.antiAffinity`                  | Data anti-affinity policy                                           | `soft`                                              |
| `data.nodeAffinity`                  | Data node affinity policy                                           | `{}`                                                |
| `data.podManagementPolicy`           | Data pod creation strategy                                          | `OrderedReady`                                      |
| `data.updateStrategy`                | Data node update strategy policy                                    | `{type: "onDelete"}`                                |
| `sysctlInitContainer.enabled`        | If true, the sysctl init container is enabled (does not stop chownInitContainer or extraInitContainers from running) | `true`                                              |
| `chownInitContainer.enabled`        | If true, the chown init container is enabled (does not stop sysctlInitContainer or extraInitContainers from running) | `true`                                              |
| `extraInitContainers`                | Additional init container passed through the tpl                    | ``                                                  |
| `podSecurityPolicy.annotations`      | Specify pod annotations in the pod security policy                  | `{}`                                              |
| `podSecurityPolicy.enabled`          | Specify if a pod security policy must be created                    | `false`                                             |
| `securityContext.enabled`      | If true, add securityContext to client, master and data pods                          | `false`                                 |
| `securityContext.runAsUser`      | user ID to run containerized process                          | `1000`                                                        |
| `serviceAccounts.client.create`      | If true, create the client service account                          | `true`                                        |
| `serviceAccounts.client.name`        | Name of the client service account to use or create                 | `{{ elasticsearch.client.fullname }}`               |
| `serviceAccounts.master.create`      | If true, create the master service account                          | `true`                                              |
| `serviceAccounts.master.name`        | Name of the master service account to use or create                 | `{{ elasticsearch.master.fullname }}`               |
| `serviceAccounts.data.create`        | If true, create the data service account                            | `true`                                              |
| `serviceAccounts.data.name`          | Name of the data service account to use or create                   | `{{ elasticsearch.data.fullname }}`                 |
| `testFramework.image`                | `test-framework` image repository.                                  | `dduportal/bats`                                    |
| `testFramework.tag`                  | `test-framework` image tag.                                         | `0.4.0`                                             |
| `forceIpv6`                          | force to use IPv6 address to listen if set to true                  | `false`                                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

In terms of Memory resources you should make sure that you follow that equation:

- `${role}HeapSize < ${role}MemoryRequests < ${role}MemoryLimits`

The YAML value of cluster.config is appended to elasticsearch.yml file for additional customization ("script.inline: on" for example to allow inline scripting)

# Deep dive

## Application Version

This chart aims to support Elasticsearch v2 to v6 deployments by specifying the `values.yaml` parameter `appVersion`.

### Version Specific Features

* Memory Locking *(variable renamed)*
* Ingest Node *(v5)*
* X-Pack Plugin *(v5)*

Upgrade paths & more info: https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-upgrade.html

## Mlocking

This is a limitation in kubernetes right now. There is no way to raise the
limits of lockable memory, so that these memory areas won't be swapped. This
would degrade performance heavily. The issue is tracked in
[kubernetes/#3595](https://github.com/kubernetes/kubernetes/issues/3595).

```
[WARN ][bootstrap] Unable to lock JVM Memory: error=12,reason=Cannot allocate memory
[WARN ][bootstrap] This can result in part of the JVM being swapped out.
[WARN ][bootstrap] Increase RLIMIT_MEMLOCK, soft limit: 65536, hard limit: 65536
```

## Minimum Master Nodes
> The minimum_master_nodes setting is extremely important to the stability of your cluster. This setting helps prevent split brains, the existence of two masters in a single cluster.

>When you have a split brain, your cluster is at danger of losing data. Because the master is considered the supreme ruler of the cluster, it decides when new indices can be created, how shards are moved, and so forth. If you have two masters, data integrity becomes perilous, since you have two nodes that think they are in charge.

>This setting tells Elasticsearch to not elect a master unless there are enough master-eligible nodes available. Only then will an election take place.

>This setting should always be configured to a quorum (majority) of your master-eligible nodes. A quorum is (number of master-eligible nodes / 2) + 1

More info: https://www.elastic.co/guide/en/elasticsearch/guide/1.x/_important_configuration_changes.html#_minimum_master_nodes

# Client and Coordinating Nodes

Elasticsearch v5 terminology has updated, and now refers to a `Client Node` as a `Coordinating Node`.

More info: https://www.elastic.co/guide/en/elasticsearch/reference/5.5/modules-node.html#coordinating-node

## Enabling elasticsearch internal monitoring
Requires version 6.3+ and standard non `oss` repository defined. Starting with 6.3 Xpack is partially free and enabled by default. You need to set a new config to enable the collection of these internal metrics. (https://www.elastic.co/guide/en/elasticsearch/reference/6.3/monitoring-settings.html)

To do this through this helm chart override with the three following changes:
```
image.repository: docker.elastic.co/elasticsearch/elasticsearch
cluster.xpackEnable: true
cluster.env.XPACK_MONITORING_ENABLED: true
```

Note: to see these changes you will need to update your kibana repo to `image.repository: docker.elastic.co/kibana/kibana` instead of the `oss` version


## Select right storage class for SSD volumes

### GCE + Kubernetes 1.5

Create StorageClass for SSD-PD

```
$ kubectl create -f - <<EOF
kind: StorageClass
apiVersion: extensions/v1beta1
metadata:
  name: ssd
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
EOF
```
Create cluster with Storage class `ssd` on Kubernetes 1.5+

```
$ helm install stable/elasticsearch --name my-release --set data.persistence.storageClass=ssd,data.storage=100Gi
```

### Usage of the `tpl` Function

The `tpl` function allows us to pass string values from `values.yaml` through the templating engine. It is used for the following values:

* `extraInitContainers`

It is important that these values be configured as strings. Otherwise, installation will fail.
