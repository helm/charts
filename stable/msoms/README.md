# Azure Log Analytics Container Monitoring Solution

Azure Log Analytics is a software-as-a-service offering from Microsoft that allows Enterprise IT to manage any hybrid cloud. It offers log analytics, automation, backup and recovery, and security and compliance.  Sign up for a free subscription on [Azure](https://azure.microsoft.com/en-us/free/) or read more about [Azure Log Analytics ](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-overview)

## Introduction

This chart deploys an OMS daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The OMS agent enables rich and real-time analytics for Docker containers. With this solution, you can see which containers are running on your container hosts and what images are running in the containers. You can view detailed audit information showing commands used with containers. And, you can troubleshoot containers by viewing and searching centralized logs without having to remotely view Docker or hosts. You can find containers that may be noisy and consuming excess resources on a host. And, you can view centralized CPU, memory, storage, and network usage and performance information for containers. For more information refer to the [documentation](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-containers).

## Prerequisites

- Kubernetes 1.6+
- Add the Container Monitoring solution to the [Azure Log Analytics workspace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft.containersoms?tab=Overview).

## Installing the Chart

```bash
$ helm install --name omsagent stable/msoms
```

## Uninstalling the Chart

To uninstall/delete the `omsagent` deployment:

```bash
$ helm del --purge omsagent
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MSOMS chart and their default values.

| Parameter                  | Description                        | Default                                                                          |
| -----------------------    | ---------------------------------- | -------------------------------------------------------------------------------- |
| `omsagent.image.tag`       | `msoms` image tag.                 | Most recent release                                                              |
| `omsagent.image.pullPolicy`| `msoms` image pull policy.         | IfNotPresent                                                                     |
| `omsagent.secret.wsid`     | OMS workspace id                   | Does not have a default value, needs to be provided                              |
| `omsagent.secret.key`      | OMS workspace key                  | Does not have a default value, needs to be provided                              |
| `omsagent.domain`          | OMS cloud domain (public / govt)   | opinsights.azure.com (Public cloud as default), opinsights.azure.us (Govt Cloud) |
| `nodeSelector`             | Nodes to run the omsagent on       | None, E.g. Use --set nodeSelector."role"="master" to run only on master          |

To get your workspace id and key do the following
- In the Azure Log Analytics portal, on the Overview page, click the Settings tile. Click the Connected Sources tab at the left and select "Linux Server" on the right hand side.
- On the right of Workspace ID, click the copy icon and paste the ID into Notepad.
- On the right of Primary Key, click the copy icon and paste the key into Notepad.
For more information, please go [here.](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-windows-agents#download-the-agent-setup-file-from-oms)

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name omsagent \
  --set omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key> stable/msoms

```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name omsagent -f values.yaml stable/msoms
```
