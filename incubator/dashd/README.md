# Dashd

[Dash](https://www.dash.org/) is an experimental new digital currency that enables anonymous, instant payments to anyone, anywhere in the world. 

## Introduction

This chart bootstraps a single node Dash deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Generate SSL certificate and deploy as secret

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt
kubectl create secret generic dashd-ssl --from-file=server.crt --from-file=server.key
```

Please update `ssl.secretName` value in `values.yaml`. In this example it is `"dashd-ssl"`

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/dashd
```

The command deploys dashd on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the dashd chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `imageTag`                 | `dashd` image tag.                 | Most recent release                                        |
| `imagePullPolicy`          | Image pull policy                  | `IfNotPresent`                                             |                                               |
| `persistence.enabled`      | Create a volume to store data      | true                                                       |
| `persistence.size`         | Size of persistent volume claim    | 300Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `persistence.existingClaim`| Name of existing persistent volume | `nil`
| `resources`                | CPU/Memory resource requests/limits | Memory: `512Mi`, CPU: `300m`                              |
| `configurationFiles`       | List of dashd configuration files  | `nil`


Dash is Bitcoin fork. For more information about Dash configuration please see example [bitcoin.conf](https://github.com/dash-project/dash/blob/master/contrib/debian/examples/bitcoin.conf).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dashd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The dashd image stores the Dashd node data (Blockchain and wallet) and configurations at the `/dash` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

!!! WARNING !!!

Please NOT use emptyDir for production cluster! Your wallets will be lost on container restart!

## Custom dashd configuration files

```yaml
configurationFiles:
  dash.conf: |-
    onlynet=IPv4
    server=1
    rpcuser=rpcuser
    rpcpassword=rpcpassword
    rpcport=9332
    rpcconnect=127.0.0.1
    disablewallet=0
    printtoconsole=1
```
