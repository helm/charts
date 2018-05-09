# Ark-server

This helm chart install ark version v0.8.1
https://github.com/heptio/ark/tree/v0.8.1

## Premise
In general, Helm cannot install CRDs and resources based on these CRDs in the same Helm chart because CRDs need to be installed before CRD 
resources can be created and Helm cannot guarantee the correct ordering for this to work.

As a workaround, the chart creates a Config resource via post-install hook.
Since resources created by hooks are not managed by Helm, a pre-delete hook removes the Config CRD when the release is deleted.

At the same time the resources created with the hook are completely transparent to Helm, that is, when you delete the
chart those resources remain there. Hence we need a sencond hook for deleting them (see hook-delete.yaml)

## ConfigMap customization
Since we want to have a customizable chart it's important that the configmap is a template and not a static file.
To do this we add the keyword `tpl` when reading the file
- {{ (tpl (.Files.Glob "configuration/").AsConfig .) | indent 2 }}


## Prerequisites

### Secret for cloud provider credentials
Ark server needs a IAM service account in order to run, if you don't have it you must create it.
Please follow the official documentation: https://heptio.github.io/ark/v0.8.1/cloud-common

Don't forget the step to create the secret
```
kubectl create secret generic cloud-credentials --namespace <ARK_NAMESPACE> --from-file cloud=credentials-ark
```

### Configuration
Please change the values.yaml according to your setup
See here for the official documentation https://heptio.github.io/ark/v0.8.1/config-definition

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

## How to
```
helm install --name ark --namespace heptio-ark ./ark
```

## Remove heptio/ark
Remember that when you remove ark all backups remain untouched
