# Azure Monitor – Containers

---

## Introduction

This article describes how to set up and use [Azure Monitor - Containers](https://docs.microsoft.com/en-us/azure/monitoring/monitoring-container-health) to monitor the health and performance of your workloads deployed to Kubernetes and OpenShift v4 environments.

Monitoring your Kubernetes cluster and containers is critical, especially when running a production cluster, at scale, with multiple applications.

---

## Pre-requisites

- [Kubernetes versions and support policy  same as AKS supported versions](https://docs.microsoft.com/en-us/azure/aks/supported-kubernetes-versions)

- You will need to create a location to store your monitoring data.

1. [Create Azure Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-quick-create-workspace)

- You will need to add AzureMonitor-Containers solution to your workspace from #1 above

2. [Add the 'AzureMonitor-Containers' Solution to your Log Analytics workspace.](http://aka.ms/coinhelmdoc)

3. [For AKS-Engine or ACS-Engine K8S cluster hosted in Azure, add required tags on cluster resources, to be able to use Azure Container monitoring User experience (aka.ms/azmon-containers)](http://aka.ms/coin-acs-tag-doc)
     > Note: Pre-requisite #3 not applicable for the AKS-Engine or ACS-Engine clusters hosted in Azure Stack or On-premise.

---

## Installing the Chart

> Note: `--name` flag not required in Helm3 since this flag is deprecated
### To Use Azure Log Analytics Workspace in Public Cloud

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name myrelease-1 \
--set omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<my_prod_cluster>  incubator/azuremonitor-containers
```

### To Use Azure Log Analytics Workspace in Azure China Cloud

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name myrelease-1 \
--set omsagent.domain=opinsights.azure.cn,omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<your_cluster_name>  incubator/azuremonitor-containers
```

### To Use Azure Log Analytics Workspace in Azure US Government Cloud

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name myrelease-1 \
--set omsagent.domain=opinsights.azure.us,omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<your_cluster_name>  incubator/azuremonitor-containers
```

## Upgrading an existing Release to a new version

If the previous version of the chart installed with Helm2, it can be upgraded successfully to current version using Helm2.
But, if the previous version of chart installed  with the Helm3 or release migrated to Helm3,then chart can’t be upgraded to latest version due to issues in Helm3 with regards to upgrading the existing release to new version, as described in [Helm issue #6850](https://github.com/helm/helm/issues/6850)

## Uninstalling the Chart

To uninstall/delete the `myrelease-1` release:
> Note: `--purge` flag not required in Helm3 since this flag deprecated
```bash

$ helm del --purge myrelease-1

```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MSOMS chart and their default values.

The following table lists the configurable parameters of the MSOMS chart and their default values.

| Parameter                  | Description                                             | Default                                                                          |
| -----------------------    | --------------------------------------------------------| -------------------------------------------------------------------------------- |
| `omsagent.image.tag`       | `msoms` image tag.                                      | Most recent release                                                              |
| `omsagent.image.pullPolicy`| `msoms` image pull policy.                              | IfNotPresent                                                                     |
| `omsagent.secret.wsid`     | Azure Log analytics workspace id                        | Does not have a default value, needs to be provided                              |
| `omsagent.secret.key`      | Azure Log analytics workspace key                       | Does not have a default value, needs to be provided                              |
| `omsagent.domain`          | Azure Log analytics cloud domain (public,china, us govt)| opinsights.azure.com (Public cloud as default), opinsights.azure.cn (China Cloud), opinsights.azure.us (US Govt Cloud) |
| `omsagent.env.clusterName` | Name of your cluster                                    | Does not have a default value, needs to be provided                                                                 |
| `omsagent.rbac`            | rbac enabled/disabled                                   | true  (i.e enabled)                                                                                                 |

### Note

- Parameter `omsagent.env.doNotCollectKubeSystemLogs` has been removed starting chart version 1.0.0. Refer to 'Agent data collection settings' section below to configure it using configmap.
- onboarding of multiple clusters with the same cluster name to same log analytics workspace not supported. If need this configuration, use the cluster FQDN name rather than cluster dns prefix to avoid collision with clusterName

## Agent data collection settings

Staring with chart version 1.0.0, agent data collection settings are controlled thru a config map. Refer to documentation about agent data collection settings [here](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-agent-config)

You can create a Azure Loganalytics workspace from portal.azure.com and get its ID & PRIMARY KEY from 'Advanced Settings' tab in the Ux.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,


```bash

$ helm install --name myrelease-1 \
--set omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<your_cluster_name>
  incubator/azuremonitor-containers
```
Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash

$ helm install --name myrelease-1 -f values.yaml incubator/azuremonitor-containers

```

After you successfully deploy the chart, you will be able to see your data in
- [azure public cloud portal](https://aka.ms/azmon-containers) for the clusters in Azure Public Cloud
- [azure china cloud portal](https://aka.ms/azmon-containers-mooncake) for the clusters in Azure China Cloud
- [azure us government cloud portal](https://aka.ms/azmon-containers-fairfax) for the clusters in Azure US Government Cloud

If you need help with this chart, please reach us out through [this](mailto:askcoin@microsoft.com) email.

## Custom resource

Starting with chart version 2.0.0, chart will create a CRD (healthstates.azmon.container.insights) in kube-system namespace. This is used by the agent for cluster health monitoring.
## Container Runtime(s)

Starting with chart version 2.7.0, chart will support Container Runtime Interface(CRI) compatiable runtimes such as CRI-O and ContainerD etc. in addition to Docker/Moby.
