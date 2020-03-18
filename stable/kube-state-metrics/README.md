# kube-state-metrics Helm Chart

* Installs the [kube-state-metrics agent](https://github.com/kubernetes/kube-state-metrics).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/kube-state-metrics
```

## Configuration

| Parameter                                    | Description                                                                           | Default                                    |
|:---------------------------------------------|:--------------------------------------------------------------------------------------|:-------------------------------------------|
| `image.repository`                           | The image repository to pull from                                                     | quay.io/coreos/kube-state-metrics          |
| `image.tag`                                  | The image tag to pull from                                                            | `v1.9.5`                                   |
| `image.pullPolicy`                           | Image pull policy                                                                     | `IfNotPresent`                             |
| `replicas`                                   | Number of replicas                                                                    | `1`                                        |
| `autosharding.enabled`                       | Set to `true` to automatically shard data across `replicas` pods. EXPERIMENTAL        | `false`                                    |
| `service.port`                               | The port of the container                                                             | `8080`                                     |
| `service.annotations`                        | Annotations to be added to the service                                                | `{}`                                       |
| `customLabels`                               | Custom labels to apply to service, deployment and pods                                | `{}`                                       |
| `hostNetwork`                                | Whether or not to use the host network                                                | `false`                                    |
| `prometheusScrape`                           | Whether or not enable prom scrape                                                     | `true`                                     |
| `rbac.create`                                | If true, create & use RBAC resources                                                  | `true`                                     |
| `serviceAccount.create`                      | If true, create & use serviceAccount                                                  | `true`                                     |
| `serviceAccount.name`                        | If not set & create is true, use template fullname                                    |                                            |
| `serviceAccount.imagePullSecrets`            | Specify image pull secrets field                                                      | `[]`                                       |
| `podSecurityPolicy.enabled`                  | If true, create & use PodSecurityPolicy resources. Note that related RBACs are created only if `rbac.enabled` is `true. | `false`  |
| `podSecurityPolicy.annotations`              | Specify pod annotations in the pod security policy                                    | {}                                         |
| `securityContext.enabled`                    | Enable security context                                                               | `true`                                     |
| `securityContext.fsGroup`                    | Group ID for the container                                                            | `65534`                                    |
| `securityContext.runAsUser`                  | User ID for the container                                                             | `65534`                                    |
| `priorityClassName`                          | Name of Priority Class to assign pods                                                 | `nil`                                      |
| `nodeSelector`                               | Node labels for pod assignment                                                        | {}                                         |
| `affinity`                                   | Affinity settings for pod assignment                                                  | {}                                         |
| `tolerations`                                | Tolerations for pod assignment                                                        | []                                         |
| `podAnnotations`                             | Annotations to be added to the pod                                                    | {}                                         |
| `podDisruptionBudget`                        | Optional PodDisruptionBudget                                                          | {}                                         |
| `resources`                                  | kube-state-metrics resource requests and limits                                       | {}                                         |
| `collectors.certificatesigningrequests`      | Enable the certificatesigningrequests collector.                                      | `true`                                     |
| `collectors.configmaps`                      | Enable the configmaps collector.                                                      | `true`                                     |
| `collectors.cronjobs`                        | Enable the cronjobs collector.                                                        | `true`                                     |
| `collectors.daemonsets`                      | Enable the daemonsets collector.                                                      | `true`                                     |
| `collectors.deployments`                     | Enable the deployments collector.                                                     | `true`                                     |
| `collectors.endpoints`                       | Enable the endpoints collector.                                                       | `true`                                     |
| `collectors.horizontalpodautoscalers`        | Enable the horizontalpodautoscalers collector.                                        | `true`                                     |
| `collectors.ingresses`                       | Enable the ingresses collector.                                                       | `true`                                     |
| `collectors.jobs`                            | Enable the jobs collector.                                                            | `true`                                     |
| `collectors.limitranges`                     | Enable the limitranges collector.                                                     | `true`                                     |
| `collectors.mutatingwebhookconfigurations`   | Enable the mutatingwebhookconfigurations collector.                                   | `true`                                     |
| `collectors.namespaces`                      | Enable the namespaces collector.                                                      | `true`                                     |
| `collectors.networkpolicies`                 | Enable the networkpolicies collector.                                                 | `true`                                     |
| `collectors.nodes`                           | Enable the nodes collector.                                                           | `true`                                     |
| `collectors.persistentvolumeclaims`          | Enable the persistentvolumeclaims collector.                                          | `true`                                     |
| `collectors.persistentvolumes`               | Enable the persistentvolumes collector.                                               | `true`                                     |
| `collectors.poddisruptionbudgets`            | Enable the poddisruptionbudgets collector.                                            | `true`                                     |
| `collectors.pods`                            | Enable the pods collector.                                                            | `true`                                     |
| `collectors.replicasets`                     | Enable the replicasets collector.                                                     | `true`                                     |
| `collectors.replicationcontrollers`          | Enable the replicationcontrollers collector.                                          | `true`                                     |
| `collectors.resourcequotas`                  | Enable the resourcequotas collector.                                                  | `true`                                     |
| `collectors.secrets`                         | Enable the secrets collector.                                                         | `true`                                     |
| `collectors.services`                        | Enable the services collector.                                                        | `true`                                     |
| `collectors.statefulsets`                    | Enable the statefulsets collector.                                                    | `true`                                     |
| `collectors.storageclasses`                  | Enable the storageclasses collector.                                                  | `true`                                     |
| `collectors.validatingwebhookconfigurations` | Enable the validatingwebhookconfigurations collector.                                 | `true`                                     |
| `collectors.verticalpodautoscalers`          | Enable the verticalpodautoscalers collector.                                          | `true`                                     |
| `collectors.volumeattachments`               | Enable the volumeattachments collector.                                               | `true`                                     |
| `prometheus.monitor.enabled`                 | Set this to `true` to create ServiceMonitor for Prometheus operator                   | `false`                                    |
| `prometheus.monitor.additionalLabels`        | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`                                       |
| `prometheus.monitor.namespace`               | Namespace where servicemonitor resource should be created                             | `the same namespace as kube-state-metrics` |
| `prometheus.monitor.honorLabels`             | Honor metric labels                                                                   | `false`                                    |
| `namespaceOverride`                          | Override the deployment namespace                                                     | `""` (`Release.Namespace`)                 |
