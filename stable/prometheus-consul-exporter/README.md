# Consul Exporter

Prometheus exporter for Consul metrics.
Learn more: https://github.com/prometheus/consul_exporter

## TL:DR

```bash
$ helm install stable/consul-exporter
```
```bash
$ helm install stable/consul-exporter --set consulServer=my.consul.com:8500
```

## Introduction

This chart creates a Consul-Exporter deployment on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:
```bash
$ helm install --name my-release stable/consul-exporter
```
```bash
$ helm install --name my-release stable/consul-exporter --set consulServer=my.consul.com --set consulPort=8500
```
The command deploys Consul-Exporter on the Kubernetes cluster using the
default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:
```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Check the [Flags](https://github.com/prometheus/consul_exporter#flags) list and add to the options block in your value overrides.

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example,
```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/consul-exporter
```
Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,
```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/consul-exporter
```
