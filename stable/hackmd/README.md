# HackMD

[HackMD](https://hackmd.io) is a realtime, multiplatform collaborative markdown note editor.

## Introduction

This chart bootstraps a [HackMD](https://github.com/hackmdio/docker-hackmd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) which is required for bootstrapping a PostgreSQL deployment for the database requirements of the HackMD application.

## Prerequisites

- Kubernetes 1.8+
- PV provisioner support in the underlying infrastructure

## Install

```console
$ git clone https://github.com/hackmdio/docker-hackmd.git
$ helm install stable/hackmd
```

## Configuration

The following configurations may be set. It is recommended to use values.yaml for overwriting the hackmd config.

Parameter | Description | Default
--------- | ----------- | -------
`replicaCount` | How many replicas to run. | 1
`image.repository` | Name of the image to run, without the tag. | [hackmdio/hackmd](https://github.com/hackmdio/docker-hackmd)
`image.tag` | The image tag to use. | 1.0.1-ce
`image.pullPolicy` | The kubernetes image pull policy. | IfNotPresent
`service.name` | The kubernetes service name to use. | hackmd
`service.type` | The kubernetes service type to use. | ClusterIP
`service.port` | Service port. | 3000
`ingress.enabled` | If true, Ingress will be created | `false`
`ingress.annotations` | Ingress annotations | `[]`
`ingress.hosts` | Ingress hostnames | `[]`
`ingress.tls` | Ingress TLS configuration (YAML) | `[]`
`resources` | Resource requests and limits | `{}`
`persistence.enabled` | If true, Persistent Volume Claim will be created | `true`
`persistence.accessModes` | Persistent Volume access modes | `[ReadWriteOnce]`
`persistence.annotations` | Persistent Volume annotations | `{}`
`persistence.existingClaim` | Persistent Volume existing claim name | `""`
`persistence.size` | Persistent Volume size | `2Gi`
`persistence.storageClass` | Persistent Volume Storage Class |  `unset`
`extraVars` | Hackmd's extra environment variables | `[]`
`postgresql.install` | Enable PostgreSQL as a chart dependency | `true`
`postgresql.imageTag` | The image tag for PostgreSQL | `9.6.2`
`postgresql.postgresUser` | PostgreSQL User to create | `hackmd`
`postgresql.postgresHost` | PostgreSQL host (if `postgresql.install == false`)  | `nil`
`postgresql.postgresPassword` | PostgreSQL Password for the new user | random 10 characters
`postgresql.postgresDatabase` | PostgreSQL Database to create | `hackmd`
