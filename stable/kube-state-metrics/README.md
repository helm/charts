# kube-state-metrics Helm Chart

* Installs the [kube-state-metrics agent](https://github.com/kubernetes/kube-state-metrics).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/kube-state-metrics
```

## Configuration

| Parameter                             | Description                                             | Default                                     |
|---------------------------------------|---------------------------------------------------------|---------------------------------------------|
| `image.repository`                    | The image repository to pull from                       | k8s.gcr.io/kube-state-metrics               |
| `image.tag`                           | The image tag to pull from                              | `v1.5.0`                                    |
| `image.pullPolicy`                    | Image pull policy                                       | IfNotPresent                                |
| `replicas`                            | Number of replicas                                      | 1                                           |
| `service.port`                        | The port of the container                               | 8080                                        |
| `prometheusScrape`                    | Whether or not enable prom scrape                       | true                                        |
| `rbac.create`                         | If true, create & use RBAC resources                    | true                                        |
| `serviceAccount.create`               | If true, and rbac true, create & use serviceAccount     | true                                        |
| `serviceAccount.name`                 | If not set & create is true, use template fullname      |                                             |
| `serviceAccount.imagePullSecrets`     | Specify image pull secrets field                        | `[]`                                        |
| `podSecurityPolicy.enabled`           | If true, create & use PodSecurityPolicy resources       | false                                       |
| `podSecurityPolicy.annotations`       | Specify pod annotations in the pod security policy      | {}                                          |
| `securityContext.enabled`             | Enable security context                                 | `true`                                      |
| `securityContext.fsGroup`             | Group ID for the container                              | `65534`                                     |
| `securityContext.runAsUser`           | User ID for the container                               | `65534`                                     |
| `priorityClassName`                   | Name of Priority Class to assign pods                   | `nil`                                       |
| `nodeSelector`                        | Node labels for pod assignment                          | {}                                          |
| `tolerations`                         | Tolerations for pod assignment	                      | []                                          |
| `podAnnotations`                      | Annotations to be added to the pod                      | {}                                          |
| `resources`                           | kube-state-metrics resource requests and limits         | {}                                          |
| `collectors.configmaps`               | Enable the configmaps collector.                        | true                                        |
| `collectors.cronjobs`                 | Enable the cronjobs collector.                          | true                                        |
| `collectors.daemonsets`               | Enable the daemonsets collector.                        | true                                        |
| `collectors.deployments`              | Enable the deployments collector.                       | true                                        |
| `collectors.endpoints`                | Enable the endpoints collector.                         | true                                        |
| `collectors.horizontalpodautoscalers` | Enable the horizontalpodautoscalers collector.          | true                                        |
| `collectors.jobs`                     | Enable the jobs collector.                              | true                                        |
| `collectors.limitranges`              | Enable the limitranges collector.                       | true                                        |
| `collectors.namespaces`               | Enable the namespaces collector.                        | true                                        |
| `collectors.nodes`                    | Enable the nodes collector.                             | true                                        |
| `collectors.persistentvolumeclaims`   | Enable the persistentvolumeclaims collector.            | true                                        |
| `collectors.persistentvolumes`        | Enable the persistentvolumes collector.                 | true                                        |
| `collectors.poddisruptionbudgets`     | Enable the poddisruptionbudgets collector.              | true                                        |
| `collectors.pods`                     | Enable the pods collector.                              | true                                        |
| `collectors.replicasets`              | Enable the replicasets collector.                       | true                                        |
| `collectors.replicationcontrollers`   | Enable the replicationcontrollers collector.            | true                                        |
| `collectors.resourcequotas`           | Enable the resourcequotas collector.                    | true                                        |
| `collectors.secrets`                  | Enable the secrets collector.                           | true                                        |
| `collectors.services`                 | Enable the services collector.                          | true                                        |
| `collectors.statefulsets`             | Enable the statefulsets collector.                      | true                                        |
