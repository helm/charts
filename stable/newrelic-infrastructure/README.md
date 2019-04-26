# newrelic-infrastructure

## Chart Details

This chart will deploy the New Relic Infrastructure agent as a Daemonset.

## Prerequisites
- New Relic license key (see [Support](#support) below for details)
- [kube-state-metrics](https://github.com/helm/charts/tree/master/stable/kube-state-metrics) must be installed and working

### `kube-state-metrics` dependency
A default installation is all that is required for `kube-state-metrics`. Execute this command: 

```
helm install stable/kube-state-metrics
```

If you need to override default values, use this command to see information about the chart:

```
helm inspect stable/kube-state-metrics
```

### Pod Security Policies

newrelic-infrastructure containers need to mount host volumes, and needs to run as root. This chart requires a PodSecurityPolicy 
(with host volume and root access) to be bound to the target namespace. 
If the `default` PodSecurityPolicy on your namespace is not restrictive then this step is not needed.

This chart can create the kubernetes objects necessary to allow this access. Be sure to pass the arguments 
`--set rbac.create=true` and `--set rbac.pspEnabled=true` during chart installation. See [Configuration](#configuration) below.

### Image Security Policies

If the cluster has image security policies enforced, `newrelic/infrastructure-k8s` and `k8s.gcr.io/kube-state-metrics` docker images should be added to it.

For example on [IBM Private Cloud (ICP)](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.2/manage_images/image_security.html):

You can edit the existing policy (assuming you are a cluster administrator) using:
```
kubectl edit clusterimagepolicy ibmcloud-default-cluster-image-policy
```

Example yaml file:
```
apiVersion: securityenforcement.admission.cloud.ibm.com/v1beta1
kind: ClusterImagePolicy
metadata:
name: ibmcloud-default-cluster-image-policy
spec:
 repositories:
   - name: docker.io/newrelic/infrastructure-k8s:*
   - name: k8s.gcr.io/kube-state-metrics:*
```

### Creating a Secret
The newrelic-infrastructure chart requires that you store your New Relic license key inside a kubernetes secret using the key name `license`. 
We suggest that you name the secret with the name of your release followed by `newrelic-infrastructure-config`, separated with a dash.
For example if you plan to create a deployment with release name `my-release` then use this command (replaceing the X's with your 
New Relic license key and substituting `namespace_name` with the namespace you want to use):

```
kubectl create secret generic my-release-newrelic-infrastructure-config \
  --from-literal='license=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --namespace namespace_name
```

When installing the chart you must refer to the name of the secret you have created. In our previous example that name is 
`my-release-newrelic-infrastructure-config`.

## Installing the Chart

To install the chart with the release name `my-release`, with the required parameters `cluster` and `licenseSecret`, and creating
the appropriate kubernetes security settings to run as root and allow hostPath volumes:

```sh
helm install --name my-release community/newrelic-infrastructure \
--set licenseSecret=<enter_kubernetes_secret_name_that_contains_new_relic_license_key> \
--set cluster=mycluster \
--set rbac.create=true \
--set rbac.pspEnabled=true
```

For other configuration options see [Configuration](#configuration) below.

## Configuration

| Parameter                 | Description                                                  | Default                    |
| ------------------------- | ------------------------------------------------------------ | -------------------------- |
| `cluster`                 | *Required* Kubernetes cluster name.                          | `nil`                      |
| `licenseSecret`           | *Required* The name of the kubernetes secret which contains the [license key](https://docs.newrelic.com/docs/accounts/install-new-relic/account-setup/license-key)  for your New Relic Account. | `nil` |
| `config`                  | An optional `newrelic-infra.yml` file.                       | `nil`                      |
| `kubeStateMetricsUrl`     | If provided, the discovery process for kube-state-metrics endpoint won't be triggered. Example: http://172.17.0.3:8080 | `nil` |
| `kubeStateMetricsTimeout` | Timeout for accessing kube-state-metrics in milliseconds. If not set the newrelic default is 5000 | `nil` |
| `rbac.create`             | Enable Role-based authentication (Boolean)                   | `true`                     |
| `rbac.pspEnabled`         | Enable pod security policy support (Boolean)                 | `false`                    |
| `image.repository`        | The container to pull.                                       | `newrelic/infrastructure-k8s`  |
| `image.pullPolicy`        | The pull policy.                                             | `IfNotPresent`             |
| `image.tag`               | The version of the container to pull.                        | `1.7.0`            |
| `resources`               | Any resources you wish to assign to the pod.                 | See Resources below        |
| `verboseLog`              | Should the agent log verbosely. (Boolean)                    | `false`                    |
| `nodeSelector`            | Node label(s) to use for scheduling (Map)                    | `{}` (i.e. empty map)      |
| `tolerations`             | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]` (i.e. empty list)     |
| `updateStrategy`          | Strategy for DaemonSet updates (requires Kubernetes >= 1.6)  | `RollingUpdate`            |
| `podAnnotations`          | Optional key value non-identifying metadata used in daemonset | `nil`                     |
| `podLabels`               | Optional key value identifying metadata used in daemonset    | `nil`                      |
| `logFile`                 | This can be set to a log file path                           | `nil`                      |
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created         | `true`                     |
| `serviceAccount.name`     | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `nil` |

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

# Support

License key documentation: https://docs.newrelic.com/docs/accounts/install-new-relic/account-setup/license-key