# Ark-server

This helm chart install ark-server version v0.6.0

## Premise
Helm cannot handle properly CRD becauses it has a validation mechanism that checks the installation before the CRD are actually created,
hence each resource that uses a CRD cannot be validated because the CRD doesn't exist yet!

The trick here is to create CRD via helm chart, and only after (using a `post-install`) to install the resources with a container.
The container has the only job to execute a `kubectl create -f filename` and create the resources.

At the same time the resources created with the hook are completely transparent to Helm, that is, when you delete the
chart those resources remain there. Hence we need a sencond hook for deleting them (see delete.yaml)

## Content
- `templates/00-prereqs.yaml` this file contains the CRD needed by ARK
- `install.yaml` This is the container that will deploy ark-server and its configuration
- `configmap.yaml` Configmap will be mounted to the container as a file and subsequently used as k8s manifest for deploy
- `delete.yaml` Deletes the resources created by `install.yaml`

## ConfigMap customization
Since we want to have a customizable chart it's important that the configmap is a template and not a static file.
To do this we add the keyword `tpl` when reading the file
- {{ (tpl (.Files.Glob "static/*").AsConfig .) | indent 2 }}

## Heptio Secret
Ark server needs a IAM service accoutn in order to run, if you don't have it you must create it: 
https://github.com/heptio/ark/blob/v0.6.0/docs/cloud-provider-specifics.md#gcp


And then
```
kubectl create secret generic cloud-credentials --namespace heptio-ark --from-file cloud=credentials-ark
```

## How to
```
helm install --name ark-server --namespace heptio-ark ./ark-server
```
