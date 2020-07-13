# DEPRECATED - Velero

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/vmware-tanzu/helm-charts
- **Charts repo:** https://vmware-tanzu.github.io/helm-charts

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

Velero has two main components: a CLI, and a server-side Kubernetes deployment.

## Installing the Velero CLI

See the different options for installing the [Velero CLI](https://velero.io/docs/v1.2.0/install-overview/#install-the-cli).

## Installing the Velero server

This helm chart installs Velero version v1.2.0 https://github.com/vmware-tanzu/velero/tree/v1.2.0. See the [#Upgrading](#upgrading) section for information on how to upgrade from other versions.

### Prerequisites

#### Tiller cluster-admin permissions

A service account and the role binding prerequisite must be added to Tiller when configuring Helm to install Velero:

```
kubectl create sa -n kube-system tiller
kubectl create clusterrolebinding tiller-cluster-admin --clusterrole cluster-admin --serviceaccount kube-system:tiller
helm init --service-account=tiller --wait --upgrade
```

#### Provider credentials

When installing using the Helm chart, the provider's credential information will need to be appended into your values. The easiest way to do this is with the `--set-file` argument, available in Helm 2.10 and higher. See your cloud provider's documentation for the contents and creation of the `credentials-velero` file.

### Installing

The default configuration values for this chart are listed in values.yaml.

See Velero's full [official documentation](https://velero.io/docs/v1.2.0/install-overview/). More specifically, find your provider in the Velero list of [supported providers](https://velero.io/docs/v1.2.0/supported-providers/) for specific configuration information and examples.

#### Option 1) CLI commands

Specify the necessary values using the --set key=value[,key=value] argument to helm install. For example,

```bash
helm install --namespace <YOUR NAMESPACE> \
--set configuration.provider=<PROVIDER NAME> \
--set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
--set configuration.backupStorageLocation.name=<PROVIDER NAME> \
--set configuration.backupStorageLocation.bucket=<BUCKET NAME> \
--set configuration.backupStorageLocation.config.region=<REGION> \
--set configuration.volumeSnapshotLocation.name=<PROVIDER NAME> \
--set configuration.volumeSnapshotLocation.config.region=<REGION> \
--set image.repository=velero/velero \
--set image.tag=v1.2.0 \
--set image.pullPolicy=IfNotPresent \
--set initContainers[0].name=velero-plugin-for-aws \
--set initContainers[0].image=velero/velero-plugin-for-aws:v1.0.0 \
--set initContainers[0].volumeMounts[0].mountPath=/target \
--set initContainers[0].volumeMounts[0].name=plugins \
stable/velero
```

#### Option 2) YAML file

Add/update the necessary values by changing the values.yaml from this repository, then running:

```bash
helm install --namespace <NAMESPACE> -f values.yaml stable/velero
```

#### Upgrade the configuration

If a value needs to be added or changed, you may do so with the `upgrade` command. An example:

```bash
helm upgrade <RELEASE NAME> --set initContainers.backupStorageLocation.name=aws,initContainers.volumeSnapshotLocation.name=aws stable/velero
```

## Upgrading

### Upgrading to v1.2.0

The [instructions found here](https://velero.io/docs/v1.2.0/upgrade-to-1.2/) will assist you in upgrading from version v1.0.0 or v1.1.0 to v1.2.0.

### Upgrading to v1.1.0

The [instructions found here](https://velero.io/docs/v1.1.0/upgrade-to-1.1/) will assist you in upgrading from version v1.0.0 to v1.1.0.

## Uninstall Velero

Note: when you uninstall the Velero server, all backups remain untouched.

```bash
helm delete <RELEASE NAME> --purge
```
