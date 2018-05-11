# metric-server

Metrics Server is a cluster-wide aggregator of resource usage data.

## Configuration

Parameter | Description | Default
--- | --- | ---
`rbac.create` | Enable Role-based authentication | `true`
`rbac.serviceAccountName` | existing ServiceAccount to use (ignored if rbac.create=true) | `default`
`image.pullPolicy` | Image pull policy | `Always`
`image.repository` | Image repository | `gcr.io/google_containers/metrics-server-amd64`
`image.tag` | Image tag | `v0.2.1`
