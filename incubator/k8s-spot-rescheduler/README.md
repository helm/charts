# Kubernetes AWS EC2 Spot Rescheduler

This chart installs the [k8s-spot-rescheduler](https://github.com/pusher/k8s-spot-rescheduler).

## Purpose

This rescheduler will reschedule Pods that are already running on on-demand instances. Based on worker labels it will move Pods to spot instances. It can work together with Cluster Autoscaler if you want to scale on-demand instances to zero.

## Installation

You should install this chart into the `kube-system` namespace:
```
helm install incubator/k8s-spot-rescheduler --namespace kube-system
```

## Configuration

Add the flags to `cmdOptions` which you want to use. The full list of flags is available [here](https://github.com/pusher/k8s-spot-rescheduler#flags).
