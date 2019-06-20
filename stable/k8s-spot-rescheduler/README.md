# Kubernetes AWS EC2 Spot Rescheduler

This chart installs the [k8s-spot-rescheduler](https://github.com/pusher/k8s-spot-rescheduler).

## Purpose

Spot rescheduler will reschedule pods that are already running on on-demand instances. Based on worker labels it will move pods to spot instances. It can work together with [Cluster Autoscaler](https://github.com/kubernetes/charts/tree/master/stable/cluster-autoscaler) if you want to scale on-demand instances back to zero.

## Installation

You should install this chart into the `kube-system` namespace:
```
helm install \
  --namespace kube-system \
  stable/k8s-spot-rescheduler
```

If your cluster has RBAC enabled, run this command:
```
helm install \
  --namespace kube-system \
  --set rbac.create=true \
  stable/k8s-spot-rescheduler
```

## Configuration

Add the parameters to `cmdOptions` which you want to use. Here is [the full list of available options](https://github.com/pusher/k8s-spot-rescheduler#flags).

| Parameter                          | Description                                                                                                                | Default                                            |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `priorityClassName`                | priorityClassName                                                                                                          | `""`    