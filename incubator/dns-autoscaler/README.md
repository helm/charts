# DNS autoscaler

## Introduction

The DNS autoscaler watches over the number of schedulable nodes and cores of the cluster and resizes the number of replicas for the required resource.


## Prerequisites

### Getting the name of the target to be scaled

In Kubernetes versions earlier than 1.12, the DNS Deployment was called “kube-dns”.

```shell
$ kubectl get deployment --namespace=kube-system
NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
coredns-coredns      2         2         2            2           3h
...
```

## Configuration


| Parameter                   | Description                                 | Default                                            |
| --------------------------- | ------------------------------------------- | -------------------------------------------------- |
| `config.scaleTarget`        | Name of the deployment to be scaled         | `coredns-coredns`                                  |
| `config.min`                | Minimum number of replicas                  | `1`                                                |
| `config.nodesPerReplica`    | Number of nodes per replica                 | `16`                                               |
| `config.coresPerReplica`    | Nuber of cpu cores per replica              | `256`                                              |
| `image.pullPolicy`          | Container pull policy                       | `IfNotPresent`                                     |
| `image.repository`          | Container image to use                      | `k8s.gcr.io/cluster-proportional-autoscaler-amd64` |
| `image.tag`                 | Container image tag to deploy               | `1.1.1`                                            |
| `replicaCount`              | k8s replicas                                | `1`                                                |
| `resources.limits.cpu`      | Container maximum CPU                       | `80m`                                              |
| `resources.limits.memory`   | Container maximum memory                    | `64Mi`                                             |
| `resources.requests.cpu`    | Container requested CPU                     | `40m`                                              |
| `resources.requests.memory` | Container requested memory                  | `32Mi`                                             |
| `serviceAccount.create`     | If true, create the service account         | `false`                                            |
| `serviceAccount.name`       | Name of the serviceAccount to create or use | `{{ dnsAutoscaler.fullname }}`                     |
| `nodeSelector`              | Map of node labels for pod assignment       | `{}`                                               |
| `tolerations`               | List of node taints to tolerate             | `[]`                                               |
| `affinity`                  | Map of node/pod affinities                  | `{}`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

## Installation

```shell
helm install --name my-dns-autoscaler -f custom.yaml incubator/dns-autoscaler
```

## Uninstall

```shell
helm delete my-dns-autoscaler
```

To delete the deployment and its history:
```shell
helm delete --purge my-dns-autoscaler
```
