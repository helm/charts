# metric-server

Metrics Server is a cluster-wide aggregator of resource usage data.

## Requirements
* Kubernetes >1.8

## References
* https://kubernetes.io/docs/tasks/debug-application-cluster/core-metrics-pipeline/#metrics-server
* https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/resource-metrics-api.md#endpoints

## Configuration

Parameter | Description | Default
--- | --- | ---
`rbac.create` | Enable Role-based authentication | `true`
`serviceAccount.create` | If `true`, create a new service account | `true`
`serviceAccount.name` | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | ``
`apiService.create` | Create the v1beta1.metrics.k8s.io API service | `true`
`image.repository` | Image repository | `gcr.io/google_containers/metrics-server-amd64`
`image.tag` | Image tag | `v0.2.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.custom_command_args` | Additionally command args | You can pass different values like ```kubeletPort``` to change the port. Example: ```?useServiceAccount=true&kubeletHttps=true&kubeletPort=10250&insecure=true```. To use that you need to enable kubelet_authentication_token_webhook. Solve the issue when you get that error: the server could not find the requested resource (get services http:heapster:)
