# Bookstack

[Bookstack](https://www.bookstackapp.com) is a simple, easy-to-use platform for organising and storing information.

## TL;DR;

```bash
$ helm install stable/bookstack
```

## Introduction

This chart bootstraps a [Bookstack](https://hub.docker.com/r/solidnerd/bookstack/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also uses the [MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which satisfies the database requirements of the application.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm update --install my-release stable/bookstack
```

The command deploys Bookstack on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redmine chart and their default values.

|            Parameter                |              Description                                                                     |               Default                       | 
| ----------------------------------  | -------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `replicaCount`                      | Number of replicas to start                                                                  | `1`                                         |
| `image.repository`                  | Bookstack image name                                                                         | `solidnerd/bookstack`                       |
| `image.tag`                         | Bookstack image tag                                                                          | `0.27.4-1`                                  |
| `image.pullPolicy`                  | Bookstack image pull policy                                                                  | `IfNotPresent`                              |
| `externalDatabase.host`             | Host of the external database                                                                | `nil`                                       |
| `externalDatabase.port`             | Port of the external database                                                                | `3306`                                      |
| `externalDatabase.user`             | Existing username in the external db                                                         | `bookstack`                                 |
| `externalDatabase.password`         | Password for the above username                                                              | `nil`                                       |
| `externalDatabase.database`         | Name of the existing database                                                                | `bookstack`                                 |
| `mariadb.enabled`                   | Whether to use the MariaDB chart                                                             | `true`                                      |
| `mariadb.db.name`                   | Database name to create                                                                      | `bookstack`                                 |
| `mariadb.db.user`                   | Database user to create                                                                      | `bookstack`                                 |
| `mariadb.db.password`               | Password for the database                                                                    | `nil`                                       |
| `mariadb.rootUser.password`         | MariaDB admin password                                                                       | `nil`                                       |
| `mariadb.master.persistence.enabled`        | Enable MariaDB persistence using PVC                                                 | `true`                                      |
| `mariadb.master.persistence.storageClass`   | PVC Storage Class for MariaDB volume                                                 | `nil` (uses alpha storage class annotation) |
| `mariadb.master.persistence.accessMode`     | PVC Access Mode for MariaDB volume                                                   | `ReadWriteOnce`                             |
| `mariadb.master.persistence.size`           | PVC Storage Request for MariaDB volume                                               | `8Gi`                                       |
| `service.type`                      | Desired service type                                                                         | `ClusterIP`                                 |
| `service.port`                      | Service exposed port                                                                         | `80`                                        |
| `podSecurityPolicy.enabled`         | Create & use Pod Security Policy resources                                                   | `false`                                     |
| `rbac.create`                       | Use Role-based Access Control                                                                | `true`                                      |
| `serviceAccount.create`             | Should we create a ServiceAccount                                                            | `true`                                      |
| `serviceAccount.name`               | Name of the ServiceAccount to use                                                            | `null`                                      |
| `persistence.uploads.enabled`       | Enable persistence using PVC for uploads                                                     | `true`                                      |
| `persistence.uploads.storageClass`  | PVC Storage Class                                                                            | `nil` (uses alpha storage class annotation) |
| `persistence.uploads.accessMode`    | PVC Access Mode                                                                              | `ReadWriteMany`                             |
| `persistence.uploads.size`          | PVC Storage Request                                                                          | `8Gi`                                       |
| `persistence.uploads.existingClaim` | If PVC exists & bounded for uploads                                                          | `nil` (when nil, new one is requested)      |
| `persistence.storage.enabled`       | Enable persistence using PVC for uploads                                                     | `true`                                      |
| `persistence.storage.storageClass`  | PVC Storage Class                                                                            | `nil` (uses alpha storage class annotation) |
| `persistence.storage.accessMode`    | PVC Access Mode                                                                              | `ReadWriteMany`                             |
| `persistence.storage.size`          | PVC Storage Request                                                                          | `8Gi`                                       |
| `persistence.storage.existingClaim` | If PVC exists & bounded for storage                                                          | `nil` (when nil, new one is requested)      |
| `ingress.enabled`                   | Enable or disable the ingress                                                                | `false`                                     |
| `ingress.hosts`                     | The virtual host name(s)                                                                     | `{}`                                        |
| `ingress.annotations`               | An array of service annotations                                                              | `nil`                                       |
| `ingress.tls[i].secretName`         | The secret kubernetes.io/tls                                                                 | `nil`                                       |
| `ingress.tls[i].hosts[j]`           | The virtual host name                                                                        | `nil`                                       |
| `resources`                         | Resources allocation (Requests and Limits)                                                   | `{}`                                        |
| `ldap.enabled`                      | Enable or disable LDAP authentication. [See official docs for details](https://www.bookstackapp.com/docs/admin/ldap-auth/) | `false`       |
| `ldap.server`                       | LDAP server address                                                                          | `nil`                                       |
| `ldap.base_dn`                      | Base DN where users will be searched                                                         | `nil`                                       |
| `ldap.dn`                           | User which will make search queries. Leave empty to search anonymously.                      | `nil`                                       |
| `ldap.pass`                         | Password of user performing search queries.                                                  | `nil`                                       |
| `ldap.userFilter`                   | A filter to use when searching for users                                                     | `nil`                                       |
| `ldap.version`                      | Set the LDAP version to use when connecting to the server. Required especially when using AD.| `nil`                                       |
| `oauth.google.enabled`              | Enable or disable OAuth authentication with Google                                           | `false`                                     |
| `oauth.google.autoRegister`         | Enable or disable automatic email confirmation for OAuth authentication Google               | `false`                                     |
| `oauth.google.secret`               | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.google.appIdKey`             | Set key of the secret for GitHub app id key                                                  | `googleAppSecretKey`                        |
| `oauth.google.appSecretKey`         | Set key of the secret for GitHub app secret key                                              | `googleAppSecretKey`                        |
| `oauth.github.enabled`              | Enable or disable OAuth authentication with GitHub                                           | `false`                                     |
| `oauth.github.autoRegister`         | Enable or disable automatic email confirmation for OAuth authentication GitHub               | `false`                                     |
| `oauth.github.secret`               | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.github.appIdKey`             | Set key of the secret for GitHub app id key                                                  | `githubAppSecretKey`                        |
| `oauth.github.appSecretKey`         | Set key of the secret for GitHub app secret key                                              | `githubAppSecretKey`                        |
| `oauth.twitter.enabled`             | Enable or disable OAuth authentication with Twitter                                          | `false`                                     |
| `oauth.twitter.autoRegister`        | Enable or disable automatic email confirmation for OAuth authentication Twitter              | `false`                                     |
| `oauth.twitter.secret`              | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.twitter.appIdKey`            | Set key of the secret for Twitter app id key                                                 | `twitterAppSecretKey`                       |
| `oauth.twitter.appSecretKey`        | Set key of the secret for Twitter app secret key                                             | `twitterAppSecretKey`                       |
| `oauth.facebook.enabled`            | Enable or disable OAuth authentication with Facebook                                         | `false`                                     |
| `oauth.facebook.autoRegister`       | Enable or disable automatic email confirmation for OAuth authentication Facebook             | `false`                                     |
| `oauth.facebook.secret`             | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.facebook.appIdKey`           | Set key of the secret for Facebook app id key                                                | `facebookAppSecretKey`                      |
| `oauth.facebook.appSecretKey`       | Set key of the secret for Facebook app secret key                                            | `facebookAppSecretKey`                      |
| `oauth.slack.enabled`               | Enable or disable OAuth authentication with Slack                                            | `false`                                     |
| `oauth.slack.autoRegister`          | Enable or disable automatic email confirmation for OAuth authentication Slack                | `false`                                     |
| `oauth.slack.secret`                | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.slack.appIdKey`              | Set key of the secret for Slack app id key                                                   | `slackAppSecretKey`                         |
| `oauth.slack.appSecretKey`          | Set key of the secret for Slack app secret key                                               | `slackAppSecretKey`                         |
| `oauth.azure.enabled`               | Enable or disable OAuth authentication with AzureAD                                          | `false`                                     |
| `oauth.azure.autoRegister`          | Enable or disable automatic email confirmation for OAuth authentication AzureAD              | `false`                                     |
| `oauth.azure.secret`                | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.azure.appIdKey`              | Set key of the secret for AzureAD app id key                                                 | `azureAppSecretKey`                         |
| `oauth.azure.appSecretKey`          | Set key of the secret for AzureAD app secret key                                             | `azureAppSecretKey`                         |
| `oauth.azure.tenant`                | Set the tenant for AzureAD                                                                   | `azureAppSecretKey`                         |
| `oauth.okta.enabled`                | Enable or disable OAuth authentication with Okta                                             | `false`                                     |
| `oauth.okta.autoRegister`           | Enable or disable automatic email confirmation for OAuth authentication Okta                 | `false`                                     |
| `oauth.okta.secret`                 | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.okta.appIdKey`               | Set key of the secret for Okta app id key                                                    | `oktaAppSecretKey`                          |
| `oauth.okta.appSecretKey`           | Set key of the secret for Okta app secret key                                                | `oktaAppSecretKey`                          |
| `oauth.okta.baseUrl`                | Set the base URL for Okta                                                                    | `azureAppSecretKey`                         |
| `oauth.gitlab.enabled`              | Enable or disable OAuth authentication with GitLab                                           | `false`                                     |
| `oauth.gitlab.autoRegister`         | Enable or disable automatic email confirmation for OAuth authentication GitLab               | `false`                                     |
| `oauth.gitlab.secret`               | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.gitlab.appIdKey`             | Set key of the secret for GitLab app id key                                                  | `gitlabAppSecretKey`                        |
| `oauth.gitlab.appSecretKey`         | Set key of the secret for GitLab app secret key                                              | `gitlabAppSecretKey`                        |
| `oauth.gitlab.baseUrl`              | Set the base URL for GitLab (ONLY REQURED FOR SELF-HOSTE)                                    | `azureAppSecretKey`                         |
| `oauth.twitch.enabled`              | Enable or disable OAuth authentication with Twitch                                           | `false`                                     |
| `oauth.twitch.autoRegister`         | Enable or disable automatic email confirmation for OAuth authentication Twitch               | `false`                                     |
| `oauth.twitch.secret`               | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.twitch.appIdKey`             | Set key of the secret for Twitch app id key                                                  | `twitchAppSecretKey`                        |
| `oauth.twitch.appSecretKey`         | Set key of the secret for Twitch app secret key                                              | `twitchAppSecretKey`                        |
| `oauth.discord.enabled`             | Enable or disable OAuth authentication with Discord                                          | `false`                                     |
| `oauth.discord.autoRegister`        | Enable or disable automatic email confirmation for OAuth authentication Discord              | `false`                                     |
| `oauth.discord.secret`              | Set name of the secret for OAuth authentication                                              | `OAuthBookstack`                            |
| `oauth.discord.appIdKey`            | Set key of the secret for Discord app id key                                                 | `discordAppSecretKey`                       |
| `oauth.discord.appSecretKey`        | Set key of the secret for Discord app secret key                                             | `discordAppSecretKey`                       |


The above parameters map to the env variables defined in the [Bookstack image](https://hub.docker.com/r/solidnerd/bookstack/) and the MariaDB/MySQL database settings. For more information please refer to the [Bookstack](https://hub.docker.com/r/solidnerd/bookstack/) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm upgrade --install my-release \
  --set podSecurityPolicy.enabled=true \
    stable/bookstack
```

The above command enables podSecurityPolicy.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm upgrade --install my-release -f values.yaml stable/bookstack
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Replicas

Bookstack writes uploaded files to a persistent volume. By default that volume
cannot be shared between pods (RWO). In such a configuration the `replicas` option
must be set to `1`. If the persistent volume supports more than one writer
(RWX), ie NFS, `replicaCount` can be greater than `1`.

## Persistence

The [Bookstack](https://hub.docker.com/r/solidnerd/bookstack/) image stores the uploaded data at the `public/uploads` path, relative to the document root of the Bookstack application. Other misc. data is stored under the `public/storage` path, also relative to the document root of the application.

Persistent Volume Claims are used to keep the data across deployments. The volume is created using dynamic volume provisioning.

See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaims

The following example includes two PVCs, one for uploads and another for misc. data.

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Create the directory, on a worker
1. Install the chart

```bash
$ helm upgrade --install test --set persistence.uploads.existingClaim=PVC_UPLOADS,persistence.storage.existingClaim=PVC_STORAGE stable/bookstack
```
