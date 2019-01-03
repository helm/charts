# vSphere Container Storage Interface (CSI) Driver

[vSphere Container Storage Interface (CSI) Driver](https://github.com/kubernetes/cloud-provider-vsphere) handles cloud specific functionality for provisioning storage for Kubernetes workloads on VMware vSphere infrastructure.

## Introduction

This chart deploys all components required to run the external vSphere CSI as described on it's [GitHub page](https://github.com/kubernetes/cloud-provider-vsphere).

## Prerequisites

- Has been tested on Kubernetes 1.11, 1.12, and 1.13.
- Assumes your Kubernetes cluster has been configured to provision storage from a Container Storage Interface implementation. Please take a look at configuration guidelines located in the [Kubernetes documentation](https://kubernetes-csi.github.io/docs/Setup.html).

## Installing the Chart

To install this chart with the release name `myrel` and by providing a vCenter information/credentials, run the following command:

```bash
$ helm install incubator/vsphere-csi --name myrel --set cfg.enabled=true --set cfg.vcenter=<vCenter IP> --set cfg.username=<vCenter Username> --set cfg.password=<vCenter Password> --set cfg.datacenter=<vCenter Datacenter>
```

> **Tip**: List all releases using `helm list --all`

If you want to provide your own `vsphere.conf` and Kubernetes secret `vspherecsi` in the `kube-system` namespace, you can learn more about the `vsphere.conf` and `vspherecsi` secret by reading the following [doucmentation](https://github.com/kubernetes/cloud-provider-vsphere/blob/master/docs/deploying_csi_vsphere_with_rbac.md) and then running the following command:

```bash
$ helm install incubator/vsphere-csi --name myrel
```

## Uninstalling the Chart

To uninstall/delete the `myrel` deployment:

```bash
$ helm delete myrel
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To permanently remove the release, run `helm delete --purge myrel`

*IMPORTANT:* Deleting this chart even with doing a `--purge` does *not* delete the CRDs associated with this chart. You can download the following [CRD definitions](https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/csi/vsphere-csi-crd.yaml) and run the following command `kubectl delete -f vsphere-csi-crd.yaml` to remove them.

## Configuration

The following table lists the configurable parameters of the vSphere CSI chart and their default values.

|             Parameter                         |            Description              |                    Default                 |
|-----------------------------------------------|-------------------------------------|--------------------------------------------|
| `csi.cfg.enable`                              | Create a vsphere.conf               |  false                                     |
| `csi.cfg.vcenter`                             | vCenter IP in vsphere.conf          |  "10.0.0.1"                                |
| `csi.cfg.username`                            | vCenter username in vsphere.conf    |  "user"                                    |
| `csi.cfg.password`                            | vCenter password in vsphere.conf    |  "pass"                                    |
| `csi.cfg.datacenter`                          | Datacenters in vsphere.conf         |  "dc"                                      |
| `csi.controller.annotations`                  | Annotations for Controller component|  nil                                       |
| `csi.controller.image`                        | Image for Controller component      |  gcr.io/cloud-provider-vsphere/vsphere-csi |
| `csi.controller.tag`                          | Tag for Controller component        |  latest release                            |
| `csi.controller.pullPolicy`                   | Controller component pullPolicy     |  IfNotPresent                              |
| `csi.controller.cmdline.logging`              | Logging level                       |  2                                         |
| `csi.controller.cmdline.cloudConfig.dir`      | vSphere conf directory              |  /etc/cloud                                |
| `csi.controller.cmdline.cloudConfig.file`     | vSphere conf filename               |  vsphere.conf                              |
| `csi.controller.cmdline.kubeConfig.configMap` | Use a configMap for kubeConfig      |  nil                                       |
| `csi.controller.cmdline.kubeConfig.dir`       | kubeConfig directory                |  /etc/kubernetes                           |
| `csi.controller.cmdline.kubeConfig.file`      | kubeConfig filename                 |  controller-manager.conf                   |
| `csi.controller.cmdline.caCerts.configMap`    | Use a configMap for caCerts         |  nil                                       |
| `csi.controller.cmdline.caCerts.dir`          | caCerts directory                   |  /etc/ssl/certs                            |
| `csi.controller.cmdline.k8sCerts.configMap`   | Use a configMap for k8sCerts        |  nil                                       |
| `csi.controller.cmdline.k8sCerts.dir`         | k8sCerts directory                  |  /etc/kubernetes/pki                       |
| `csi.controller.podAnnotations`               | Annotations for Controller component|  nil                                       |
| `csi.controller.podLabels`                    | Labels for Controller component     |  nil                                       |
| `csi.controller.replicaCount`                 | Number of instances                 |  1                                         |
| `csi.controller.serviceAccountName`           | ServiceAccount for Controller       |  vsphere-csi-controller                    |
| `csi.node.annotations`                        | Annotations for Node pod            |  nil                                       |
| `csi.node.image`                              | Image for vSphere CSI node          |  gcr.io/cloud-provider-vsphere/vsphere-csi |
| `csi.node.tag`                                | Tag for Node component              |  latest                                    |
| `csi.node.pullPolicy`                         | Node component pullPolicy           |  IfNotPresent                              |
| `csi.node.cmdline.logging`                    | Logging level                       |  2                                         |
| `csi.node.podAnnotations`                     | Annotations for Node component      |  nil                                       |
| `csi.node.podLabels`                          | Labels for Node component           |  nil                                       |
| `csi.node.replicaCount`                       | Number of instances                 |  1                                         |
| `csi.node.serviceAccountName`                 | ServiceAccount for Node             |  vsphere-csi-node                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name myrel \
    --set csi.pullPolicy=Always \
    incubator/vsphere-csi
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Image tags

vSphere CSI offers a multitude of [tags](https://github.com/kubernetes/cloud-provider-vsphere/releases) for the various components used in this chart.
