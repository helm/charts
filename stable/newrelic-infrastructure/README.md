# newrelic-infrastructure

## Chart Details

This chart will deploy the New Relic Infrastructure agent as a Daemonset.

## Configuration

| Parameter                 | Description                                                  | Default                    |
| ------------------------- | ------------------------------------------------------------ | -------------------------- |
| `cluster`                 | The cluster name for the Kubernetes cluster.                 |                          |
| `licenseKey`              | The [license key](https://docs.newrelic.com/docs/accounts/install-new-relic/account-setup/license-key)  for your New Relic Account. | |
| `config`                  | A `newrelic.yml` file if you wish to provide.                |                         |
| `kubeStateMetricsUrl`     | If provided, the discovery process for kube-state-metrics endpoint won't be triggered. Example: http://172.17.0.3:8080 |
| `kubeStateMetricsTimeout` | Timeout for accessing kube-state-metrics in milliseconds. If not set the newrelic default is 5000 | |
| `image.name`              | The container to pull.                                       | `newrelic/infrastructure`  |
| `image.pullPolicy`        | The pull policy.                                             | `IfNotPresent`             |
| `image.tag`               | The version of the container to pull.                        | `1.2.0`            |
| `resources`               | Any resources you wish to assign to the pod.                 | See Resources below        |
| `verboseLog`              | Should the agent log verbosely. (Boolean)                    | `false`                    |
| `nodeSelector`            | Node label to use for scheduling                             | `nil`                      |
| `tolerations`             | List of node taints to tolerate (requires Kubernetes >= 1.6) | `nil`                      |
| `updateStrategy`          | Strategy for DaemonSet updates (requires Kubernetes >= 1.6)  | `RollingUpdate`            |

## Example

```sh
helm install stable/newrelic-infrastructure \
--set licenseKey=<enter_new_relic_license_key> \
--set cluster=my-k8s-cluster
```

## Resources

The default set of resources assigned to the pods is shown below:

    resources:
      limits:
        cpu: 100m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi

# Config file

If you wish to provide your own `newrelic.yml` you may do so under `config`. There are a few notable exceptions you should be aware of. Three options have been omitted because they are handled either by variables, or a secret. They are license_key, log_file and verbose.
