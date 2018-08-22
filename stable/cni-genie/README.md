# CNI Genie plugin

CNI-Genie is a multi-networking plugin which enables container orchestrators (Kubernetes, Mesos) to seamlessly connect to the choice of CNI plugins installed on a host.

This plugin takes care of provisioning the pod network of your choice during deployment time.


To know more about this, please visit (https://github.com/Huawei-PaaS/CNI-Genie).

## Installing the Chart

To install the chart with the release name `cni-genie-release`:

```console
$ helm install --name cni-genie-release stable/cni-genie
```

To view all the genie pods installed:
```console
$ kubectl get pods -n kube-system | grep genie
```


## Uninstalling the Chart

To uninstall/delete the `cni-genie-release` chart:

```console
$ helm delete cni-genie-release --purge
```

This command removes all the Kubernetes objects associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the cni genie chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `imagePullPolicy` | Container pull policy | IfNotPresent |
| `includePolicy`       | If set to false, network policy feature will not be included                  | `true`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Example: `helm install  --name cni-genie-release stable/cni-genie --set image.pullPolicy=Always,includePolicy=false`
