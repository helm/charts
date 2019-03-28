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

## Seeding the Trust Store

TBD

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incuabor https://storage.googleapis.com/kubernetes-charts-incubator
# If you do not already have a CA or Intermediate Certificate run the following
# commands to generate the Root CA and Key which will be used as secrets when
installing.
$ ./scripts/setup.sh
$ ./scripts/create-ca.sh
$ helm install incubator/mtls -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the MTLS Chart and
their defaults.



[mtls-server]: https://github.com/drGrove/mtls-server
