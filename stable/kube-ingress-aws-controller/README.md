# kube-ingress-aws-controller

[kube-ingress-aws-controller](https://github.com/zalando-incubator/kube-ingress-aws-controller) is an ingress controller for Kubernetes — the open-source container deployment, scaling, and management system — on AWS.

## TL;DR;

```console
$ helm install kube-ingress-aws-controller --namespace kube-system --name aws-ingc
```

## Installing the Chart

To install the chart with the release name `aws-ingc`:

```console
$ helm install kube-ingress-aws-controller --namespace kube-system --name aws-ingc
```

## Uninstalling the Chart

To uninstall/delete the `aws-ingc` deployment:

```console
$ helm delete --purge aws-ingc
```

## Configuration

The following table lists the configurable parameters of the kube-ingress-aws-controller chart and their default values.

Parameter | Description | Default
--- | --- | ---
`controller.annotations` | Annotations for the controller | `null`
`controller.awsRegion` | AWS Region where the controller must operate | `us-west-1`
`controller.image.repository` | Controller container image | `registry.opensource.zalan.do/teapot/kube-ingress-aws-controller`
`controller.image.tag` | Controller container version | `latest`
`controller.image.pullPolicy` | Controller container pull policy | `IfNotPresent`
`daemonset.annotations` | Annotations for the daemonset | `null`
`daemonset.args` | Daemonset arguments for the process | see `values.yaml`
`daemonset.image.repository` | Daemonset container image | `registry.opensource.zalan.do/pathfinder/skipper`
`daemonset.image.tag` | Daemonset container version | `latest`
`daemonset.image.pullPolicy` | Daemonset container pull policy | `IfNotPresent`
`daemonset.resources.limits.cpu` | Daemonset CPU limit for resources | `200m`
`daemonset.resources.limits.memory` | Daemonset Memory limit for resources | `200Mi`
`daemonset.resources.requests.cpu` | Daemonset CPU request limit for resources | `25m`
`daemonset.resources.requests.memory` | Daemonset Memory request limit for resources | `25Mi`
`rbac.create` | Set to `true` to enable RBAC support. | `false`
`serviceAccount.name` | Default Service Account name for RBAC ( used only when `serviceAccount.create` is set to `true` ) | `kube-ingress-aws-controller`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name aws-ingc -f values.yaml kube-ingress-aws-controller
```
