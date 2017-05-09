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

## Introduction

This chart bootstraps the Meta Azure Service Broker.

## Prerequisites

- Kubernetes 1.6+
- A registered application and service principal (service account) for
provisioning services into an Azure subscription. Follow instructions
[here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal).
- A SQL Server database for storing the broker's own state; this database can
be hosted off-cluster. Azure offers a convenient, managed SQL Server as a
service and that may currently be the best/easiest way of fulfilling this
prerequisite.
- __Suggested:__ Operators will typically wish to install the Kubernetes Service
Catalog first

## Installing the Chart

This chart requires _many_ configuration attributes that the authors could not
default to any sensible values. Example of such attributes would include
credentials for an Azure Service Principal that will be utilized to provision
Azure services on your behalf.

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
| `ingress.domain` | if ingress is enabled, yes | If enabled, inbound traffic for this hostname origination from outside the cluster will be routed to the broker | |
| `ingress.tls.enabled` | no | If ingress is enabled, this enables TLS | `false` | 
| `ingress.tls.cert` | if ingress and TLS are enabled, yes | A base64-encoded x509 certificate | |
| `ingress.tls.key` | if ingress and TLS are enabled, yes | A base64-encoded private key | |
| `config.azure.environment` | no | One of `"AzureCloud"` or `"AzureChinaCloud"` | `"AzureCloud"` |
| `config.azure.subscriptionId` | yes | Azure subscription ID; the account into which services will be provisioned | |
| `config.azure.servicePrincipal.tenantId` | yes | Service principal tenant ID; this is the identifier for the Azure Active Directory that contains the service principal | |
| `config.azure.servicePrincipal.clientId` | yes | Service principal client ID; when viewed in Azure Active Directory, this is also known as the application ID | |
| `config.azure.servicePrincipal.clientSecret` | yes | Service principal client secret | |
| `auth.username` | no | Username of your choice; used in securing this broker; _do not use this default value in production!_ | `"username"` |
| `auth.password` | no | Password of your choice; used in securing this broker; _do not use this default value in production!_ | `"password"` |
| `database.host` | yes | DNS-resolvable hostname for the SQL Server RDBMS | |
| `database.dbName` | yes | Name of the SQL Server database | |
| `database.username` | yes | Database username | |
| `database.password` | yes | Database password | |
| `database.encryptionKey` | no | 256 bit key used for database encryption; _do not use this default value in production!_ | `"This is a key that is 256 bits!!"` |
