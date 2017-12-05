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

You will need to specify KubeVirt API server external IP's under `kubevirt.apiserver.externalips` variable to have possibility to connect to KubeVirt API and SPICE proxy exteral IP under `kubevirt.spiceproxy.externalip` variable if you want to have access to VM via SPICE.
```
$ helm install --name my-release incubator/kubevirt --set kubevirt.apiserver.externalips=10.10.10.10 --set kubevirt.spiceproxy.externalip=10.10.10.10
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
| `kubevirt.apiserver.externalips`          |KubeVirt API server external IP's    | `[10.10.10.10]`            |
| `kubevirt.spiceproxy.externalip`          |KubeVirt SPICE proxy external IP     | `10.10.10.10`              |
| `kubevirt.repository`                     |haproxy container name               | `kubevirt`                 |
| `kubevirt.tag`                            |haproxy container tag                | `latest`                   |
