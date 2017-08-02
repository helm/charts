# acs-engine-autoscaler

[acs-engine-autoscaler](https://github.com/wbuchwalter/Kubernetes-acs-engine-autoscaler) is a node-level autoscaler for Kubernetes for clusters created with acs-engine.

## TL;DR:

```console
$ helm install stable/acs-engine-autoscaler -f values.yaml
```
Where `values.yaml` contains:

```
acsenginecluster:
  resourcegroup:
  azurespappid:
  azurespsecret:
  azuresptenantid:
  kubeconfigprivatekey:
  clientprivatekey:
  caprivatekey:
```

## Introduction

This chart bootstraps an acs-engine-autoscaler deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.6+

## Installing the Chart

In order for the chart to configure the acs-engine-autoscaler properly during the installation process, you must provide some minimal configuration which can't rely on defaults. This includes all the values in the `values.yaml` file:

```
acsenginecluster:
  resourcegroup:
  azurespappid:
  azurespsecret:
  azuresptenantid:
  kubeconfigprivatekey:
  clientprivatekey:
  caprivatekey:
```

To install the chart with the release name `my-release`:

```console
$ helm install stable/acs-engine-autoscaler
```

The command deploys acs-engine-autoscaler on the Kubernetes cluster using the supplied configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Verifying Installation

To verify the acs-engine-autoscaler is configured properly find the pod that the deployment created and look at its logs. The result will look something similar to the following:

```
To verify that acs-engine-autoscaler has started, run:

  kubectl --namespace=default get pods -l "app=olfactory-bunny-acs-engine-autoscaler"

To verify that acs-engine-autoscaler is running as expected, run:
  kubectl logs $(kubectl --namespace=default get pods -l "app=olfactory-bunny-acs-engine-autoscaler" -o jsonpath="{.items[0].metadata.name}")

$ kubectl --namespace=default get pods -l "app=olfactory-bunny-acs-engine-autoscaler"

NAME                                                     READY     STATUS    RESTARTS   AGE
olfactory-bunny-acs-engine-autoscaler-1715934483-c673v   1/1       Running   0          10s

$ kubectl logs $(kubectl --namespace=default get pods -l "app=olfactory-bunny-acs-engine-autoscaler" -o jsonpath="{.items[0].metadata.name}")

2017-06-11 23:20:59,352 - autoscaler.cluster - DEBUG - Using kube service account
2017-06-11 23:20:59,352 - autoscaler.cluster - INFO - ++++ Running Scaling Loop ++++++
2017-06-11 23:20:59,421 - autoscaler.cluster - INFO - Pods to schedule: 0
2017-06-11 23:20:59,421 - autoscaler.cluster - INFO - ++++ Scaling Up Begins ++++++
2017-06-11 23:20:59,421 - autoscaler.cluster - INFO - Nodes: 1
2017-06-11 23:20:59,421 - autoscaler.cluster - INFO - To schedule: 0
2017-06-11 23:20:59,421 - autoscaler.cluster - INFO - Pending pods: 0
2017-06-11 23:20:59,422 - autoscaler.cluster - INFO - ++++ Scaling Up Ends ++++++
2017-06-11 23:20:59,422 - autoscaler.cluster - INFO - ++++ Maintenance Begins ++++++
2017-06-11 23:20:59,422 - autoscaler.engine_scaler - INFO - ++++ Maintaining Nodes ++++++
2017-06-11 23:20:59,423 - autoscaler.engine_scaler - INFO - node: k8s-agentpool1-29744472-4                                                   state: under-utilized-undrainable
2017-06-11 23:20:59,423 - autoscaler.cluster - INFO - ++++ Maintenance Ends ++++++
...
```

## Uninstalling the Chart

To uninstall/delete the last deployment:

```console
$ helm ls
$ helm delete [last deployment]
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the acs-engine-autoscaler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`resourcegroup`| Name of the resource group containing the cluster | None. You *must* supply one.
`azurespappid`| An Azure service principal id | None. You *must* supply one.
`azurespsecret`| An Azure service principal secret | None. You *must* supply one.
`azuresptenantid`| An Azure service principal tenant id | None. You *must* supply one.
`kubeconfigprivatekey`| The key passed to the `kubeConfigPrivateKey` parameter in your `azuredeploy.parameters.json` generated with `acs-engine` | None. You *must* supply one.
`clientprivatekey`| The key passed to the `clientPrivateKey` parameter in your `azuredeploy.parameters.json` generated with `acs-engine` | None. You *must* supply one.
`caprivatekey`| The key passed to the `caPrivateKey` parameter in your `azuredeploy.parameters.json` generated with `acs-engine` | None. You *must* supply one.
`acsdeployment`| [OPTIONAL] The name of the deployment used to deploy the kubernetes cluster initially. | `azuredeploy`.
`sleeptime`| [OPTIONAL] The number of seconds to sleep between scaling loops. | 60
`ignorepools`| [OPTIONAL] A list of comma seperated pool names the autoscaler should ignore. | None.
`spareagents`| [OPTIONAL] Number of agents per pool that should always remain up. | 1
`idlethreshold`| [OPTIONAL] Maximum duration (in seconds) an agent can stay idle before being deleted. | 1800 (30 minutes)
`overprovision`| [OPTIONAL] Number of extra agents to create when scaling out. | 0
Specify each parameter you'd like to override using a YAML file as described above in the [installation](#Installing the Chart) section.


## Credentials
You need to provide a Service Principal to the autoscaler. You can create one using [Azure CLI](https://github.com/Azure/azure-cli):
```
az ad sp create-for-rbac
```