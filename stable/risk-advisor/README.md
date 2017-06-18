# risk-advisor
Risk advisor module for Kubernetes. This project is licensed under the terms of the Apache 2.0 license.

It allows you to check how the cluster state would change it the request of creating provided pods was accepted by Kubernetes.

## TL;DR

```console
$ helm install stable/risk-advisor
```

## Introduction
This is a tool for operators of large Kubernetes cluster to help them foresee how adding new pods to the cluster will change the cluster state, especially which nodes will they be scheduled on and if there's enough resources in the cluster.

## Prerequisites
  - Kuberentes 1.5, no guarantees for other versions, however it should work properly

## Installing the Chart

```console
$ helm install stable/risk-advisor
```

## Usage

Chart exposes a service with a REST API on 11111 port, accepting following endpoints:
 * `/advise`:
     * Accepts: a JSON table containing pod definitions
     * Returns: a JSON table of scheduling results. Each result contains:
       	 * `podName`: (string) Name of the relevant pod
         * `result`: (string) `Scheduled` if the pod would be successfully scheduled, `failedScheduling` otherwise
         * `message`: (string) Additional information about the result (e.g. nodes which were tried, or the reason why scheduling failed)
 * `/healthz`  Health check endpoint, responds with HTTP 200 if successful
