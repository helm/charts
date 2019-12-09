# newrelic-infrastructure

## Chart Details

This chart will deploy the New Relic Infrastructure agent as a Daemonset.

## Configuration

| Parameter                       | Description                                                  | Default                    |
| ------------------------------- | ------------------------------------------------------------ | -------------------------- |
| `cluster`                       | The cluster name for the Kubernetes cluster.                 |                            |
| `licenseKey`                    | The [license key](https://docs.newrelic.com/docs/accounts/install-new-relic/account-setup/license-key) for your New Relic Account. This will be preferred configuration option if both `licenseKey` and `customSecret` are specified. | |
| `customSecretName`              | Name of the Secret object where the license key is stored    |                            |
| `customSecretLicenseKey`        | Key in the Secret object where the license key is stored.    |                            |
| `config`                        | A `newrelic.yml` file if you wish to provide.                |                            |
| `kubeStateMetricsUrl`           | If provided, the discovery process for kube-state-metrics endpoint won't be triggered. Example: http://172.17.0.3:8080 |
| `kubeStateMetricsTimeout`       | Timeout for accessing kube-state-metrics in milliseconds. If not set the newrelic default is 5000 | |
| `rbac.create`                   | Enable Role-based authentication                             | `true`                     |
| `rbac.pspEnabled`               | Enable pod security policy support                           | `false`                    |
| `privileged`                    | Enable privileged mode.                                      | `true`                     |
| `image.repository`              | The container to pull.                                       | `newrelic/infrastructure`  |
| `image.pullPolicy`              | The pull policy.                                             | `IfNotPresent`             |
| `image.tag`                     | The version of the container to pull.                        | `1.10.2`                   |
| `resources`                     | Any resources you wish to assign to the pod.                 | See Resources below        |
| `verboseLog`                    | Should the agent log verbosely. (Boolean)                    | `false`                    |
| `priorityClassName`             | Scheduling priority of the pod                               | `nil`                      |
| `nodeSelector`                  | Node label to use for scheduling                             | `nil`                      |
| `tolerations`                   | List of node taints to tolerate (requires Kubernetes >= 1.6) | See Tolerarions below      |
| `updateStrategy`                | Strategy for DaemonSet updates (requires Kubernetes >= 1.6)  | `RollingUpdate`            |
| `serviveAccount.create`         | If true, a service account would be created and assigned to the deployment | true |
| `serviveAccount.name`           | The service account to assign to the deployment. If `serviveAccount.create` is true then this name will be used when creating the service account | |

## Example

```sh
helm install stable/newrelic-infrastructure \
--set licenseKey=<enter_new_relic_license_key> \
--set cluster=my-k8s-cluster
```

## Globals

**Important:** global parameters have higher precedence than locals with the same name.

These are meant to be used when you are writing a chart with subcharts. It helps to avoid
setting values multiple times on different subcharts.

More information on globals and subcharts can be found at [Helm's official documentation](https://helm.sh/docs/topics/chart_template_guide/subcharts_and_globals/).

| Parameter                       |
| ------------------------------- |
| `global.cluster`                |
| `global.licenseKey`             |
| `global.customSecretName`       |
| `global.customSecretLicenseKey` |

## Resources

The default set of resources assigned to the pods is shown below:

```yaml
resources:
  limits:
    memory: 150M
  requests:
    cpu: 100m
    memory: 30M
```

## Tolerations

The default set of relations assigned to our daemonset is shown below:

```yaml
- operator: "Exists"
  effect: "NoSchedule"
- operator: "Exists"
  effect: "NoExecute"
```

# Config file

If you wish to provide your own `newrelic.yml` you may do so under `config`. There are a few notable exceptions you should be aware of. Some options have been omitted because they are handled either by variables, or a secret. They are `display_name`, `license_key`, `log_file` and `verbose`.
