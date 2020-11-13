# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Kube-hunter Helm Chart

This directory contains a Kubernetes chart to deploy [Kube-hunter](https://github.com/aquasecurity/kube-hunter).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Chart Details

This chart will do the following:

* Create a CronJob which runs Kube-hunter in [Pod](https://github.com/aquasecurity/kube-hunter#pod) mode.

## Installing the Chart

To install the chart, use the following:

```console
$ helm install stable/kube-hunter
```

## Configuration

The following table lists the configurable parameters of the docker-registry chart and
their default values.

|          Parameter                   |                      Description                      |                   Default                    |
| :----------------------------------- | :---------------------------------------------------- | :------------------------------------------- |
| `customArguments`                    | Additional custom arguments to give to kube-hunter    | `[]`                                         |
| `image.pullPolicy`                   | Container pull policy                                 | `IfNotPresent`                               |
| `image.repository`                   | Container image to use                                | `aquasec/kube-hunter`                        |
| `image.tag`                          | Container image tag to deploy                         | `312`                                        |
| `cronjob.schedule`                   | Schedule for the CronJob                              | `0 1 * * *`                                  |
| `cronjob.annotations`                | Annotations to add to the cronjob                     | {}                                           |
| `cronjob.concurrencyPolicy`          | `Allow|Forbid|Replace` concurrent jobs                | `Forbid`                                     |
| `cronjob.failedJobsHistoryLimit`     | Specify the number of failed Jobs to keep             | `1`                                          |
| `cronjob.successfulJobsHistoryLimit` | Specify the number of completed Jobs to keep          | `1`                                          |
| `pod.annotations`                    | Annotations to add to the pod                         | {}                                           |
| `resources`                          | Resource requests and limits                          | {}                                           |
| `priorityClassName`                  | priorityClassName                                     | `nil`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
