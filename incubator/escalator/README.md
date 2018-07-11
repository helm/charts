# Escalator

[Escalator](https://github.com/atlassian/escalator) is a batch or job optimized horizontal autoscaler for Kubernetes

## Prerequisites

- Kubernetes cluster v1.8+ 
- Escalator currently only supports scaling AWS Auto Scaling Groups

## Configuration

See the [Escalator docs](https://github.com/atlassian/escalator/blob/master/docs/README.md) for detailed documentation
about the configuration, operation, and behavior of Escalator.

The following table lists the configurable parameters of the Concourse chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `affinity` | node/pod affinities | `{}`
| `aws.roleArn` | AWS role arn to assume. Only usable when using the aws cloud provider. | None
| `aws.region` | AWS region your autoscaling groups are in. | `us-east-1`
| `cloudProvider` | Cloud provider to use. Currently, only aws is available | `aws`
| `dryMode` | Log the actions that Escalator will perform without actually running them | `true`
| `image.pullPolicy` | Image pull policy | `IfNotPresent`
| `image.repository` | Image repository | `atlassian/escalator`
| `image.tag` | Image tag | `v1.0.0`
| `ingress.path` | Ingress path | `/`
| `ingress.enabled` | Enables Ingress | `false`
| `ingress.annotations` | Ingress annotations | `{}`
| `ingress.hosts` | Ingress accepted hostnames | `[]`
| `ingress.tls` | Ingress TLS configuration | `[]`
| `kubeConfig.enabled` | Use a custom kubeConfig when querying the API. Only necessary if autoscaling a different cluster than the one in which Escalator is deployed. | `false`
| `kubeConfig.secretKey` | Secret key with contents of custom kubeConfig | None
| `kubeConfig.secretName` | Kubernetes Secret with a custom kubeConfig | None
| `logFormat` | Format of logging output (json, ascii) | `ascii`
| `logLevel` | Log level (4 for info, 5 for debug) | `4`
| `nodeSelector` | node labels for pod assignment | `{}`
| `nodeGroups` | Configuration for node groups to autoscale | `[]`
| `podAnnotations` | annotations to add to each pod | `{}`
| `rbac.create` | Specifies whether RBAC resources should be created. | `true`
| `replicaCount` | desired number of pods | `1`
| `resources` | pod resource requests & limits | `{}`
| `scanInterval` | How often cluster is reevaluated for scale up or down | `60s`
| `service.annotations` | Kubernetes service annotations | `{}`
| `service.port` | port for the service | `80`
| `service.type` | type of service | `ClusterIP`
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created. | `true`
| `serviceAccount.name` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template. | Nothing
| `tolerations` | List of node taints to tolerate | `[]`

### Node Groups

The `nodeGroups` parameter takes an array of node groups to scale with escalator, and must be provided for escalator
to perform any autoscaling. See the [official docs](https://github.com/atlassian/escalator/blob/master/docs/configuration/nodegroup.md)
for an up-to-date list of parameters and their descriptions. For even more detail, see the [advanced configuration](https://github.com/atlassian/escalator/blob/master/docs/configuration/advanced-configuration.md).

### Dry Mode

By default, Escalator will not perform any autoscaling. Set `dryMode: false` to enable autoscaling.

## Metrics

Metrics are available at the `/metrics`. See the [metrics docs](https://github.com/atlassian/escalator/blob/master/docs/metrics.md)
for more information.
