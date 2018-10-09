# Ark-server

This helm chart installs Ark version v0.9.0
https://github.com/heptio/ark/tree/v0.9.0

## Premise
In general, Helm cannot install CRDs and resources based on these CRDs in the same Helm chart because CRDs need to be installed before CRD
resources can be created and Helm cannot guarantee the correct ordering for this to work.

As a workaround, the chart creates a Config resource via post-install hook.
Since resources created by hooks are not managed by Helm, a pre-delete hook removes the Config CRD when the release is deleted.

At the same time the resources created with the hook are completely transparent to Helm, that is, when you delete the
chart those resources remain there. Hence we need a second hook for deleting them (see hook-delete.yaml)

## ConfigMap customization
Since we want to have a customizable chart it's important that the configmap is a template and not a static file.
To do this we add the keyword `tpl` when reading the file
- {{ (tpl (.Files.Glob "configuration/").AsConfig .) | indent 2 }}


## Prerequisites

### Secret for cloud provider credentials
Ark server needs an IAM service account in order to run, if you don't have it you must create it.
Please follow the official documentation: https://heptio.github.io/ark/v0.9.0/cloud-common

Don't forget the step to create the secret
```
kubectl create secret generic cloud-credentials --namespace <ARK_NAMESPACE> --from-file cloud=credentials-ark
```

### Configuration
Please change the values.yaml according to your setup
See here for the official documentation https://heptio.github.io/ark/v0.9.0/config-definition

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
`kubectl.image` | A docker image with kubectl, required by hook-deploy.yaml and hook-delete.yaml  | `docker pull claranet/gcloud-kubectl-docker` | yes

Parameter | Description | Default
--- | --- | ---
`image.repository` | Image repository | `gcr.io/heptio-images/ark`
`image.tag` | Image tag | `v0.9.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`kubectl.image.repository` | Image repository | `claranet/gcloud-kubectl-docker`
`kubectl.image.tag` | Image tag | `1.0.0`
`kubectl.image.pullPolicy` | Image pull policy | `IfNotPresent`
`podAnnotations` | Annotations for the Ark server pod | `{}`
`rbac.create` | If true, create and use RBAC resources | `true`
`rbac.server.serviceAccount.create` | Whether a new service account name that the server will use should be created | `true`
`rbac.server.serviceAccount.name` | Service account to be used for the server. If not set and `rbac.server.serviceAccount.create` is `true` a name is generated using the fullname template | ``
`rbac.hook.serviceAccount.create` | Whether a new service account name that the hook will use should be created | `true`
`rbac.hook.serviceAccount.name` | Service account to be used for the server. If not set and `rbac.hook.serviceAccount.create` is `true` a name is generated using the fullname template | ``
`resources` | Resource requests and limits | `{}`
`tolerations` | List of node taints to tolerate | `[]`
`nodeSelector` | Node labels for pod assignment | `{}`
`configuration.persistentVolumeProvider.name` | The name of the cloud provider the cluster is using for persistent volumes, if any | `{}`
`configuration.persistentVolumeProvider.config.region` | The cloud provider region (AWS only) | ``
`configuration.persistentVolumeProvider.config.apiTimeout` | The API timeout (Azure only) |
`configuration.backupStorageProvider.nam` | The name of the cloud provider that will be used to actually store the backups (`aws`, `azure`, `gcp`) | ``
`configuration.backupStorageProvider.bucket` | The storage bucket where backups are to be uploaded | ``
`configuration.backupStorageProvider.config.regio`n | The cloud provider region (AWS only) | ``
`configuration.backupStorageProvider.config.s3ForcePathStyle` | Set to `true` for a local storage service like Minio | ``
`configuration.backupStorageProvider.config.s3Url` | S3 url (primarily used for local storage services like Minio) | ``
`configuration.backupStorageProvider.config.kmsKeyId` | KMS key for encryption (AWS only) | ``
`configuration.backupSyncPeriod` | How frequently Ark queries the object storage to make sure that the appropriate Backup resources have been created for existing backup files | `60m`
`configuration.gcSyncPeriod` | How frequently Ark queries the object storage to delete backup files that have passed their TTL | `60m`
`configuration.scheduleSyncPeriod` | How frequently Ark checks its Schedule resource objects to see if a backup needs to be initiated | `1m`
`configuration.resourcePriorities` | An ordered list that describes the order in which Kubernetes resource objects should be restored | `[]`
`configuration.restoreOnlyMode` | When RestoreOnly mode is on, functionality for backups, schedules, and expired backup deletion is turned off. Restores are made from existing backup files in object storage | `false`
`credentials.existingSecret` | If specified and `useSecret` is `true`, uses an existing secret with this name instead of creating one | ``
`credentials.useSecret` | Whether a secret should be used. Set this to `false` when using `kube2iam` | `true`
`credentials.secretContents` | Contents for the credentials secret | `{}`


## How to
```
helm install --name ark --namespace heptio-ark ./ark
```

## Remove heptio/ark
Remember that when you remove Ark all backups remain untouched
