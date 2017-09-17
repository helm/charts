# Weave Cloud Agents

> ***NOTE: This chart is for Kubernetes version 1.6 and later.***

Weave Cloud is a add-on to Kubernetes which provides Continuous Delivery, along with hosted Prometheus Monitoring and a visual dashboard for exploring & debugging microservices.

This package contains the agents which connect your cluster to Weave Cloud.

_To learn more and sign up please visit [Weaveworks website](https://weave.works)._

You will need a service token which you can get from [cloud.weave.works](https://cloud.weave.works/).

## Installing the Chart

To install the chart:

```console
$ helm install --name weave-cloud --namespace kube-system --set ServiceToken=<YOUR_WEAVE_CLOUD_SERVICE_TOKEN> stable/weave-cloud
```

To view the pods installed:
```console
$ kubectl get pods -n kube-system -l weave-cloud-component
```

To upgrade the chart:
```console
$ helm upgrade --reuse-values weave-cloud stable/weave-cloud
```

## Uninstalling the Chart

To uninstall/delete the `weave-cloud` chart:

```console
$ helm delete weave-cloud
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Weave Cloud Agents chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ServiceToken` | Weave Cloud service token | _none_ _(**must be set**)_ |
