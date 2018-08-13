# Custom Metrics API Prometheus Adapter

An implementation of the custom.metrics.k8s.io API using Prometheus. See the [project website](https://github.com/DirectXMan12/k8s-prometheus-adapter/) for additional detail.

## Configuration

Parameter | Description | Default
--- | --- | ---
`affinity` | Node affinity | `{}`
`apiService.create` | Create the v1beta1.custom.metrics.k8s.io API service | `true`
`ca.generate` | If `true`, generate a self-signed CA certificate | `true`
`ca.crt` | The CA certificate to use as the serving CA. See [auth](https://github.com/kubernetes-incubator/apiserver-builder/blob/master/docs/concepts/auth.md) | ``
`ca.key` | The CA key to use with the serving CA. | ``
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `directxman12/k8s-prometheus-adapter-amd64`
`image.tag` | Image tag | `v0.2.1`
`nodeSelector` | Node labels for pod assignment | `{}`
`prometheusUrl` | The Prometheus service URL to query | `http://prometheus:9090/`
`rbac.create` | Enable Role-based access control | `true`
`resources` | CPU/Memory resource requests/limits. | `{}`
`rules.default` | If `true`, enable a set of default rules in the configmap | `true`
`rules.custom` | Custom configmap [rules](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config.md) to add | `{}`
`service.annotations` | Annotations to add to the service | `{}`
`service.port` | Service port to expose | `443`
`service.type` | Type of service to create | `ClusterIP`
`serviceAccount.create` | If `true`, create a new service account | `true`
`serviceAccount.name` | Service account name to use when `serviceAccount.create` is false | ``
`tolerations` | List of node taints to tolerate | `[]`
