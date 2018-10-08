# vSphere Cloud Controller Manager (CCM)

[vSphere Cloud Controller Manager](https://github.com/kubernetes/cloud-provider-vsphere) handles cloud specific functionality for VMware vSphere infrastructure running on Kubernetes.

## Introduction

This chart deploys all components required to run the external vSphere CCM as described on it's [GitHub page](https://github.com/kubernetes/cloud-provider-vsphere).

## Prerequisites

- Has been tested on Kubernetes 1.11.X+
- Assumes your Kubernetes cluster has been configured to use the external `vsphere` cloud controller manager. Please take a look at configuration guidelines located in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/running-cloud-controller/#running-cloud-controller-manager).

## Installing the Chart

To install this chart with the release name `myrel` and by providing a vCenter information/credentials, run the following command:

```bash
$ helm install incubator/vsphere-ccm --name myrel --set cfg.enabled=true --set cfg.vcenter=<vCenter IP> --set cfg.username=<vCenter Username> --set cfg.password=<vCenter Password> --set cfg.datacenter=<vCenter Datacenter>
```

> **Tip**: List all releases using `helm list --all`

If you want to provide your own `vsphere.conf` and Kubernetes secret `vsphereccm` in the `kube-system` namespace (to handle multple datacenters or multiple vCenters), you can learn more about the `vsphere.conf` and `vsphereccm` secret by reading the following [doucmentation](https://github.com/kubernetes/cloud-provider-vsphere/blob/master/docs/deploying_cloud_provider_vsphere_with_rbac.md) and then running the following command:

```bash
$ helm install incubator/vsphere-ccm --name myrel
```

## Uninstalling the Chart

To uninstall/delete the `myrel` deployment:

```bash
$ helm delete myrel
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To permanently remove the release, run `helm delete --purge myrel`

## Configuration

The following table lists the configurable parameters of the vSphere CCM chart and their default values.

|             Parameter                    |            Description              |                  Default               |
|------------------------------------------|-------------------------------------|----------------------------------------|
| `ccm.annotations`                        | Annotations for CCM pod             |  nil                                   |
| `ccm.image`                              | Image for vSphere CCM               |  gcr.io/cloud-provider-vsphere/        |
|                                          |                                     |       vsphere-cloud-controller-manager |
| `ccm.tag`                                | Tag for vSphere CCM                 |  latest                                |
| `ccm.pullPolicy`                         | CCM image pullPolicy                |  IfNotPresent                          |
| `ccm.dnsPolicy`                          | CCM dnsPolicy                       |  ClusterFirst                          |
| `ccm.cmdline.logging`                    | Logging level                       |  2                                     |
| `ccm.cmdline.cloudConfig.dir`            | vSphere conf directory              |  /etc/cloud                            |
| `ccm.cmdline.cloudConfig.file`           | vSphere conf filename               |  vsphere.conf                          |
| `ccm.cmdline.kubeConfig.configMap`       | Use a configMap for kubeConfig      |  nil                                   |
| `ccm.cmdline.kubeConfig.dir`             | kubeConfig directory                |  /etc/kubernetes                       |
| `ccm.cmdline.kubeConfig.file`            | kubeConfig filename                 |  controller-manager.conf               |
| `ccm.cmdline.caCerts.configMap`          | Use a configMap for caCerts         |  nil                                   |
| `ccm.cmdline.caCerts.dir`                | caCerts directory                   |  /etc/ssl/certs                        |
| `ccm.cmdline.k8sCerts.configMap`         | Use a configMap for k8sCerts        |  nil                                   |
| `ccm.cmdline.k8sCerts.dir`               | k8sCerts directory                  |  /etc/kubernetes/pki                   |
| `ccm.resources`                          | Node resources                      | `[]`                                   |
| `ccm.podAnnotations`                     | Annotations for CCM pod             |  nil                                   |
| `ccm.podLabels`                          | Labels for CCM pod                  |  nil                                   |
| `ccm.service.enabled`                    | Enabled the CCM API endpoint        |  false                                 |
| `ccm.service.annotations`                | Annotations for API service         |  nil                                   |
| `ccm.service.type`                       | Service type                        |  ClusterIP                             |
| `ccm.service.loadBalancerSourceRanges`   | list of IP CIDRs allowed access     | `[]`                                   |
| `ccm.service.endpointPort`               | External accessible port            |  43001                                 |
| `ccm.service.targetPort`                 | Internal API port                   |  43001                                 |
| `ccm.ingress.enabled`                    | Allow external traffic access       |  false                                 |
| `ccm.ingress.annotations`                | Annotations for Ingress             |  nil                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name myrel \
    --set ccm.pullPolicy=Always \
    incubator/vsphere-ccm
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Image tags

vSphere CCM offers a multitude of [tags](https://github.com/kubernetes/cloud-provider-vsphere/releases) for the various components used in this chart.
