# Vault Helm Chart

This directory contains a Kubernetes chart to deploy a Vault server.

## Prerequisites Details

* Kubernetes 1.5

## Chart Details

This chart will do the following:

* Implement a Vault deployment

Please note that a backend service for Vault (for example, Consul) must
be deployed beforehand and configured with the `vault` option. YAML provided
under this option will be converted to JSON for the final vault `config.json`
file.

## Installing the Chart

To install the chart with the release name `my-release`:

> Please see the values.yaml file for an example using the consul backend.

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/vault --set vault.storage.consul.address="myconsul-svc-name:8500"
```

An alternative example using the Amazon S3 backend can be specified using:

```
vault:
  listener:
    tcp:
      address: "0.0.0.0:8200"
      tls_disable: 1
  storage:
    s3:
      access_key: "AWS-ACCESS-KEY"
      secret_key: "AWS-SECRET-KEY"
      bucket: "AWS-BUCKET"
      region: "eu-central-1"
```

## Configuration

The following tables lists the configurable parameters of the vault chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`      | Container pull policy               | `IfNotPresent`                                      |
| `image.repository`      | Container image to use              | `vault`                                             |
| `image.tag`             | Container image tag to deploy       | `0.7.3`                                             |
| `vault`                 | Vault configuration                 | Uses consul backend                                 |
| `replicaCount`          | k8s replicas                        | `1`                                                 |
| `resources.limits.cpu`  | Container requested CPU             | `nil`                                               |
| `resources.limits.memory` | Container requested memory        | `128Mi`                                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

