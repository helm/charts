# metrics-server

[Metrics Server](https://github.com/kubernetes-incubator/metrics-server) is a cluster-wide aggregator of resource usage data. Resource metrics are used by components like `kubectl top` and the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale) to scale workloads. To autoscale based upon a custom metric, see the [Prometheus Adapter chart](https://github.com/helm/charts/blob/master/stable/prometheus-adapter).

## To install the chart with release name `my-release`:
```bash
$ helm install --name my-release stable/metrics-server
```
Helm 3:
```bash
$ helm install my-release stable/metrics-server
```
## Configuration

Parameter | Description | Default
--- | --- | ---
`rbac.create` | Enable Role-based authentication | `true`
`rbac.pspEnabled` | Enable pod security policy support | `false`
`serviceAccount.create` | If `true`, create a new service account | `true`
`serviceAccount.name` | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | ``
`apiService.create` | Create the v1beta1.metrics.k8s.io API service | `true`
`hostNetwork.enabled` | Enable hostNetwork mode | `false`
`image.repository` | Image repository | `gcr.io/google_containers/metrics-server-amd64`
`image.tag` | Image tag | `v0.3.2`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`imagePullSecrets` | Image pull secrets | `[]`
`args` | Command line arguments | `[]`
`resources` | CPU/Memory resource requests/limits. | `{}`
`tolerations` | List of node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`nodeSelector` | Node labels for pod assignment | `{}`
`affinity` | Node affinity | `{}`
`replicas` | Number of replicas | `1`
`extraVolumeMounts` | Ability to provide volume mounts to the pod | `[]`
`extraVolumes` | Ability to provide volumes to the pod | `[]`
`livenessProbe` | Container liveness probe | See values.yaml
`podAnnotations` | Annotations to be added to pods | `{}`
`priorityClassName` | Pod priority class | `""`
`readinessProbe` | Container readiness probe | See values.yaml
`service.annotations` | Annotations to add to the service | `{}`
`service.labels` | Labels to be added to the metrics-server service | `{}`
`service.port` | Service port to expose | `443`
`service.type` | Type of service to create | `ClusterIP`
`podDisruptionBudget.enabled` | Create a PodDisruptionBudget | `false`
`podDisruptionBudget.minAvailable` | Minimum available instances; ignored if there is no PodDisruptionBudget |
`podDisruptionBudget.maxUnavailable` | Maximum unavailable instances; ignored if there is no PodDisruptionBudget |

## Uninstalling the chart
In order to delete `metrics-server` chart you need to delete its apiservice first:
```bash
$ kubectl delete apiservice v1beta1.metrics.k8s.io
```
Then it is safe to delete charts resources:
```bash
$ helm delete metrics-server
```
