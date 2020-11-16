# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Apache Ignite

This is a helm chart for [Apache Ignite](https://ignite.apache.org/)

Apache Ignite is an open-source memory-centric distributed database, caching,
and processing platform for transactional, analytical, and streaming workloads
delivering in-memory speeds at petabyte scale

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Install

```console
helm install --name my-release stable/ignite
```

## Configuration

| Parameter                       | Description                                                                                                    | Default                                                                                                                           |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `replicaCount`                  | Number of pods for ignite applications                                                                         | `2`                                                                                                                               |
| `image.repository`              | Image repository                                                                                               | `apacheignite/ignite`                                                                                                             |
| `image.tag`                     | Image tag                                                                                                      | `2.7.6`                                                                                                                           |
| `image.pullPolicy`              | Image pull policy                                                                                              | `IfNotPresent`                                                                                                                    |
| `nameOverride`                  | String to partially override ignite.fullname template with a string (will prepend the release name)            | `nil`                                                                                                                             |
| `fullnameOverride`              | String to fully override ignite.fullname template with a string                                                | `nil`                                                                                                                             |
| `rbac.create`                   | Whether or not to create RBAC items (e.g. role, role-binding)                                                  | `true`                                                                                                                            |
| `serviceAccount.create`         | Whether or not to create dedicated serviceAccount for ignite                                                   | `true`                                                                                                                            |
| `serviceAccount.name`           | If `serviceAccount.create` is enabled, what should the `serviceAccount` name be - otherwise randomly generated | `nil`                                                                                                                             |
| `dataStorage.config`            | Additional config for `org.apache.ignite.configuration.DataStorageConfiguration` class                         | `nil`                                                                                                                             |
| `env`                           | Dictionary (key/value) for additional environment for pod templates (if you need refs use envVars)             | `{ "OPTION_LIBS": "ignite-kubernetes,ignite-rest-http", "IGNITE_QUIET": "false", "JVM_OPTS": "-Djava.net.preferIPv4Stack=true" }` |
| `envVars`                       | Array of Dictionaries (key/value) for additional environment for pod templates                                 | `nil`                                                                                                                             |
| `envFrom`                       | Array of Dictionaries (key/value) for additional environment from secrets/configmaps for pod templates         | `nil`                                                                                                                             |
| `extraInitContainers`           | additional Init Containers to run in the pods                                                                  | `[]`                                                                                                                              |
| `extraContainers`               | additional containers to run in the pods                                                                       | `[]`                                                                                                                              |
| `peerClassLoadingEnabled`       | (Boolean) Enable the ignite's [Zero Deployment](https://apacheignite.readme.io/docs/zero-deployment)           | `false`                                                                                                                           |
| `persistence.enabled`           | (Boolean) Enable any persistent settings for ignite - both application and WAL                                 | `true`                                                                                                                            |
| `persistence.persistenceVolume` | Persistent volume definition for ignite application                                                            | `{ "size": "8Gi", "provisioner": "kubernetes.io/aws-ebs", "provisionerParameters": { "type": "gp2", "fsType": "ext4" } }`         |
| `persistence.walVolume`         | Persistent volume definition for WAL storage                                                                   | `{ "size": "8Gi", "provisioner": "kubernetes.io/aws-ebs", "provisionerParameters": { "type": "gp2", "fsType": "ext4" } }`         |
| `extraVolumes`                  | Extra volumes                                                                                                  | `nil`                                                                                                                             |
| `extraVolumeMounts`             | Mount extra volume(s)                                                                                          | `nil`                                                                                                                             |
| `resources`                     | Pod request/limits                                                                                             | `{}`                                                                                                                              |
| `nodeSelector`                  | Node selector for ignite application                                                                           | `{}`                                                                                                                              |
| `tolerations`                   | Node tolerations for ignite application                                                                        | `[]`                                                                                                                              |
| `affinity`                      | Node affinity for ignite application                                                                           | `{}`                                                                                                                              |
| `priorityClassName`             | Pod Priority Class Name for ignite application                                                                 | `""`                                                                                                                              |

## DataStorage

Ignite can served as both database and caching service. By editing "memory and disk usage modes", 

## Persistence

Data persistence and WAL persistence can be enabled by specifying appropriate
variables. Please note that default persistence configuration is for AWS EBS.

```console
helm install --name my-release \
    --set persistence.enabled=true \
    --set persistence.persistenceVolume.size=100Gi \
    --set persistence.walVolume.size=100Gi \
    stable/ignite
```

To configure persistence for other volume plugins you should edit
`persistence.(persistenceVolume|walVolume).provisioner` and `persistence.(persistenceVolume|walVolume).provisionerParameters` variables.
