# alb-ingress-controller

alb-ingress-controller satisfies Kubernetes ingress resources by provisioning Application Load Balancers.

This is a clone of the upstream helm chart located at:
https://github.com/kubernetes-sigs/aws-alb-ingress-controller/tree/master/alb-ingress-controller-helm


## Installing the Chart

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install incubator/alb-ingress-controller
```


## Configuration

Please see [README-upstream.md](./README-upstream.md)

## Updating the chart from upstream

In order to update the chart from the upstream repository run:

```console
$ make update-from-upstream
```
