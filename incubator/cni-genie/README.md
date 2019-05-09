# CNI Genie plugin

CNI-Genie is a multi-networking plugin which enables container orchestrators (Kubernetes, Mesos) to seamlessly connect to the choice of CNI plugins installed on a host.

This plugin takes care of provisioning the pod network of your choice during deployment time.


To know more about this, please visit (https://github.com/cni-genie/CNI-Genie).

## Installing the Chart

To install the chart with the release name `cni-genie-release`:

```console
$ helm install --name cni-genie-release incubator/cni-genie
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
| `cniBinDirPath` | Path for genie bin file |  /opt/cni/bin
| `cniConfDirPath`| Path for genie conf file | /etc/cni/net.d
| `admissionControllerContainerPort`| Port at which admission controller listens | 8000
| `genieLogLevel` | Loglevel for genie logs | info
| `geniePluginLabel` | Labels for genie plugin | genie
| `geniePolicyLabel`| Labels for genie policy | genie-policy
| `pluginImagePath`| Path for fetching genie-plugin image | quay.io/huawei-cni-genie/genie-plugin:latest
| `admissionControllerImagePath` | Path for fetching admission-controller plugin image | quay.io/huawei-cni-genie/genie-admission-controller:latest
| `policyControllerImagePath` | Path for fetching policyController plugin image | quay.io/huawei-cni-genie/genie-policy-controller:latest

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Example: `helm install  --name cni-genie-release incubator/cni-genie --set image.pullPolicy=Always,includePolicy=false`

