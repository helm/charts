# aad-pod-identity

[aad-pod-identity](https://github.com/Azure/aad-pod-identity) enables Kubernetes applications to access cloud resources securely with [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/) (AAD).

## TL;DR:

```console
$ helm install stable/aad-pod-identity -f values.yaml
```

## Introduction

A simple [helm](https://helm.sh/) chart for setting up the components needed to use [Azure Active Directory Pod Identity](https://github.com/Azure/aad-pod-identity) in Kubernetes.

This helm chart will deploy the following resources:
* AzureIdentity `CustomResourceDefinition`
* AzureIdentityBinding `CustomResourceDefinition`
* AzureAssignedIdentity `CustomResourceDefinition`
* AzurePodIdentityException `CustomResourceDefinition`
* AzureIdentity instance (optional)
* AzureIdentityBinding instance (optional)
* Managed Identity Controller (MIC) `Deployment`
* Node Managed Identity (NMI) `DaemonSet`

## Getting Started
The following steps will help you create a new Azure identity ([Managed Service Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) or [Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals)) and assign it to pods running in your Kubernetes cluster.

### Prerequisites
* [Azure Subscription](https://azure.microsoft.com/)
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) or [AKS Engine](https://github.com/Azure/aks-engine) deployment
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (authenticated to your Kubernetes cluster)
* [Helm v1.10+](https://github.com/helm/helm)
* [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [git](https://git-scm.com/downloads)

<details>
<summary><strong>[Optional] Creating user identity</strong></summary>

1. Create a new [Azure User Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) using the Azure CLI:
> __NOTE:__ It's simpler to use the same resource group as your Kubernetes nodes are deployed in. For AKS this is the MC_* resource group. If you can't use the same resource group, you'll need to grant the Kubernetes cluster's service principal the "Managed Identity Operator" role.
```shell
az identity create -g <resource-group> -n <id-name>
```

2. Assign your newly created identity the appropriate role to the resource you want to access.
</details>


#### Installing charts

* If you need the azure identity and azure identity binding resources also to be created as part of the chart installation, update the values.yml to enable the azureIdentity and replace the resourceID, clientID using the values for the user identity.
* If you need the aad-pod-identity deployment to use it's own service principal credentials instead of the cluster service prinicipal '/etc/kubernetes/azure.json`, then uncomment this section and add the appropriate values for each required field.

```
adminsecret:
  cloud: <cloud environment name>
  subscriptionID: <subscription id>
  resourceGroup: <cluster resource group>
  vmType: <`standard` for normal virtual machine nodes, and `vmss` for cluster deployed with a virtual machine scale set>
  tenantID: <service principal tenant id>
  clientID: <service principal client id>
  clientSecret: <service principal client secret>
```

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/aad-pod-identity
```

Deploy your application to Kubernetes. The application can use [ADAL](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-authentication-libraries) to request a token from the MSI endpoint as usual. If you do not currently have such an application, a demo application is available [here](https://github.com/Azure/aad-pod-identity#demo-app). If you do use the demo application, please update the `deployment.yaml` with the appropriate subscription ID, client ID and resource group name. Also make sure the selector you defined in your `AzureIdentityBinding` matches the `aadpodidbinding` label on the deployment.

## Uninstalling the Chart

To uninstall/delete the last deployment:

```console
$ helm ls
$ helm delete [last deployment]
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

CRDs created by this chart are not removed by default and should be manually cleaned up:
```bash
kubectl delete crd azureassignedidentities.aadpodidentity.k8s.io
kubectl delete crd azureidentities.aadpodidentity.k8s.io
kubectl delete crd azureidentitybindings.aadpodidentity.k8s.io
kubectl delete crd azurepodidentityexceptions.aadpodidentity.k8s.io
```

## Known Issues

__Error Redeploying Chart__

If you have previously installed the helm chart, you may come across the following error message:
```shell
Error: object is being deleted: customresourcedefinitions.apiextensions.k8s.io ? "azureassignedidentities.aadpodidentity.k8s.io" already exists
```
This is because helm doesn't actively manage the `CustomResourceDefinition` resources that the chart created. The full discussion concerning this issue is available [here](https://github.com/helm/helm/issues/2994). We are using helm's [crd-install hooks](https://docs.helm.sh/developing_charts#defining-a-crd-with-the-crd-install-hook) to provision the `CustomResourceDefintion` resources before the rest of the chart is verified and deployed. We also use `hook-delete-policy` to try and clean down the resources before the next helm release is applied. Unfortunately, as CRD deletion is slow it doesn't appear to resolve the issue. This issue is tracked [here](https://github.com/helm/helm/issues/4440). The easiest solution is to manually delete the `CustomerResourceDefintion` resources or setup a job to do so.

## Configuration

The following tables list the configurable parameters of the acs-engine-autoscaler chart and their default values.

| Parameter                       | Description                                                                                                                                               | Default                                  |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `image.repository`              | Image repository                                                                                                                                          | `mcr.microsoft.com/k8s/aad-pod-identity` |
| `image.pullPolicy`              | Image pull policy                                                                                                                                         | `Always`                                 |
| `forceNameSpaced`               | By default, AAD Pod Identity matches pods to identities across namespaces. To match only pods in the namespace containing AzureIdentity set this to true. | `false`                                  |
| `adminsecret.cloud`             | Azure cloud environment name                                                                                                                              | ` `                                      |
| `adminsecret.subscriptionID`    | Azure subscription ID                                                                                                                                     | ` `                                      |
| `adminsecret.resourceGroup`     | Azure resource group                                                                                                                                      | ` `                                      |
| `adminsecret.vmType`            | `standard` for normal virtual machine nodes, and `vmss` for cluster deployed with a virtual machine scale set                                             | ` `                                      |
| `adminsecret.tenantID`          | Azure service principal tenantID                                                                                                                          | ` `                                      |
| `adminsecret.clientID`          | Azure service principal clientID                                                                                                                          | ` `                                      |
| `adminsecret.clientSecret`      | Azure service principal clientSecret                                                                                                                      | ` `                                      |
| `mic.image`                     | MIC image name                                                                                                                                            | `mic`                                    |
| `mic.tag`                       | MIC image tag                                                                                                                                             | `1.5-rc2`                                |
| `mic.logVerbosity`              | Log level. Uses V logs (glog)                                                                                                                             | `0`                                      |
| `mic.resources`                 | Resource limit for MIC                                                                                                                                    | `{}`                                     |
| `mic.tolerations`               | Affinity settings                                                                                                                                         | `{}`                                     |
| `mic.affinity`                  | List of node taints to tolerate                                                                                                                           | `[]`                                     |
| `nmi.image`                     | NMI image name                                                                                                                                            | `nmi`                                    |
| `nmi.tag`                       | NMI image tag                                                                                                                                             | `1.5-rc2`                                |
| `nmi.resources`                 | Resource limit for NMI                                                                                                                                    | `{}`                                     |
| `nmi.tolerations`               | Affinity settings                                                                                                                                         | `{}`                                     |
| `nmi.affinity`                  | List of node taints to tolerate                                                                                                                           | `[]`                                     |
| `rbac.enabled`                  | Create and use RBAC for all aad-pod-identity resources                                                                                                    | `true`                                   |
| `azureIdentity.enabled`         | Create azure identity and azure identity binding resource                                                                                                 | `false`                                  |
| `azureIdentity.name`            | Azure identity resource name                                                                                                                              | `azure-identity`                         |
| `azureIdentity.namespace`       | Azure identity resource namespace. Default value is release namespace                                                                                     | ` `                                      |
| `azureIdentity.type`            | Azure identity type - type 0: MSI, type 1: Service Principal                                                                                              | `0`                                      |
| `azureIdentity.resourceID`      | Azure identity resource ID                                                                                                                                | ` `                                      |
| `azureIdentity.clientID`        | Azure identity client ID                                                                                                                                  | ` `                                      |
| `azureIdentityBinding.name`     | Azure identity binding name                                                                                                                               | `azure-identity-binding`                 |
| `azureIdentityBinding.selector` | Azure identity binding selector. The selector defined here will also need to be included in labels for app deployment.                                    | `demo`                                   |
