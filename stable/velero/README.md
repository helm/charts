# Velero-server

This helm chart installs Velero version v1.0.0
https://github.com/heptio/velero/tree/v1.0.0


## Upgrading to v1.0.0

As of v1.0.0, Heptio Velero is no longer backwards-compatible with Heptio Ark.

The [instructions found here](https://velero.io/docs/v1.0.0/upgrade-to-1.0/) will assist you in upgrading from version v0.11.0 to v1.0.0

## Upgrading to v0.11.0

As of v0.11.0, Heptio Ark has become Velero.

The [instructions found here](https://velero.io/docs/v0.11.0/migrating-to-velero/) will assist you in upgrading from Ark to Velero

## Prerequisites

### Secret for cloud provider credentials
Velero server needs an IAM service account in order to run, if you don't have it you must create it.
Please follow the official documentation: https://velero.io/docs/v1.0.0/install-overview/

Don't forget the step to create the secret
```
kubectl create secret generic cloud-credentials --namespace <VELERO_NAMESPACE> --from-file cloud=credentials-velero
```

### Configuration
Please change the values.yaml according to your setup
See here for the official documentation https://velero.io/docs/v1.0.0/install-overview/

#### Required Parameters
Parameter | Description | Default | Required
--- | --- | --- | ---
`configuration.provider` | The name of the cloud provider where you are deploying velero to (`aws`, `azure`, `gcp`) | none | yes
`configuration.backupStorageLocation.name` | The name of the cloud provider that will be used to actually store the backups (`aws`, `azure`, `gcp`) | none | yes
`configuration.backupStorageLocation.bucket` | The storage bucket where backups are to be uploaded | none | yes
`configuration.backupStorageLocation.config.region` | The cloud provider region (AWS only) | none | yes, if using AWS
`configuration.backupStorageLocation.config.resourceGroup` | The resource group containing the storage account (Azure only) | none | yes, if using Azure
`configuration.backupStorageLocation.config.storageAccount` | The storage account containing the blob container (Azure only) | none | yes, if using Azure
`configuration.volumeSnapshotLocation.name` | The name of the cloud provider the cluster is using for persistent volumes, if any | none | yes, if using PV snapshots
`configuration.volumeSnapshotLocation.config.region` | The cloud provider region (AWS only) | none | yes, if using AWS
`configuration.volumeSnapshotLocation.config.apitimeout` | The API timeout (Azure only) | none | yes, if using Azure
`credentials.useSecret` | Whether a secret should be used for IAM credentials. Set this to `false` when using `kube2iam` | `true` | yes
`credentials.existingSecret` | If specified and `useSecret` is `true`, uses an existing secret with this name instead of creating one | none | yes, if `useSecret` is `true` and `secretContents` is empty
`credentials.secretContents` | If specified and `useSecret` is `true`, contents for the credentials secret | none | yes, if `useSecret` is `true` and `existingSecret` is empty

#### All Parameters
Parameter | Description | Default
--- | --- | ---
`image.repository` | Image repository | `gcr.io/heptio-images/velero`
`image.tag` | Image tag | `v1.0.0`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`podAnnotations` | Annotations for the Velero server pod | `{}`
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
`configuration.backupStorageLocation.config.resourceGroup` | The resource group containing the storage account (Azure only) | ``
`configuration.backupStorageLocation.config.storageAccount` | The storage account containing the blob container (Azure only) | ``
`configuration.backupStorageLocation.prefix` | The directory inside a storage bucket where backups are to be uploaded | ``
`configuration.backupSyncPeriod` | How frequently Velero queries the object storage to make sure that the appropriate Backup resources have been created for existing backup files | (uses `velero server` default)
`configuration.extraEnvVars` | Key/values for extra environment variables such as AWS_CLUSTER_NAME, etc | `{}`
`configuration.provider` | The name of the cloud provider where you are deploying velero to (`aws`, `azure`, `gcp`) |
`configuration.restoreResourcePriorities` | An ordered list that describes the order in which Kubernetes resource objects should be restored | (uses `velero server` default)
`configuration.resticTimeout` | How long backups/restores of pod volumes should be allowed to run before timing out. | (uses `velero server` default)
`configuration.restoreOnlyMode` | When RestoreOnly mode is on, functionality for backups, schedules, and expired backup deletion is turned off. Restores are made from existing backup files in object storage | (uses `velero server` default)
`configuration.volumeSnapshotLocation.name` | The name of the cloud provider the cluster is using for persistent volumes, if any | `{}`
`configuration.volumeSnapshotLocation.config.region` | The cloud provider region (AWS only) | ``
`configuration.volumeSnapshotLocation.config.apitimeout` | The API timeout (`azure` only) |
`configuration.volumeSnapshotLocation.config.resourceGroup` | The name of the resource group where volume snapshots should be stored, if different from the cluster’s resource group. (Azure only) |
`configuration.volumeSnapshotLocation.config.project` | The project ID where snapshots should be stored, if different than the project that your IAM account is in. (GCP only) |
`configuration.volumeSnapshotLocation.config.snapshotLocation` | The location where the snapshots will be stored. (GCP only) |
`credentials.existingSecret` | If specified and `useSecret` is `true`, uses an existing secret with this name instead of creating one | ``
`credentials.useSecret` | Whether a secret should be used. Set this to `false` when using `kube2iam` | `true`
`credentials.secretContents` | Contents for the credentials secret | `{}`
`deployRestic` | If `true`, enable restic deployment | `false`
`metrics.enabled` | Set this to `true` to enable exporting Prometheus monitoring metrics | `false`
`metrics.scrapeInterval` | Scrape interval for the Prometheus ServiceMonitor | `30s`
`metrics.serviceMonitor.enabled` | Set this to `true` to create ServiceMonitor for Prometheus operator | `false`
`metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`
`schedules` | A dict of schedules | `{}`
`restic.podVolumePath` | Location of pod volumes on the host | `/var/lib/kubelet/pods`
`restic.privileged` | Whether restic should run as a privileged pod. Only necessary in special cases (SELinux) | `false`

## How to
```
helm install --name velero --namespace velero ./velero
```

## Remove heptio/velero
Remember that when you remove Velero all backups remain untouched
