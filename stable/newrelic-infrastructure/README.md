# newrelic-infra

## Chart Details

This chart will deploy the New Relic Infrastructure agent as a Daemonset.

## Configuration

| Parameter          | Description                                                  | Default                    |
| ------------------ | ------------------------------------------------------------ | -------------------------- |
| `config`           | A `newrelic-infra.yml` file if you wish to provide.          | ` `                        |
| `image.name`       | The container to pull.                                       | `newrelic/infrastructure`  |
| `image.pullPolicy` | The pull policy.                                             | `IfNotPresent`             |
| `image.tag`        | The version of the container to pull.                        | `0.0.11`                   |
| `licenseKey`       | The license key for your New Relic Account.                  | ``                         |
| `resources`        | Any resources you wish to assign to the pod.                 | See Resources below        |
| `verboseLog`       | Should the agent log verbosely. (Boolean)                    | `false`                    |
| `nodeSelector`     | Node label to use for scheduling                             | `nil`                      |
| `tolerations`      | List of node taints to tolerate (requires Kubernetes >= 1.6) | `nil`                      |

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

If you wish to provide your own `newrelic-infra.yml` you may do so under `config`. There are a few notable exceptions you should be aware of. Three options have been omitted because they are handled either by variables, or a secret. They are license_key, log_file and verbose.
