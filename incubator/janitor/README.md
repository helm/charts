# Kube-Janitor
Kubernetes Janitor cleans up (deletes) Kubernetes resources on (1) a configured TTL (time to live) or (2) a configured expiry date (absolute timestamp).

This chart helps you deploy kube-janitor as CronJob on your Kubernetes cluster. You can find the original repo here: https://github.com/hjacobs/kube-janitor

## Configuration

The deployment option for this chart currently only support CronJob type. Please checkout Kubernete's docs for more info on CronJob's [config options](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#cronjob-v1beta1-batch).
You can check out more configuration examples on kube-janitor's own [README](https://github.com/hjacobs/kube-janitor#configuration) for more of the package's options.

Some of the default values are not specified in the `values.yaml` and are instead inherited the default from upstream.

| Parameter                | Description                                                  | Type    | Default                     |
| ------------------------ | ------------------------------------------------------------ | ------- | --------------------------- |
| `image.repository`       | Image repository                                             | string  | `hjacobs/kube-janitor`      |
| `image.tag`              | Image tag                                                    | string  | `19.9.0`                    |
| `image.pullPolicy`       | Image pull policy                                            | string  | `IfNotPresent`              |
| `cron.schedule`          | `CronJobSpec` for set the schedule of the CronJob resource   | string  | `*/5 * * * *`               |
| `cron.successfulJobsHistoryLimit` | `CronJobSpec` for number of successful jobs to keep | integer | `3` (k8s default)           |
| `cron.failedJobsHistoryLimit`     | `CronJobSpec` for number of failed jobs to keep     | integer | `3`                         |
| `cron.suspend`           | `CronJobSpec` for telling the controller whether to suspend subsequent jobs                         | boolean | false (k8s default)          |
| `kubejanitor.dryRun`     | Deployed in dry-run mode only. The job will print out what would be done, but does not make changes | boolean | false                        |
| `kubejanitor.debug`      | Run in debug-mode                                             | boolean | false                      |
| `kubejanitor.once`       | Run once and exit. This MUST BE true for running as a CronJob | boolnea | true                       |
| `kubejanitor.interval`   | Interval for rerunning the execution ONLY USE WHEN not running in CronJob ie. once is set to false  | string  | 30s (kube-janitor default)   |
| `kubejanitor.includeResources`  | List of k8s resource types to include, ex. `deployment,svc,ingress` | all resources (kube-janitor default)               | |
| `kubejanitor.excludeResources`  | List of k8s resource types to exclude                               | events,controllerrevisions (kube-janitor default)  | |
| `kubejanitor.includeNamespaces` | List of nameespaces to include                                      | all namespaces (kube-janitor default)              | |
| `kubejanitor.excludeNamespaces` | List of nameespaces to exclude                                      | kube-system (kube-janitor default)                 | |
| `resources`              | `PodSpec` for resource request and limit for CPU and memory  | map     | `{}`                        |
| `restartPolicy`          | `PodSpec` for pod restarting policy on failure               | string  | `OnFailure`                 |
| `nodeSelector`           | `PodSpec` for defining nodeSelector to deploy the pod on     | map     | `{}`                        |
| `affinity`               | `PodSpec` for defining affinity to deploy the pod on         | map     | `{}`                        |
| `tolerations`            | `PodSpec` for defining tolerations to deploy the pod on      | map     | `{}`                        |