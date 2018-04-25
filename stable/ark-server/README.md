# Ark-server

This helm chart install ark-server version v0.8.1
https://github.com/heptio/ark/tree/v0.8.1

## Premise
Helm cannot handle properly CRD becauses it has a validation mechanism that checks the installation before the CRD are actually created,
hence each resource that uses a CRD cannot be validated because the CRD doesn't exist yet!

The trick here is to create CRD via helm chart, and only after (using a `post-install`) to install the resources with a container.
The container has the only job to execute a `kubectl create -f filename` and create the resources.

At the same time the resources created with the hook are completely transparent to Helm, that is, when you delete the
chart those resources remain there. Hence we need a sencond hook for deleting them (see hook-delete.yaml)

## Content
- `templates/backups.yaml`
  `configs`
  `schedules`
  `downloadrequest`  these files contain the custom resouces needed by Ark Server
- `hook_delete.yaml` and `hook_deploy.yaml` are the containers that will deploy or delete ark-server configuration
- `configmap.yaml` Configmap will be mounted to the hook container as a file and subsequently used as k8s manifest for deploy or deletion

## ConfigMap customization
Since we want to have a customizable chart it's important that the configmap is a template and not a static file.
To do this we add the keyword `tpl` when reading the file
- {{ (tpl (.Files.Glob "configuration/").AsConfig .) | indent 2 }}


## Prerequisites

### Heptio Secret
Ark server needs a IAM service account in order to run, if you don't have it you must create it.
This is the guide for gcp: https://github.com/heptio/ark/blob/v0.8.1/docs/gcp-config.md#create-service-account

Don't forget the step to create the secret
```
kubectl create secret generic cloud-credentials --namespace <ARK_NAMESPACE> --from-file cloud=credentials-ark
```

### Configuration
Please change the values.yaml according to your setup
See here for the official documentation https://github.com/heptio/ark/blob/v0.8.1/docs/config-definition.md

Parameter | Description | Default | Required
--- | --- | --- | ---
`cloudprovider` | Cloud provider  | `nil` | yes
`bucket` | Object storage where to store backups  | `nil` | yes
`region` | AWS region  | `nil` | only if using AWS
`credentials` | Credentials  | `nil` | Yes (not required for kube2iam)
`kube2iam` | Enable kube2iam  | `false` | No
`backupSyncPeriod` | How frequently Ark queries the object storage to make sure that the appropriate Backup resources have been created for existing backup files. | `60m` | yes
`gcSyncPeriod` | How frequently Ark queries the object storage to delete backup files that have passed their TTL.  | `60m` | yes
`scheduleSyncPeriod` | How frequently Ark checks its Schedule resource objects to see if a backup needs to be initiated  | `1m` | yes
`restoreOnlyMode` | When RestoreOnly mode is on, functionality for backups, schedules, and expired backup deletion is turned off. Restores are made from existing backup files in object storage.  | `false` | yes

## How to
```
helm install --name ark-server --namespace heptio-ark ./ark-server
```

## Remove heptio/ark
Rememebr that when you remove ark all backups remain untouched
