# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# risk-advisor
Risk advisor module for Kubernetes. This project is licensed under the terms of the Apache 2.0 license.

It allows you to check how the cluster state would change if the request of creating provided pods was accepted by Kubernetes.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR

```console
$ helm install stable/risk-advisor
```

## Introduction
This is a tool for operators of large Kubernetes cluster to help them foresee how adding new pods to the cluster will change the cluster state, especially which nodes will they be scheduled on and if there's enough resources in the cluster.

## Prerequisites
  - Kubernetes 1.5, no guarantees for other versions, however it should work properly

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/risk-advisor
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the aws-cluster-autoscaler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | desired number of risk-advisor pods | `1`
`image.repository` | risk-advisor container image repository | `pposkrobko/risk-advisor`
`image.tag` | risk-advisor container image tag | `v1.0.0`
`image.pullPolicy` | risk-advisor container image pull policy | `IfNotPresent`
`service.type` | service type | `NodePort`
`service.targetPort` | exposed port of risk-advisor pod| `9997`
`service.port` | in-cluster exposed port of risk-advisor service | `9997`
`service.nodePort` | exposed external port accessible from outside the cluster | `31111`

## Usage

Chart exposes a service with a REST API on 11111 port, accepting following endpoints:
 * `/advise`:
     * Accepts: a JSON table containing pod definitions
     * Returns: a JSON table of scheduling results. Each result contains:
       	 * `podName`: (string) Name of the relevant pod
         * `result`: (string) `Scheduled` if the pod would be successfully scheduled, `failedScheduling` otherwise
         * `message`: (string) Additional information about the result (e.g. nodes which were tried, or the reason why scheduling failed)
 * `/healthz`  Health check endpoint, responds with HTTP 200 if successful
