# MTLS Helm Chart

This directory contains a Kubernetes chart to deploy a [MTLS][mtls-server]
Server.

## Prerequisites Details

* Kubernetes 1.11+

## Chart Details

This chart will do the following:

* Implement a MTLS Deployment

This system itself will not use Client Certificate Authentication as it uses a
detached signed PGP message to check for authentication when generating
certificates from a CSR. To seed admin store. Please read below

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incuabor https://storage.googleapis.com/kubernetes-charts-incubator
# If you do not already have a CA or Intermediate Certificate run the following
# commands to generate the Root CA and Key which will be used as secrets when
installing.
$ ./scripts/setup.sh
$ ./scripts/create-ca.sh
$ helm install stable/mtls -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the MTLS Chart and
their defaults.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | `mtls` image repository | `drgrove/mtls` |
| `image.tag` | `mtls` image tag. | `v0.11.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `secrets.ca_key` | RSA key for CA | |
| `secrets.ca_crt` | PEM format CA Certificate | |
| `configMaps.config.ini` | Base configuration for `mtls` | See values.yaml |
| `seeds` | ASCII Armored PGP Keys for Seeding Trust Database | {} |
| `persistence.enabled` | Create a volume to store data | true |
| `persistence.size` | Size of persistent volume claim | 10Gi RW |
| `persistence.storageClass` | Type of persistent volume claim | nil |
| `persistence.accessMode` | ReadWriteOnce or ReadOnly | ReadWriteOnce |
| `persistence.existingClaim` | Name of existing persistent volume | `nil` |
| `persistence.subPath` | Subdirectory of the volume to mount | `nil` |
| `persistence.annotations` | Persistent Volume annotations | {} |
| `nodeSelector` | Node labels for pod assignment | {} |
| `tolerations` | Pod taint tolerations for deployment | {} |

[mtls-server]: https://github.com/drGrove/mtls-server
