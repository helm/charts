# metric-server

Metrics Server is a cluster-wide aggregator of resource usage data.

## Configuration

Parameter | Description | Default
--- | --- | ---
`rbac.create` | Enable Role-based authentication | `true`
`serviceAccount.create` | If `true`, create a new service account | `true`
`serviceAccount.name` | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | ``
`apiService.create` | Create the v1beta1.metrics.k8s.io API service | `true`
`image.repository` | Image repository | `gcr.io/google_containers/metrics-server-amd64`
`image.tag` | Image tag | `v0.3.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`args` | Command line arguments | `--logtostderr`
`resources` | CPU/Memory resource requests/limits. | `{}`
`tolerations` | List of node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`nodeSelector` | Node labels for pod assignment | `{}`
`affinity` | Node affinity | `{}`
