# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# HackMD

[HackMD](https://hackmd.io) is a realtime, multiplatform collaborative markdown note editor.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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
`deploymentStrategy` | Deployment strategy. | `RollingUpdate`
`replicaCount` | How many replicas to run. | 1
`image.repository` | Name of the image to run, without the tag. | [hackmdio/hackmd](https://github.com/hackmdio/docker-hackmd)
`image.tag` | The image tag to use. | 1.3.0-alpine
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
`podAnnotations` | Pod annotations | `{}`
`sessionSecret` | Hackmd's session secret | `""` (Randomly generated)
`postgresql.install` | Enable PostgreSQL as a chart dependency | `true`
`postgresql.imageTag` | The image tag for PostgreSQL | `9.6.2`
`postgresql.postgresUser` | PostgreSQL User to create | `hackmd`
`postgresql.postgresHost` | PostgreSQL host (if `postgresql.install == false`)  | `nil`
`postgresql.postgresPassword` | PostgreSQL Password for the new user | random 10 characters
`postgresql.postgresDatabase` | PostgreSQL Database to create | `hackmd`

### Use persistent volume for image uploads

If you want to use a Kubernetes Persistent volume for image upload (enabled by default), you can encourter a problem where your volume doesn't have proper ownershuip, so HackMD won't be able to write into it. You can use set the `HMD_IMAGE_UPLOAD_TYPE` to `filesystem` in your `values.yaml` to have the Docker entrypoint change volume's ownership:

```yaml
extraVars:
  - name: HMD_IMAGE_UPLOAD_TYPE
    value: filesystem
```

### Use behind a TLS reverse proxy

If you use HackMD behind a reverse proxy that does TLS decryption and forwards traffic in plain HTTP, you have to enable the following variables in your `values.yaml`:

```yaml
extraVars:
  - name: CMD_DOMAIN
    value: change.this.to.your.own.fqdn
  - name: CMD_PROTOCOL_USESSL
    value: "true"
  - name: CMD_URL_ADDPORT
    value: "false"
```
