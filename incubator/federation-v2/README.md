# Kubernetes Federation V2

Kubernetes Federation V2 is a Kubernetes Incubator project. It builds on the sync controller
(a.k.a. push reconciler) from [Federation v1](https://github.com/kubernetes/federation/)
to iterate on the API concepts laid down in the [brainstorming
doc](https://docs.google.com/document/d/159cQGlfgXo6O4WxXyWzjZiPoIuiHVl933B43xhmqPEE/edit#)
and further refined in the [architecture
doc](https://docs.google.com/document/d/1ihWETo-zE8U_QNuzw5ECxOWX0Df_2BVfO3lC4OesKRQ/edit#). 
Access to both documents is available to members of the
[kubernetes-sig-multicluster google
group](https://groups.google.com/forum/#!forum/kubernetes-sig-multicluster).

## Prerequisites

- Kubernetes 1.11+
- Helm 2.10+

## Installing the Chart

First you'll need to create the reserved namespace for registering clusters with the
cluster registry:

```bash
$ kubectl create ns kube-multicluster-public
```

Install the chart with the release name `federation-v2`:

```bash
$ helm install charts/federation-v2 --name federation-v2 --namespace federation-system
```

If you already have clusterregistry installed, skip installing it during federation-v2 installation
as follows:

```bash
$ helm install charts/federation-v2 --name federation-v2 --namespace federation-system --set clusterregistry.enabled=false
```

## Uninstalling the Chart

Due to this helm [issue](https://github.com/helm/helm/issues/4440), the CRDs cannot be deleted
when delete helm release, so before delete the helm release, we need first delete all
of the CR and CRDs for federation v2 release.

Delete all federation v2 `FederatedTypeConfig`:

```bash
$ kubectl -n federation-system delete FederatedTypeConfig --all
```

Delete all federation v2 CRDs:

```bash
$ kubectl delete crd $(kubectl get crd | grep -E 'federation.k8s.io' | awk '{print $1}')
```

If you want to delete `clusters.clusterregistry.k8s.io` as well, do it as follows:

```bash
$ kubectl delete crd clusters.clusterregistry.k8s.io
```

Then you can uninstall/delete the `federation-v2` release:

```bash
$ helm delete --purge federation-v2
```

The command above removes all the Kubernetes components associated with the chart
and deletes the release.

Delete the reserved namespace for registering clusters:

```bash
$ kubectl delete ns kube-multicluster-public
```

## Configuration

The following tables lists the configurable parameters of the Federation V2
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| controllermanager.enabled | Specifies whether to enable the controller manager in federation v2. | true |
| controllermanager.replicaCount | Number of replica for federation v2 controller manager. | 1 |
| controllermanager.repository | Repo of the federation v2 image. | quay.io/kubernetes-multicluster |
| controllermanager.image | Name of the federation v2 image. | federation-v2 |
| controllermanager.tag | Tag of the federation v2 image. | latest |
| controllermanager.pullPolicy | Image pull policy. | IfNotPresent |
| controllermanager.featureGates | Feature gates are a set of `key=value` pairs that describe alpha or experimental features. An administrator can use the `--feature-gates` command line flag on each component to turn a feature on or off. | PushReconciler=true,SchedulerPreferences=true,CrossClusterServiceDiscovery=true,FederatedIngress=true |
| controllermanager.federationNamespace | The namespace the federation control plane is deployed in. | federation-system |
| controllermanager.registryNamespace | The cluster registry namespace. | kube-multicluster-public |
| controllermanager.limitedScope | Whether the federation namespace will be the only target for federation. If set to true, the value set for `controllermanager.registryNamespace` and `controllermanager.registryNamespace` will be ignored. | false |
| clusterregistry.enabled | Specifies whether to enable the clusterregistry in federation v2. | true |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example:

```bash
$ helm install charts/federation-v2 --name federation-v2 --namespace federation-system --values values.yaml
```
