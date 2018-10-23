# NSQ Chart

This chart will allow you to deploy a namespaced production ready NSQ cluster. It will be made of :
* a NSQD replicaset
* a NSQLookupd replicaset
* a NSQAdmin replicaset

Please refer to the [official documentation](https://nsq.io/overview/design.html) for further informations about the NSQ features and internals.

> Note that nsq-admin can be disabled if not needed

## Prerequisites Details

* Kubernetes 1.9+

## Concepts

* [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
* [Headless Services](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

## Installation

```bash
helm install --name <release-name> incubator/nsq
```

## Deletion

```bash
helm delete <release-name>
```

## Monitoring

This chart has been designed with [Prometheus](https://prometheus.io/) in mind. You'll be able to add annotations all along the configuration to each items to be able to scrap monitoring data from them. You can also enable a side container to expose the NSQDs metrics.

## Configuration

#### NSQD

|  Field |  Description |  Default  |
|---|---|---|
| `nsqd.antiAffinity` | The anti affinity rule to apply for the pods scheduling. Allowed values are `soft` and `hard`. | `soft` |
| `nsqd.extraArgs` | Extra arguments to provide to the `nsqd` command | `["--max-msg-timeout=4h", "--max-req-timeout=3h"]` |
| `nsqd.image.pullPolicy` | The pull policy to apply to the image | `Always` |
| `nsqd.image.repository`  | The NSQ image to use  | `nsqio/nsq`  |
| `nsqd.image.tag` |  The docker tag to use for the image | `v1.1.0`  |
| `nsqd.name` | The name of the NSQD replicaset | `nsqd` |
| `nsqd.nodeSelector` | The tags that will be used to select the node on which the pods should be scheduled | `{}` |
| `nsqd.persistence.resources` | The resources to allocate for the persistence of the data | `{ requests: { storage: 10Gi } }` |
| `nsqd.persistence.storageClass` | The storage class to use to persist the NSQD data | `gp2` |
| `nsqd.podAnnotations` | The annotations to attach to the NSQD pods | `{}` |
| `nsqd.podDisruptionBudget` | The minimum available NSQD pods | `{ minAvailable: 3 }` |
| `nsqd.podManagementPolicy` |  The pod management policy of the StatefulSet | `Parallel` |
| `nsqd.priorityClassName` | The name of the [PriorityClass](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) to apply to the pods | *none* |
| `nsqd.replicaCount` | The amount of NSQD replicas in the replicaset | 3 |
| `nsqd.prometheus.enabled` |  Defines if the prometheus metrics should be exported or not | `false` |
| `nsqd.prometheus.image.repository` |  The image of the prometheus exporter to use | `emaincourt/nsq_exporter` |
| `nsqd.prometheus.image.tag` |  The tag to use for the prometheus exporter image | `latest` |
| `nsqd.resources` | The resources to allocate to the pods | `{ limits: { cpu: 100m, memory: 128Mi } }` |
| `nsqd.service.annotations` | The annotations to attach to the service in front of NSQDs | `{}` |
| `nsqd.service.type` | The type of service that should be created in front of NSQDs | `ClusterIP` |
| `nsqd.updateStrategy` | The update strategy of the StatefulSet | *none* |

#### NSQLookupd

|  Field |  Description |  Default  |
|---|---|---|
| `nsqlookupd.antiAffinity` | The anti affinity rule to apply for the pods scheduling. Allowed values are `soft` and `hard`. | `soft` |
| `nsqlookupd.extraArgs` | Extra arguments to provide to the `nsqlookupd` command | `[]` |
| `nsqlookupd.image.pullPolicy` | The pull policy to apply to the image | `Always` |
| `nsqlookupd.image.repository`  | The NSQ image to use  | `nsqio/nsq`  |
| `nsqlookupd.image.tag` |  The docker tag to use for the image | `v1.1.0`  |
| `nsqlookupd.name` | The name of the NSQLookupd replicaset | `nsqlookupd` |
| `nsqlookupd.nodeSelector` | The tags that will be used to select the node on which the pods should be scheduled | `{}` |
| `nsqd.service.annotations` | The annotations to attach to the service in front of NSQLookupds | `{}` |
| `nsqlookupd.podAnnotations` | The annotations to attach to the NSQLookupd pods | `{}` |
| `nsqlookupd.podDisruptionBudget` | The minimum available NSQLookupd pods | `{ minAvailable: 2 }` |
| `nsqlookupd.podManagementPolicy` |  The pod management policy of the StatefulSet | `Parallel` |
| `nsqlookupd.priorityClassName` | The name of the [PriorityClass](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) to apply to the pods | *none* |
| `nsqlookupd.replicaCount` | The amount of NSQLookupd replicas in the replicaset | 3 |
| `nsqlookupd.resources` | The resources to allocate to the pods | `limits: { cpu: 50m, memory: 32Mi }` |
| `nsqlookupd.updateStrategy` | The update strategy of the StatefulSet | *none* |

#### NSQAdmin

|  Field |  Description |  Default  |
|---|---|---|
| `nsqadmin.antiAffinity` | The anti affinity rule to apply for the pods scheduling. Allowed values are `soft` and `hard`. | `soft` |
| `nsqadmin.autoscaling.annotations` | The annotations to attach to the [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) | `true` |
| `nsqadmin.autoscaling.enabled` | Defines if the autoscaling rules should be applied to the Deployment or not | `true` |
| `nsqadmin.autoscaling.maxReplicas` | The maximum bound of the autoscaling rule | 2 |
| `nsqadmin.autoscaling.minReplicas` | The minimum bound of the autoscaling rule | 1 |
| `nsqadmin.autoscaling.targetCPUUtilizationPercentage` | The target CPU utilization for each pod (in %) | 80 |
| `nsqadmin.autoscaling.targetMemoryUtilizationPercentage` | The target mem utilization for each pod (in %) | 60 |
| `nsqadmin.enabled` | Defines if the NSQAdmin interface should be created with the cluster or not | `true` |
| `nsqadmin.image.pullPolicy` | The pull policy to apply to the image | `Always` |
| `nsqadmin.image.repository`  | The NSQ image to use  | `nsqio/nsq`  |
| `nsqadmin.image.tag` |  The docker tag to use for the image | `v1.1.0`  |
| `nsqadmin.ingress.annotations` | The annotations to attach to the [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) | `{}` |
| `nsqadmin.ingress.enabled` | Defines if the [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) in front of the NSQAdmin service will be created or not | `false` |
| `nsqadmin.ingress.path` | The path that should redirect to the administration interface | `/` |
| `nsqadmin.ingress.tls` | The hosts the routing parameters should be applied to | `/` |
| `nsqadmin.name` | The name of the NSQAdmin replicaset | `admin` |
| `nsqadmin.nodeSelector` | The tags that will be used to select the node on which the pods should be scheduled | `{}` |
| `nsqadmin.podAnnotations` | The annotations to attach to the NSQAdmin pods | `{}` |
| `nsqadmin.podDisruptionBudget` | The minimum available NSQAdmin pods | `{ minAvailable: 1 }` |
| `nsqadmin.priorityClassName` | The name of the [PriorityClass](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) to apply to the pods | *none* |
| `nsqadmin.replicaCount` | The amount of NSQAdmin replicas in the replicaset | 1 |
| `nsqadmin.resources` | The resources to allocate to the pods | `limits: { cpu: 50m, memory: 32Mi }` |
| `nsqadmin.service.annotations` | The annotations to attach to the service in front of NSQAdmins | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
