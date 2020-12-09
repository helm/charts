# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Kubernetes AWS EC2 Spot Rescheduler

This chart installs the [k8s-spot-rescheduler](https://github.com/pusher/k8s-spot-rescheduler).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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