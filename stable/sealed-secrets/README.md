# Sealed Secrets

This chart contains the resources to use [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets).

## Prerequisites

<!-- TODO 1.7 is possible using a ThirdPartyResoure. If there is demand integrate this? -->
* Kubernetes >=1.8

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --namespace kube-system --name my-release stable/sealed-secrets
```

The command deploys a controller and [CRD](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/) for sealed secrets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete [--purge] my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

| Parameter | Description | Default |
|----------:|:------------|:--------|
| **rbacEnabled** | `true` if rbac is enabled on your cluster. Roles and bindings will be created if this is `true`, they will not if it is `false` | true |
| **serviceAccount.create** | Whether to create a service account or not | true |
| **serviceAccount.name** | The name of the service account to create or use | "sealed-secrets-controller" |
| **secretName** | The name of the TLS secret containing the key used to encrypt secrets | "sealed-secrets-key" |

- In the case that **rbacEnabled** is `false` a service account will not be created or used regardless of the vaue of **serviceAccount.create**.
- In the case that **serviceAccount.create** is `false` and **rbacEnabled** is `true` it is expected for a service account with the name **serviceAccount.name** to exist _in the same namespace as this chart_ before installation.
- If **serviceAccount.create** is `true` there cannot be an existing service account with the name **serviceAccount.name**.
- If a secret with name **secretName** does not exist _in the same namespace as this chart_, then on install one will be created. If a secret already exists with this name the keys inside will be used.
