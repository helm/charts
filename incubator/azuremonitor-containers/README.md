# Azure Monitor – Containers

---

## Introduction

This article describes how to set up and use [Azure Monitor - Containers](https://docs.microsoft.com/en-us/azure/monitoring/monitoring-container-health) to monitor the health and performance of your workloads deployed to Kubernetes environments. Monitoring your Kubernetes cluster and containers is critical, especially when running a production cluster, at scale, with multiple applications.

*This is a private preview. If you like to be part of the private preview, please fill in the form* [here]((https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR5SUgbotTSlNh-jO0uLfw51UOVBTMzFCMVIyWVEzT09NWVpDOTc0UFhENC4u)).

---

## Pre-requisites

- Kubernetes 1.7+

- You will need to create a location to store your monitoring data.

1. [Create Azure Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-quick-create-workspace))

- You will need to add AzureMonitor-Containers solution to your workspace from #1 above

2. [Add the 'AzureMonitor-Containers' Solution to your Log Analytics workspace.](http://aka.ms/coinhelmdoc)

---

## Installing the Chart

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --name azuremonitorcontainers incubator/azuremonitor-containers

```

## Uninstalling the Chart

To uninstall/delete the `azuremonitorcontainers` release:

```bash

$ helm del --purge azuremonitorcontainers

```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MSOMS chart and their default values.

The following table lists the configurable parameters of the MSOMS chart and their default values.

| Parameter                  | Description                        | Default                                                                          |
| -----------------------    | ---------------------------------- | -------------------------------------------------------------------------------- |
| `omsagent.image.tag`       | `msoms` image tag.                 | Most recent release                                                              |
| `omsagent.image.pullPolicy`| `msoms` image pull policy.         | IfNotPresent                                                                     |
| `omsagent.secret.wsid`     | Azure Log analytics workspace id                   | Does not have a default value, needs to be provided                              |
| `omsagent.secret.key`      | Azure Log analytics workspace key                  | Does not have a default value, needs to be provided                              |
| `omsagent.domain`          | Azure Log analytics cloud domain (public / govt)   | opinsights.azure.com (Azure Public cloud as default), opinsights.azure.us (Azure Govt Cloud), opinsights.azure.cn (Azure China Cloud) |
| `omsagent.env.clusterName`             | Name of your cluster      | Does not have a default value, needs to be provided       |
|`omsagent.env.doNotCollectKubeSystemLogs`| Disable collecting logs from containers in 'kube-system' namespace | true|
| `omsagent.rbac`             | rbac enabled/disabled      | true  (i.e enabled)     |


You can create a Azure Loganalytics workspace from portal.azure.com and get its ID & PRIMARY KEY from 'Advanced Settings' tab in the Ux.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash

$ helm install --name myrelease-1 \

--set omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<my_prod_cluster>  incubator/azuremonitor-containers
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash

$ helm install --name omsagent -f values.yaml incubator/azuremonitor-containers

```

After you successfully deploy the chart, you will be able to see your data in the [azure portal](aka.ms/coinprod)

If you need help with this chart, please reach us out thru [this](mailto:omscontainers@microsoft.com) email.