# vSphere Cloud Provider Interface (CPI)

[vSphere Cloud Provider Interface](https://github.com/kubernetes/cloud-provider-vsphere) handles cloud specific functionality for VMware vSphere infrastructure running on Kubernetes.

## Introduction

This chart deploys all components required to run the external vSphere CPI as described on it's [GitHub page](https://github.com/kubernetes/cloud-provider-vsphere).

## Prerequisites

- Has been tested on Kubernetes 1.13.X+
- Assumes your Kubernetes cluster has been configured to use the external cloud provider. Please take a look at configuration guidelines located in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/running-cloud-controller/#running-cloud-controller-manager).

## Installing the Chart using Helm 3.0+

In Helm 3.0+, the stable charts repo isn't enabled by default because there is an effort to move the charts repo into a [distributed model](https://github.com/helm/hub/blob/master/Repositories.md). To enable the [stable charts](https://github.com/helm/charts/tree/master/stable), you can run the following command:

```bash
$ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
$ helm repo update
```

Then to install this chart and by providing vCenter information/credentials, run the following command:

```bash
$ helm install vsphere-cpi stable/vsphere-cpi --namespace kube-system --set config.enabled=true --set config.vcenter=<vCenter IP> --set config.username=<vCenter Username> --set config.password=<vCenter Password> --set config.datacenter=<vCenter Datacenter>
```

> **Tip**: List all releases using `helm list --all`

If you want to provide your own `vsphere.conf` and Kubernetes secret `vsphere-cpi` (for example, to handle multple datacenters/vCenters or for using zones), you can learn more about the `vsphere.conf` and `vsphere-cpi` secret by reading the following [documentation](https://cloud-provider-vsphere.sigs.k8s.io/tutorials/kubernetes-on-vsphere-with-kubeadm.html) and then running the following command:

```bash
$ helm install vsphere-cpi stable/vsphere-cpi --namespace kube-system
```

## Installing the Chart using Helm 2.X

To install this chart with the release name `vsphere-cpi` and by providing a vCenter information/credentials, run the following command:

```bash
$ helm install stable/vsphere-cpi --name vsphere-cpi --namespace kube-system --set config.enabled=true --set config.vcenter=<vCenter IP> --set config.username=<vCenter Username> --set config.password=<vCenter Password> --set config.datacenter=<vCenter Datacenter>
```

If you provide your own `vsphere.conf` and Kubernetes secret `vsphere-cpi`, then deploy the chart running the following command:

```bash
$ helm install stable/vsphere-cpi --name vsphere-cpi --namespace kube-system
```

## Uninstalling the Chart

To uninstall/delete the `vsphere-cpi` deployment:

```bash
$ helm delete vsphere-cpi --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To permanently remove the release using Helm v2.X, run `helm delete --purge vsphere-cpi --namespace kube-system`

## Configuration

The following table lists the configurable parameters of the vSphere CPI chart and their default values.

|             Parameter                    |            Description              |                  Default               |
|------------------------------------------|-------------------------------------|----------------------------------------|
| `podSecurityPolicy.enabled`              | Enable pod sec policy (k8s > 1.17)  |  false                                 |
| `podSecurityPolicy.annotations`          | Annotations for pd sec policy       |  nil                                   |
| `securityContext.enabled`                | Enable sec context for container    |  false                                 |
| `securityContext.runAsUser`              | RunAsUser. Default is `nobody` in   |  65534                                 |
|                                          |    distroless image                 |                                        |
| `securityContext.fsGroup`                | FsGroup. Default is `nobody` in     |  65534                                 |
|                                          |    distroless image                 |                                        |
| `config.enabled`                         | Create a simple single VC config    |  false                                 |
| `config.vcenter`                         | FQDN or IP of vCenter               |  vcenter.local                         |
| `config.username`                        | vCenter username                    |  user                                  |
| `config.password`                        | vCenter password                    |  pass                                  |
| `config.datacenter`                      | Datacenters within the vCenter      |  dc                                    |
| `rbac.create`                            | Create roles and role bindings      |  true                                  |
| `serviceAccount.create`                  | Create the service account          |  true                                  |
| `serviceAccount.name`                    | Name of the created service account |  cloud-controller-manager              |
| `daemonset.annotations`                  | Annotations for CPI pod             |  nil                                   |
| `daemonset.image`                        | Image for vSphere CPI               |  gcr.io/cloud-provider-vsphere/        |
|                                          |                                     |       vsphere-cloud-controller-manager |
| `daemonset.tag`                          | Tag for vSphere CPI                 |  latest                                |
| `daemonset.pullPolicy`                   | CPI image pullPolicy                |  IfNotPresent                          |
| `daemonset.dnsPolicy`                    | CPI dnsPolicy                       |  ClusterFirst                          |
| `daemonset.cmdline.logging`              | Logging level                       |  2                                     |
| `daemonset.cmdline.cloudConfig.dir`      | vSphere conf directory              |  /etc/cloud                            |
| `daemonset.cmdline.cloudConfig.file`     | vSphere conf filename               |  vsphere.conf                          |
| `daemonset.replicaCount`                 | Node resources                      | `[]`                                   |
| `daemonset.resources`                    | Node resources                      | `[]`                                   |
| `daemonset.podAnnotations`               | Annotations for CPI pod             |  nil                                   |
| `daemonset.podLabels`                    | Labels for CPI pod                  |  nil                                   |
| `daemonset.nodeSelector`                 | User-defined node selectors         |  nil                                   |
| `daemonset.tolerations`                  | User-defined tolerations            |  nil                                   |
| `service.enabled`                        | Enabled the CPI API endpoint        |  false                                 |
| `service.annotations`                    | Annotations for API service         |  nil                                   |
| `service.type`                           | Service type                        |  ClusterIP                             |
| `service.loadBalancerSourceRanges`       | list of IP CIDRs allowed access     | `[]`                                   |
| `service.endpointPort`                   | External accessible port            |  43001                                 |
| `service.targetPort`                     | Internal API port                   |  43001                                 |
| `ingress.enabled`                        | Allow external traffic access       |  false                                 |
| `ingress.annotations`                    | Annotations for Ingress             |  nil                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` using Helm v3.X. For example,

```bash
$ helm install vsphere-cpi \
    stable/vsphere-cpi \
    --set daemonset.pullPolicy=Always
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Image tags

vSphere CPI offers a multitude of [tags](https://github.com/kubernetes/cloud-provider-vsphere/releases) for the various components used in this chart.
