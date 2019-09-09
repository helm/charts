# nri-metadata-injection

## Chart Details

This chart will deploy the [New Relic Infrastructure metadata injection webhook][1].

## Configuration

| Parameter                     | Description                                                  | Default                    |
| ----------------------------- | ------------------------------------------------------------ | -------------------------- |
| `cluster`                     | The cluster name for the Kubernetes cluster.                 |                            |
| `injectOnlyLabeledNamespaces` | Limit the injection of metadata only to specific namespaces that match the label `newrelic-metadata-injection: enabled`. | false |
| `image.repository`            | The container to pull.                                       | `newrelic/k8s-metadata-injection`   |
| `image.pullPolicy`            | The pull policy.                                             | `IfNotPresent`                      |
| `image.tag`                   | The version of the container to pull.                        | `1.1.0`                             |
| `imageJob.repository`         | The job container to pull.                                   | `newrelic/k8s-webhook-cert-manager` |
| `imageJob.pullPolicy`         | The job pull policy.                                         | `IfNotPresent`                      |
| `imageJob.tag`                | The job version of the container to pull.                    | `1.1.0`                             |
| `resources`                   | Any resources you wish to assign to the pod.                 | See Resources below                 |
| `serviveAccount.create`       | If true a service account would be created and assigned for the webhook and the job. | `true` |
| `serviveAccount.name`         | The service account to assign to the webhook and the job. If `serviveAccount.create` is true then this name will be used when creating the service account; if this value is not set or it evaluates to false, then when creating the account the returned value from the template `nri-metadata-injection.fullname` will be used as name. | |
| `customTLSCertificate`        | Use custom TLS certificate. Setting this options means that you will have to do some post install work as detailed in the *Manage custom certificates* section of the [official docs][1]. | `false` |
| `nodeSelector`                | Node label to use for scheduling                             | `{}`                                |
| `tolerations`                 | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]`                                |
| `affinity`                    | Node affinity to use for scheduling                          | `{}`                                |

## Example

```sh
helm install stable/nri-mutation-webhook --set cluster=my_cluster_name
```

## Resources

The default set of resources assigned to the pods is shown below:

    resources:
      limits:
        memory: 80M
      requests:
        cpu: 100m
        memory: 30M

[1]: https://docs.newrelic.com/docs/integrations/kubernetes-integration/link-your-applications/link-your-applications-kubernetes#configure-injection
