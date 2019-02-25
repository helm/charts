# CraftCMS

[Craft](https://craftcms.com/) is a flexible, user-friendly CMS for creating custom digital experiences on the web and beyond. (From CraftCMS docs)

## Introduction

This chart bootstraps a [CraftCMS](https://craftcms.com/) deployment on a Kubernetes cluster using the Helm package manager.

It includes MariaDB deployment for running MySQL database of CraftCMS application.

This chart also includes Traefik Ingress Controller which can be disabled if not needed.

It also includes Redis integrated with CraftCMS.

This chart uses [wyveo CraftCMS docker image](https://github.com/wyveo/craftcms-docker). We might create and use our own docker image in future releases.

## Prerequisites

PV provisioner support in the underlying infrastructure for persistent storage

## Installing the Chart

Please issue the following command to install the chart with the name `my-release`:

```bash
$ helm install --name my-release incubator/craftcms
```

This will install CraftCMS deployment onto the Kubernetes cluster using default values from the `values.yaml` file. You may find all possible configuration options in the section [Configuration](/Configuration)

## Uninstalling the Chart

Please issue the following command to uninstall the `my-release` deployment:

```bash
helm delete my-release
```

## Configuration

| Parameter | Description | Default |
| --- | --- | --- |
| replicaCount | Number of CraftCMS pods to run | 1 |
| image.repository | CraftCMS image repository | wyveo/craftcms-docker |
| image.tag | CraftCMS image tag | latest |
| image.pullPolicy | Image pull policy | IfNotPresent |
| craftcmsDatabase | CraftCMS database | database |
| craftcmsDatabasePassword | CraftCMS database user password | secret |
| craftcmsDatabaseUser | CraftCMS database user | user |
| mysqlDatabase | Database created in MariaDB deployment | database |
| mysqlUser | Database user created in MariaDB deployment | user |
| mysqlUserPassword | Database user password created in MariaDB deployment | secret |
| mysqlRootPassword | MariaDB root password | change_me |
| additionalSoftware | Commands which will be run during CraftCMS web pod creation and upon each restart (Please put && at the end of your command) | nil |
| serviceWeb.type | Kubernetes service type for web | ClusterIP |
| serviceWeb.port | Kubernetes service port for web | 80 |
| serviceRedis.type | Kubernetes service type for redis | ClusterIP |
| serviceRedis.port | Kubernetes service port for redis | 6379 |
| serviceMysql.type | Kubernetes service type for mysql | ClusterIP |
| serviceMysql.port | Kubernetes service port for mysql | 3306 |
| ingress.enabled | Enable ingress rules | true |
| ingress.annotations | Ingress annotations	| [kubernetes.io/ingress.class: traefik, kubernetes.io/tls-acme: "true"] |
| ingress.paths | Path within the url structure	| / |
| ingress.hosts | Hostname to your CraftCMS installation | craft_domain.com |
| persistence.storage.data | PVC storage request for CraftCMS data | 20Gi |
| persistence.storage.mysql | PVC storage request for MariaDB | 20Gi |
| persistence.storage.redis | PVC storage request for Redis | 1Gi |
| persistence.accessmode | PVC Access Mode | ReadWriteOnce |
| traefik.enabled | Enable Traefik Ingress Controller | true |
| traefik.replicas | The number of replicas to run; NOTE: Full Traefik clustering with leader election is not yet supported, which can affect any configured Let's Encrypt setup | 1 |
| traefik.serviceType | A valid Kubernetes service type	| LoadBalancer |
| traefik.externalIP | Static IP for the service | nil |
| traefik.ssl.enabled | Whether to enable HTTPS	| true |
| traefik.ssl.enforced | Whether to redirect HTTP requests to HTTPS	| true |
| traefik.ssl.defaultCert | Base64 encoded default certificate | A self-signed certificate |
| traefik.ssl.defaultKey | Base64 encoded private key for the certificate above	| The private key for the certificate above |
| traefik.acme.enabled | Whether to use Let's Encrypt to obtain certificates | true |
| traefik.acme.email | Email address to be used in certificates obtained from Let's Encrypt	| your_email@domain.com |
| traefik.acme.staging | Whether to get certs from Let's Encrypt's staging environment | true |
| traefik.acme.domains.enabled | Enable certificate creation by default for specific domain	| true |
| traefik.acme.challengeType | Type of ACME challenge to perform domain validation. tls-sni-01 (deprecated), tls-alpn-01 (recommended), http-01 or dns-01 | http-01 |
| traefik.dashboard.enabled | Whether to enable the Traefik dashboard | true |
| traefik.dashboard.domain | Domain for the Traefik dashboard | traefik.domain.com |
| traefik.dashboard.auth.basic | Basic auth for the Traefik dashboard specified as a map | `admin: $apr1$rGIU2WB2$74uZGzAlaBIEziaPumMHY1` |
| traefik.rbac.enabled | Whether to enable RBAC with a specific cluster role and binding for Traefik | true |
| traefik.deployment.hostPort.httpEnabled | Whether to enable hostPort binding to host for http. | false |
| traefik.deployment.hostPort.httpsEnabled | Whether to enable hostPort binding to host for https. | false |
| traefik.deployment.hostPort.dashboardEnabled | Whether to enable hostPort binding to host for dashboard. | false |
| nodeSelector | Node labels for pod assignment	| {} |
| tolerations | List of node taints to tolerate	 | [] |
| affinity | Map of node/pod affinities	| {} |

## Traefik

The above section includes some of the values which `traefik` could provide. In case more sophisticated configration of this ingress controller is required - you may refer to [Traefik Helm Chart](https://github.com/helm/charts/tree/master/stable/traefik) and include any values you require.
You may also refer to the comments in the `values.yaml` file for more information regarding configuration.

## Setting values

You can specify any parameter for the helm chart using the `--set key=value,key=value` argument for the `helm install` command.

Alternatively, you may download and edit the `values.yaml` file to what you require.

## CraftCMS values

All values which are related to CraftCMS installation (e.g. `craftcmsDatabase` or `craftcmsDatabaseUser`) are put into CraftCMS container as environment variables, without referring to `.env` file. All other values which are not included here (such as redis host or port, or MySQL host/port) are generated during deployment and put into environment variables as well.

## Persistence

PVC's are used to store CraftCMS data (/usr/share/nginx folder), MariaDB data (/var/lib/mysql), Redis data (/data), as well as Traefik certificates (if enabled).

## Ingress

This chart supports ingress resources creation. If this is a fresh cluster, or no ingress controller is installed, you need to enable both ingress and traefik in the chart values. Otherwise, having traefik installed, you need to disable traefik but leave ingress enabled.

In case you have any other ingress controller installed (such as nginx-ingress) please change `ingress.annotations` to reflect your current setup.

## N.B.

This helm chart is still being developed, so in case of any issues/suggestions, please let us know.
