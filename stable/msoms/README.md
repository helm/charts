# Microsoft Operations Management Suite Container Monitoring Solution

The Microsoft Operations Management Suite (OMS) is a software-as-a-service offering from Microsoft that allows Enterprise IT to manage any hybrid cloud. It offers log analytics, automation, backup and recovery, and security and compliance.  Sign up for a free account at [http://mms.microsoft.com](http://mms.microsoft.com) or read more about here: [https://www.microsoft.com/en-us/server-cloud/operations-management-suite/overview.aspx](https://www.microsoft.com/en-us/server-cloud/operations-management-suite/overview.aspx)

## Introduction

This chart deploys an OMS sidecar agent as a daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The OMS agent enables rich and real-time analytics for Docker containers. With this solution, you can see which containers are running on your container hosts and what images are running in the containers. You can view detailed audit information showing commands used with containers. And, you can troubleshoot containers by viewing and searching centralized logs without having to remotely view Docker or hosts. You can find containers that may be noisy and consuming excess resources on a host. And, you can view centralized CPU, memory, storage, and network usage and performance information for containers. For more information refer to the [documentation](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-containers).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

```bash
$ helm install --name omsagent stable/msoms
```

## Uninstalling the Chart

To uninstall/delete the `omsagent` deployment:

```bash
$ helm delete omsagent
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MSOMS chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `omsagent.image.tag`       | `msoms` image tag.                 | Most recent release aka latest                             |
| `omsagent.secret.wsid`     | OMS workspace id                   | Does not have a default value, needs to be provided        |
| `omsagent.secret.key`      | OMS workspace key                  | Does not have a default value, needs to be provided        |
| `omsagent.domain`          | OMS cloud domain (public / govt)   | opinsights.azure.com (Public cloud as default)             |
| `agentname`                | daemonset name                     | "omsagent"                                                 |
| `secretname`               | secrets used by the daemonset      | "omsagent-secret"                                          |

To get your workspace id and key do the following
- In the OMS portal, on the Overview page, click the Settings tile. Click the Connected Sources tab at the top.
- On the right of Workspace ID, click the copy icon and paste the ID into Notepad.
- On the right of Primary Key, click the copy icon and paste the key into Notepad.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name omsagent \
  --set omsagent.secret.wsid=<your_workspace_id>,omsagent.secret.key=<your_workspace_key>

```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name omsagent -f values.yaml stable/msoms
```
