# Ark-server

This helm chart installs Ark version v0.10.2
https://github.com/heptio/ark/tree/v0.10.2

## Upgrading to v0.10

Ark v0.10.1 introduces breaking changes. The below instructions are based on the [official upgrade guide](https://github.com/heptio/ark/blob/master/docs/upgrading-to-v0.10.md).

1. Pull the latest changes in this chart. If you're using Helm dependencies, update the chart version you're using in your `requirements.yaml` and run `helm dependency update`.

2. Scale down

```sh
kubectl scale -n heptio-ark deploy/ark --replicas 0
```

3. Migrate file structure of your backup storage according to [guide](https://github.com/heptio/ark/blob/master/docs/storage-layout-reorg-v0.10.md)
4. Adjust your `values.yaml` to the new structure and naming
5. Upgrade your deployment

```sh
helm upgrade --force --namespace heptio-ark ark ./ark
```

## Prerequisites

### Secret for cloud provider credentials
Ark server needs an IAM service account in order to run, if you don't have it you must create it.
Please follow the official documentation: https://heptio.github.io/ark/v0.10.0/install-overview

Don't forget the step to create the secret
```
kubectl create secret generic cloud-credentials --namespace <ARK_NAMESPACE> --from-file cloud=credentials-ark
```

### Configuration
Please change the values.yaml according to your setup
See here for the official documentation https://heptio.github.io/ark/v0.10.0/install-overview

Parameter | Description | Default | Required
--- | --- | --- | ---
`cloudprovider` | Cloud provider  | `nil` | yes
`bucket` | Object storage where to store backups  | `nil` | yes
`region` | AWS region  | `nil` | only if using AWS
`apitimeout` | Api Timeout  | `nil` | only if using Azure
`credentials` | Credentials  | `nil` | Yes (not required for kube2iam)
`backupSyncPeriod` | How frequently Ark queries the object storage to make sure that the appropriate Backup resources have been created for existing backup files. | `60m` | yes
`gcSyncPeriod` | How frequently Ark queries the object storage to delete backup files that have passed their TTL.  | `60m` | yes
`scheduleSyncPeriod` | How frequently Ark checks its Schedule resource objects to see if a backup needs to be initiated  | `1m` | yes
`restoreOnlyMode` | When RestoreOnly mode is on, functionality for backups, schedules, and expired backup deletion is turned off. Restores are made from existing backup files in object storage.  | `false` | yes

Parameter | Description | Default
--- | --- | ---
`image.repository` | Image repository | `gcr.io/heptio-images/ark`
`image.tag` | Image tag | `v0.9.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`podAnnotations` | Annotations for the Ark server pod | `{}`
`rbac.create` | If true, create and use RBAC resources | `true`
`rbac.server.serviceAccount.create` | Whether a new service account name that the server will use should be created | `true`
`rbac.server.serviceAccount.name` | Service account to be used for the server. If not set and `rbac.server.serviceAccount.create` is `true` a name is generated using the fullname template | ``
`resources` | Resource requests and limits | `{}`
`initContainers` | InitContainers and their specs to start with the deployment pod | `[]`
`tolerations` | List of node taints to tolerate | `[]`
`nodeSelector` | Node labels for pod assignment | `{}`
`configuration.backupStorageLocation.name` | The name of the cloud provider that will be used to actually store the backups (`aws`, `azure`, `gcp`) | ``
`configuration.backupStorageLocation.bucket` | The storage bucket where backups are to be uploaded | ``
`configuration.backupStorageLocation.config.region` | The cloud provider region (AWS only) | ``
`configuration.backupStorageLocation.config.s3ForcePathStyle` | Set to `true` for a local storage service like Minio | ``
`configuration.backupStorageLocation.config.s3Url` | S3 url (primarily used for local storage services like Minio) | ``
`configuration.backupStorageLocation.config.kmsKeyId` | KMS key for encryption (AWS only) | ``
`configuration.backupStorageLocation.prefix` | The directory inside a storage bucket where backups are to be uploaded | ``
`configuration.backupSyncPeriod` | How frequently Ark queries the object storage to make sure that the appropriate Backup resources have been created for existing backup files | `60m`
`configuration.extraEnvVars` | Key/values for extra environment variables such as AWS_CLUSTER_NAME, etc | `{}`
`configuration.provider` | The name of the cloud provider where you are deploying ark to (`aws`, `azure`, `gcp`) |
`configuration.restoreResourcePriorities` | An ordered list that describes the order in which Kubernetes resource objects should be restored | `namespaces,persistentvolumes,persistentvolumeclaims,secrets,configmaps,serviceaccounts,limitranges,pods`
`configuration.restoreOnlyMode` | When RestoreOnly mode is on, functionality for backups, schedules, and expired backup deletion is turned off. Restores are made from existing backup files in object storage | `false`
`configuration.volumeSnapshotLocation.name` | The name of the cloud provider the cluster is using for persistent volumes, if any | `{}`
`configuration.volumeSnapshotLocation.config.region` | The cloud provider region (AWS only) | ``
`configuration.volumeSnapshotLocation.config.apiTimeout` | The API timeout (`azure` only) |
`credentials.existingSecret` | If specified and `useSecret` is `true`, uses an existing secret with this name instead of creating one | ``
`credentials.useSecret` | Whether a secret should be used. Set this to `false` when using `kube2iam` | `true`
`credentials.secretContents` | Contents for the credentials secret | `{}`
`deployRestic` | If `true`, enable restic deployment | `false`
`metrics.enabled` | Set this to `true` to enable exporting Prometheus monitoring metrics | `false`
`metrics.scrapeInterval` | Scrape interval for the Prometheus ServiceMonitor | `30s`
`metrics.serviceMonitor.enabled` | Set this to `true` to create ServiceMonitor for Prometheus operator | `false`
`metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`
`schedules` | A dict of schedules | `{}`


## How to
```
helm install --name ark --namespace heptio-ark ./ark
```

## Remove heptio/ark
Remember that when you remove Ark all backups remain untouched
