# Kube-Bench Helm Chart

This directory contains a Kubernetes chart to deploy the [Kube-bench](https://github.com/aquasecurity/kube-bench).

## Prerequisites Details

* Kube-Bench

* The `kube-bench` cron job requires [K8s CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) support:
    > You need a working Kubernetes cluster at version >= 1.8 (for CronJob). For previous versions of cluster (< 1.8) you need to explicitly enable `batch/v2alpha1` API by passing `--runtime-config=batch/v2alpha1=true` to the API server ([see Turn on or off an API version for your cluster for more](https://kubernetes.io/docs/admin/cluster-management/#turn-on-or-off-an-api-version-for-your-cluster)).

## Chart Details

This chart will do the following:

* Create a CronJob which runs the Kube-bench

## Installing the Chart

To install the chart, use the following:

```console
$ helm install incubator/kube-bench
```

## Configuration

The following table lists the configurable parameters of the docker-registry chart and
their default values.

|          Parameter                   |                         Description                         |                   Default                    |
| :----------------------------------- | :---------------------------------------------------------- | :------------------------------------------- |
| `image.pullPolicy`                   | Container pull policy                                       | `IfNotPresent`                               |
| `image.repository`                   | Container image to use                                      | `aquasec/kube-bench`                         |
| `image.tag`                          | Container image tag to deploy                               | `0.1.0`                                      |
| `cronjob.schedule`                   | Schedule for the CronJob                                    | `0 0 1 * *`                                  |
| `cronjob.annotations`                | Annotations to add to the cronjob                           | {}                                           |
| `cronjob.concurrencyPolicy`          | `Allow|Forbid|Replace` concurrent jobs                      | `Forbid`                                     |
| `cronjob.failedJobsHistoryLimit`     | Specify the number of failed Jobs to keep                   | `2`                                          |
| `cronjob.successfulJobsHistoryLimit` | Specify the number of completed Jobs to keep                | `2`                                          |
| `pod.annotations`                    | Annotations to add to the pod                               | {}                                           |
| `command`                            | Command to execute                                          | ["kube-bench", "--version", "1.13"]          |
| `resources`                          | Resource requests and limits                                | {}                                           |


Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
