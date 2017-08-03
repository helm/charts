# Kubernetes-vault Helm Chart

## Prerequisites Details
* Working Vault cluster configured per instructions found [here](https://github.com/Boostport/kubernetes-vault/blob/master/quick-start.md#22-set-up-the-root-certificate-authority)
* Vault server API is available from Kubernetes pods
* A Vault token created for the AppRole backend
* Kubernetes 1.5

## Chart Details
This chart will do the following:

* Allows pods to automatically receive a Vault token using Vault's [AppRole auth backend](https://www.vaultproject.io/docs/auth/approle.html).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/kubernetes-vault --set vault.address=$your_vault_server --set vault.token=$your_vault_token
```

## Configuration

The following tables lists the configurable parameters of the consul chart and their default values.

| Parameter                   | Description                                             | Default                                                    |
| --------------------------  | ----------------------------------                      | ---------------------------------------------------------- |
| `image`                     | Container image name                                    | `boostport/kubernetes-vault`                               |
| `imageTag`                  | Container image tag                                     | `0.4.8`                                                    |
| `imagePullPolicy`           | Container pull policy                                   | `Always`                                                   |
| `replicaCount`              | k8s pod replicas                                        | `3`                                                        |
| `app`                       | k8s selector key                                        | `kubernetes-vault`                                         |
| `service.dummyPort`         | Dummy port to register pod with API. Not actually used. | `80`                                                       |
| `vault.address`             | URL of Vault server                                     | `http://vault:8200`                                        |
| `vault.token`               | Token generated from AppRole backend                    | `change-this-value`                                        |
| `vault.vaultCertBackend`    | Name of CA backend used in Vault                        | `intermediate-ca`                                          |
| `vault.vaultCertRole`       | Name of cert role used in Vault                         | `kubernetes-vault`                                         |
| `resources.limits.cpu`      | CPU limit                                               | `100m`                                                     |
| `resources.limits.memory`   | Memory limit                                            | `128Mi`                                                    |
| `resources.requests.cpu`    | CPU resource request                                    | `100m`                                                     |
| `resources.requests.memory` | Memory resource request                                 | `128Mi`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/kubernetes-vault
```
