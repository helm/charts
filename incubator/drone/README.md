# Drone.io

[Drone](http://readme.drone.io/) is a Continuous Integration platform built on container technology. Every build is executed inside an ephemeral Docker container, giving developers complete control over their build environment with guaranteed isolation.

## Introduction

This chart stands up a Drone server. This includes:

- A [Drone Server](http://readme.drone.io/admin/installation-guide/) Pod
- A [Drone Agent](http://readme.drone.io/admin/installation-guide/) Pod

## Prerequisites

- Kubernetes 1.5+
- The ability to point a DNS entry or URL at your Drone installation

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/drone
```

You will need to specify custom git parameters in order for the drone server to work.
Please refer to [values.yaml](values.yaml) for the full run-down on how to configure this.

Once it's configured, you can then install drone.

```
$ helm install ./drone
```

## Configuration

The following tables lists the configurable parameters of the drone charts and their default values.
|              Parameter               |                             Description                             |               Default                |
| ------------------------------------ | ------------------------------------------------------------------- | ------------------------------------ |
