# Microsoft SQL Server

__This chart installs SQL Server 2017 CTP (Community Technology Preview) 2.1.__

__This software is intended for evaluation and development use only. It is not
suitable for use in production and its End User License Agreement does not
permit it. See
[documentation for the microsoft/mssql-server-linux Docker image](https://hub.docker.com/r/microsoft/mssql-server-linux/)
on DockerHub for a link to the End User License Agreement.__

__This chart is also under heavy development at this time. The effort
to provide a stable, containerized SQL Server on Linux is also a work in
progress. Expect things to change-- possibly rapidly.__

## Introduction

This chart bootstraps SQL Server.

## Installing the Chart

__Installing this chart requires explicit acceptance of an
[end user license agreement][eula].__

You must also select a strong password for the administrative user containing at
least 8 characters including uppercase and lowercase letters, base-10 digits
and/or non-alphanumeric symbols.

```bash
$ helm install incubator/sql-server \
  --name mssql --namespacde mssql \
  --set saPassword=Yggdrasil1,acceptLicense=true
```

### Advanced Installation

This chart supports many configuration options. If you wish to fine tune
these, it is often more convenient to edit a file containing your overridden
values than to pass them each into the CLI.

First, extract a copy of the chart's default configuration:

```bash
$ helm inspect values incubator/sql-server > my-values.yaml
```

Next, carefully edit `my-values.yaml`. Most fields are well-annotated
with comments to help you along. See the [configuration reference](#config-ref)
below for additional details.

To install the chart with the release name `mssql` into the `mssql` namespace,
using your customized configuration:

```bash
$ helm install incubator/sql-server \
  --name mssql --namespace mssql \
  --values my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `mssql` release:

```bash
$ helm delete mssql --purge
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## <a name="config-ref"></a>Configuration Reference

The following table lists the configurable parameters of the SQL Server chart
and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | SQL Server (on Linux) image location, _not_ including the tag | `"microsoft/mssql-server-linux"` |
| `image.tag` | Image tag | `"ctp2-1"` |
| `image.pullPolicy` | Image pull policy | `"IfNotPresent"` |
| `service.type` | Type of service. `"ClientIP"` is nearly always sufficient. | `"ClusterIP"` |
| `service.nodePort.port` | Configure a node port; applicable only when `service.Type` is `"NodePort"` | 31433 |
| `acceptLicense` | Indicates acceptance of the End User License Agreement | `false` _You must override this value with `true` for chart installation to succeed._ |
| `saPassword` | Password for the administrative user; at least 8 characters including uppercase and lowercase letters, base-10 digits and/or non-alphanumeric symbols | `nil` |
| `username` | Optional (non-admin) username | `nil` |
| `password` | Password for above username; required if username is specified; at least 8 characters including uppercase and lowercase letters, base-10 digits and/or non-alphanumeric symbols | `nil` |
| `database` | Name of a DB owned by the above non-admin user; created only if username is specified | Same as the username |
| `persistence.enabled` | Use a PVC to persist data | `true` |
| `persistence.existingClaim` | Provide an existing PersistentVolumeClaim | `nil` |
| `persistence.storageClass` | Storage class of backing PVC | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode` | Use volume as ReadOnly or ReadWrite | `ReadWriteOnce` |
| `persistence.size` | Size of data volume | `8Gi` |
