# Descheduler Helm Chart

This directory contains a Kubernetes chart to deploy the [Descheduler](https://github.com/kubernetes-incubator/descheduler).

## Prerequisites Details

* The `descheduler` cron job requires [K8s CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) support:
    > You need a working Kubernetes cluster at version >= 1.8 (for CronJob). For previous versions of cluster (< 1.8) you need to explicitly enable `batch/v2alpha1` API by passing `--runtime-config=batch/v2alpha1=true` to the API server ([see Turn on or off an API version for your cluster for more](https://kubernetes.io/docs/admin/cluster-management/#turn-on-or-off-an-api-version-for-your-cluster)).

## Chart Details

This chart will do the following:

* Create a CronJob which runs the Descheduler

## Installing the Chart

To install the chart, use the following:

```console
$ helm install incubator/descheduler
```

## Configuration

The following table lists the configurable parameters of the docker-registry chart and
their default values.

|          Parameter                   |                      Description                      |                   Default                    |
| :----------------------------------- | :---------------------------------------------------- | :------------------------------------------- |
| `image.pullPolicy`                   | Container pull policy                                 | `IfNotPresent`                               |
| `image.repository`                   | Container image to use                                | `jpdasma/descheduler`                        |
| `image.tag`                          | Container image tag to deploy                         | `0.8.0-1                                     |
| `cronjob.schedule`                   | Schedule for the CronJob                              | `0 1 * * *`                                  |
| `cronjob.annotations`                | Annotations to add to the cronjob                     | {}                                           |
| `cronjob.concurrencyPolicy`          | `Allow|Forbid|Replace` concurrent jobs                | `nil`                                        |
| `cronjob.failedJobsHistoryLimit`     | Specify the number of failed Jobs to keep             | `nil`                                        |
| `cronjob.successfulJobsHistoryLimit` | Specify the number of completed Jobs to keep          | `nil`                                        |
| `pod.annotations`                    | Annotations to add to the pod                         | {}                                           |
| `configMaps.policy_yml`              | Contents of the policy.yaml                           | See values.yaml                              |
| `resources`                          | Resource requests and limits                          | {}                                           |
| `rbac.create`                        | Create cluster role                                   | `true`                                       |
| `serviceAccount.create`              | Create service account                                | `true`                                       |
| `serviceAccount.name`                | Name of the serviceAccount to create                  | `nil`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
