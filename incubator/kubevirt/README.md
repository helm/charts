# KubeVirt Helm Chart
It will deploy [KubeVirt](https://github.com/kubevirt/kubevirt) resources to make possible to create VM's as part of k8s environment.
You can find more information about VM yaml specification under [KubeVirt User Guide](https://kubevirt.gitbooks.io/user-guide/)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

You will need to give additional permissions to the user `system:serviceaccount:kube-system:default`, it will be valid only for cases when you initiated `helm` under `kube-system` namespace.

```
$ kubectl create clusterrolebinding --user system:serviceaccount:kube-system:default kube-system-cluster-admin --clusterrole cluster-admin
```

Deploy KubeVirt chart.
```
$ helm install --name my-release incubator/kubevirt
```

After installation finish, it better to remove extra permissions from the system.

```
$ kubectl delete clusterrolebinding kube-system-cluster-admin
```

## Deleting the Charts

Delete the Helm deployment as normal

```
$ helm delete my-release
```

## Configuration

The following tables lists the configurable parameters of the kubevirt chart and their default values.

|                Parameter                  |            Description              |          Default           |
| ----------------------------------------- | ------------------------------------| -------------------------- |
| `kubevirt.repository`                     |KubeVirt containers repository       | `kubevirt`                 |
| `kubevirt.tag`                            |KubeVirt containers tag              | `v0.2.0`                   |
