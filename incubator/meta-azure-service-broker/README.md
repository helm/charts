# Meta Azure Service Broker

Microsoft's
[Meta Azure Service Broker](https://github.com/azure/meta-azure-service-broker)
is an [Open Service Broker](https://www.openservicebrokerapi.org/) capable of
provisioning a variety of different managed services in Microsoft Azure.

The
[Kubernetes Service Catalog](https://github.com/kubernetes-incubator/service-catalog)
may be used to adapt OSB-compatible brokers such as this one to a
Kubernetes-native workflow. See that project's own documentation for further
details.

The services currently offered by this broker currently include:

* [Azure Storage Service](./docs/azure-storage.md)
* [Azure Redis Cache Service](./docs/azure-redis-cache.md)
* [Azure DocumentDB Service](./docs/azure-document-db.md)
* [Azure Service Bus and Event Hub Service](./docs/azure-service-bus.md)
* [Azure SQL Database Service](./docs/azure-sql-db.md)

The authors of this broker expect its offerings to expand over time to include
many more Azure services.

__DISCLAIMER:__ This chart, the Meta Azure Service Broker that it deploys, and
the Kubernetes Service Catalog all remain under heavy development at this time.
Things are changing rapidly! This chart exists, primarily to facilitate a
preview of such work. _Use this in production at your own risk!_

## An Important Note about SQL Server 2017

__By default, this chart installs SQL Server 2017 CTP (Community Technology
Preview) 2.0 to store Meta Azure Service Broker's internal state.__

__This distribution of SQL Server 2017 CTP 2.0 is intended for evaluation and
development use only. It is not suitable for use in production and its
End User License Agreement does not permit it. See
[documentation for the microsoft/mssql-server-linux Docker image](https://hub.docker.com/r/microsoft/mssql-server-linux/)
on DockerHub for a link to the End User License Agreement.__

__If you choose, at your own risk, to run the Meta Azure Service Broker in
production, disable the embedded SQL Server and provide your own. See the
[configuration reference](#config-ref) below for additional details.

## Introduction

This chart bootstraps the Meta Azure Service Broker.

## Prerequisites

- Kubernetes 1.6+
- A registered application and service principal (service account) for
provisioning services into an Azure subscription. Follow instructions
[here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal).
- __Optional:__ An external (outside the cluster) SQL Server database for
storing the broker's own state. By default, this chart provides its own SQL
Server database, but it should _not_ be considered suitable for production at
this time.
- __Suggested:__ Operators will typically wish to install the Kubernetes Service
Catalog first

## Installing the Chart

This chart requires a few configuration attributes that the authors could not
default to any sensible values. An example of such an attribute would include
the ID of the Azure subscription into which the Meta Azure Service Broker should
provision services. The same would apply for the Service Principal that will be
used to access the Azure subscription.

Because of this, a small degree of preparation is required before installing.

First, extract a copy of the chart's default configuration:

```bash
$ helm inspect values incubator/meta-azure-service-broker > my-values.yaml
```

Next, carefully edit `my-values.yaml`. Most fields are well-annotated
with comments to help you along. All fields that are required and have no
sensible default value are clearly marked. See the
[configuration reference](#config-ref) below for additional details.

To install the chart with the release name `masb` into the `masb` namespace,
using your customized configuration:

```bash
$ helm install incubator/meta-azure-service-broker \
  --name masb --namespace masb \
  --values my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `masd` release:

```bash
$ helm delete masd --purge
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## <a name="config-ref"></a>Configuration Reference

The following table lists the configurable parameters of the Meta Azure Service
Broker chart and their default values. It also denotes required fields that
have no sensible default value. These fields require your attention when
installing the chart.

| Parameter | Required (and has no default) | Description | Default |
|-----------|-------------------------------|-------------|---------|
| `replicaCount` | no | The number of replicas (pods) to run | `1` |
| `image.repository` | no | Image location, _not_ including the tag | `"microsoft/meta-azure-service-broker"` |
| `image.tag` | no | Image tag | `"canary"` |
| `image.pullPolicy` | no | Image pull policy | `"Always"` |
| `service.type` | no | Type of service. `"ClientIP"` is nearly always sufficient. | `"ClusterIP"` |
| `service.nodePort.port` | no | Configure a node port; applicable only when `service.Type` is `"NodePort"` | 30080 |
| `ingress.enabled` |  no | Whether to use your cluster's ingress controller to route inbound traffic origination from outside the cluster; rarely applicable. (This is for an advanced use case. You would use this only if hosting the broker on a different cluster than the Service Catalog(s) that will be using it to provision services.) | `false` |
| `ingress.annotations` | no | A map of annotations to include on the ingress resource (if ingress is enabled). This allows fine-tuning the ingress resource, which may sometimes be prescribed, depending upon which ingress controller(s) are installed in the cluster. | `{}` |
| `ingress.domain` | no | If enabled, inbound traffic for this hostname origination from outside the cluster will be routed to the broker | `"meta-azure-service-broker.contoso.com"` |
| `ingress.tls.enabled` | no | If ingress is enabled, this enables TLS | `false` | 
| `ingress.tls.cert` | no | A base64-encoded x509 certificate | A self-signed cert for `meta-azure-service-broker.contoso.com` _Do not use this default value in production!_ |
| `ingress.tls.key` | no | A base64-encoded private key | The private key for the above cert; _Do not use this default value in production!_ |
| `azure.environment` | no | One of `"AzureCloud"` or `"AzureChinaCloud"` | `"AzureCloud"` |
| `azure.subscriptionId` | yes | Azure subscription ID; the account into which services will be provisioned | |
| `azure.tenantId` | yes | Service principal tenant ID; this is the identifier for the Azure Active Directory that contains the service principal | |
| `azure.clientId` | yes | Service principal client ID; when viewed in Azure Active Directory, this is also known as the application ID | |
| `azure.clientSecret` | yes | Service principal client secret | |
| `basicAuth.username` | no | Username of your choice; used in securing this broker | `"username"` _Do not use this default value in production!_ |
| `basicAuth.password` | no | Password of your choice; used in securing this broker | `"password"` _Do not use this default value in production!_ |
| `encryptionKey` | no | 256 bit key used for database encryption | `"This is a key that is 256 bits!!"` _Do not use this default value in production!_ |
| `sql-server.embedded` | no | Whether the chart should also deploy a SQL Server database to your cluster | `true` |
| `sql-server.acceptLicense` | required if embedded SQL Server is used | Indicates acceptance of SQL Server's End User License Agreement | `false` _You must override this value with `true` for chart installation to succeed._ |
| `sql-server.host` | required if embedded SQL Server is _not_ used | DNS-resolvable hostname for your SQL Server RDBMS | |
| `sql-server.saPassword` | no | If embedded SQL Server is used, this defines the password for the `SA` user (admin); at least 8 characters including uppercase and lowercase letters, base-10 digits and/or non-alphanumeric symbols | `F00Bar!!` _Do not use this default value in production!_ |
| `sql-server.username` | no | If embedded SQL Server is used, this defines the username used by _both_ the client and server, otherwise, this defines the username used by the client only | `"masb"` |
| `sql-server.password` | no | If embedded SQL Server is used, this defines the password used by _both_ the client and server, otherwise, this defines the password used by the client only; at least 8 characters including uppercase and lowercase letters, base-10 digits and/or non-alphanumeric symbols | `"F00Bar!!"` _Do not use this default value in production!_ |
| `sql-server.database` | no | Name of the SQL Server database; if embedded SQL Server is used, a DB of this name will be created for you, otherwise, this DB must already exist on the specified host | `"masb"` |
| `sql-server.persistence.enabled` | no | Use a PVC to persist data | `true` |
| `sql-server.persistence.existingClaim` | no | Provide an existing PersistentVolumeClaim ||
| `sql-server.persistence.storageClass` | no | Storage class of backing PVC | `nil` (uses alpha storage class annotation) |
| `sql-server.persistence.size` | no | Size of data volume | `8Gi` |
