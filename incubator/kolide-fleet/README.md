# Kolide FLeet

Kolide's [fleet](https://github.com/kolide/fleet) s a state of the art host monitoring platform tailored for security experts. Leveraging Facebook's battle-tested osquery project, Fleet delivers fast answers to big questions. To learn more about Fleet, visit https://kolide.com/fleet. 

## TL;DR;

---
mysql:
  mysqlUser: "kolide"
  mysqlPassword: CaeZoowi7xohv5oghaizaNga2toezei2
redis:
  redisPassword: ooveib6aud0xe0ahve4UceiTh2haev3n
fleet:
  auth:
    jwt_key: pu5te3Aekieghai5chupeiGahBoomiph


```console
$ helm install stable/kolide-fleet \
    --set="mysql.mysqlUser=kolide" \
    --set="mysql.mysqlPassword=$(pwgen 32 1)" \
    --set="redis.redisPassword=$(pwgen 32 1)" \
    --set="fleet.auth.jwt_key=$(pwgen 32 1)"  
```

## Introduction

This chart bootstraps a [Fleet](https://github.com/kolide/fleet) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.3+ with Beta APIs enabled 

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/kolide-fleet \
    --set="mysql.mysqlUser=kolide" \
    --set="mysql.mysqlPassword=$(pwgen 32 1)" \
    --set="redis.redisPassword=$(pwgen 32 1)" \
    --set="fleet.auth.jwt_key=$(pwgen 32 1)"
```

The command deploys Fleet on the Kubernetes cluster with the minimal required configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

Additionally, a TLS certificate should exist that the release can consume in the following format:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
  name: ${RELEASE_NAME}-fleet-tls
data:
  tls.crt: ${BASE64_ENCODED_TLS_CERTIFICATE}
  tls.key: ${BASE64_ENCODED_TLS_KEY}
type: kubernetes.io/tls
```

The NOTES.txt file will show commands to generate a self signed certificate and Kubernetes object.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading from previous chart versions.

The chart will automatically perform any db migrations required between versions. Please backup data prior upgrading.

## Configuration

The following table lists the configurable parameters of the fleet chart and their default values.

Parameter                           | Description                                         | Default
----------------------------------- | -------------------------------------               | -------
`nameOverride`                      | Allow overriding chart name                         | ""
`mysql.mysqlUser`                   | The MySQL user to use                               | ""
`mysql.mysqlDatabase`               | The MySQL database to use                           | ""
`mysql.mysqlPassword`               | The MySQL password to use                           | (Required)
`redis.redisPassword`               | The Redis password                                  | (Required)
`fleet.*`                           | Fleet configuration                                 | See [fleet configuration docs](https://github.com/kolide/fleet/blob/master/docs/infrastructure/configuring-the-fleet-binary.md)
`pod.annotations`                   | Arbitrary pod annotations                           | ""
`pod.fleet.image`                   | The image to use for the fleet binary               | `kolide/fleet`
`service.type`                      | The Kubernetes service type                         | LoadBalancer
`service.loadBalancer.publicIP`     | A pre-defined IP for the load balancer              | ""
`service.loadBalancer.allowedIPs`   | An array of IPs allowed access to the load balancer | []
`service.loadBalancer.hostName`     | A DNS name associated with the IP                   | ""
`service.annotations`               | Arbitrary service annotations                       | {}
`deployment.replicas`               | How may replicas of fleet to run                    | 1
`resources.requests.cpu`            | How much CPU to request for the fleet pod           | "100m"
`resources.requests.memory`         | How much memory to request for the fleet pod        | "256Mi"
`resources.limits.cpu`              | How much CPU to limit the fleet pod to              | ""
`resources.limits.memory`           | How much memory to limit the fleet pod to           | ""

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release stable/kolide-fleet \
    --set="mysql.mysqlUser=kolide" \
    --set="mysql.mysqlPassword=$(pwgen 32 1)" \
    --set="redis.redisPassword=$(pwgen 32 1)" \
    --set="fleet.auth.jwt_key=$(pwgen 32 1)"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/fleet --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
