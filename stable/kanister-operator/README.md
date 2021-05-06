# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# kanister-operator

[kanister-operator](https://github.com/kanisterio/kanister) is a Kubernetes operator for the Kanister framework.

Kanister is a framework that enables application-level data management on Kubernetes. It allows domain experts to capture application specific data management tasks via blueprints, which can be easily shared and extended. The framework takes care of the tedious details surrounding execution on Kubernetes and presents a homogeneous operational experience across applications at scale.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install stable/kanister-operator
```

## Introduction

This chart bootstraps a kanister-operator deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/kanister-operator
```

The command deploys kanister-operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kanister-operator chart and their default values.

Parameter | Description | Default
--- | --- | ---
`rbac.create` | all required roles and SA will be created | `true`
`serviceAccount.create`| specify if SA will be created | `true`
`serviceAccount.name`| provided service account name will be used | `None`
`image.repository` | controller container image repository | `kanisterio/controller`
`image.tag` | controller container image tag | `v0.2.0`
`image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`resources` | k8s pod resorces | `None`
`profile.create` | flag to indicate creation of profile | `false`
`profile.defaultProfile` | flag to create fallback profile for the namespace | `false`
`profile.defaultProfileName` | profile name used when creating defaultProfile | `default-profile`
`profile.profileName` | profile name to be used when not creating a defaultProfile | `None`
`profile.s3.bucket` | s3 bucket, required if creating a profile | `None`
`profile.s3.endpoint` | Endpoint to the s3 bucket | `None`
`profile.s3.prefix` | Prefix to the s3 bucket | `None`
`profile.s3.region` | Region of the s3 bucket <us-west-1, us-east-1 etc> | `None`
`profile.s3.accessKey` | aws access key id, required if creating a profile | `None`
`profile.s3.secretKey` | aws secret access key, required if creating a profile | `None`
`profile.verifySSL` | flag to verify ssl certs | `true`

Specify each parameter you'd like to override using a YAML file as described above in the [installation](#Installing the Chart) section.

You can also specify any non-array parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kanister-operator --name my-release \
    --set rbac.create=false
```

To install a default S3 profile with the operator, you can use the following command:

```console
$ helm install stable/kanister-operator --name my-release \
    --set profile.create=true,profile.defaultProfile=true, \
    profile.s3.bucket=<aws_bucket>,profile.s3.accessKey=<aws_access_key>,profile.s3.secretKey=<aws_secret_access_key>
```
