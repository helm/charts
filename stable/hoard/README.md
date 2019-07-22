# Hoard

[Hoard](https://github.com/monax/hoard) is a stateless, deterministically encrypted, content-addressed object store. It currently supports local persistent storage, [S3](https://aws.amazon.com/s3/), [GCS](https://cloud.google.com/storage/), [Azure](https://azure.microsoft.com/en-gb/services/storage/) and [IPFS](https://ipfs.io) backends. Files that are sent to Hoard are symmetrically encrypted, where the secret is the hash of the plaintext file, and then stored in the configured backend - this enables any party with knowledge of the hash or original file to retrieve it from the store.

## Introduction

This chart bootstraps a hoard daemon on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installation

To install the chart with the release name `my-release`, run:

```bash
helm install --name my-release stable/hoard
```

This installation defaults to persistent volume storage. The [configuration](#configuration) section below lists all possible parameters that can be configured.

## Uninstall

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the Hoard chart and its default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | number of daemons | `1` |
| `image.repository` | docker image | `"quay.io/monax/hoard"` |
| `image.tag` | version | `"3.0.1"` |
| `image.pullPolicy` | pull policy | `"IfNotPresent"` |
| `config.listenaddress` | address to listen on | `tcp://:53431` |
| `config.storage.storagetype` | backend object store (aws, azure, filesystem, gcp, ipfs) | `filesystem` |
| `config.storage.addressencoding` | object address encoding | `base64` |
| `config.storage.filesystemconfig.rootdirectory` | object address encoding | `"/data"` |
| `config.storage.cloudconfig.bucket` | object storage container (cloud only) | `""` |
| `config.storage.cloudconfig.prefix` | bucket folder (cloud only) | `""` |
| `config.storage.cloudconfig.region` | object store location (cloud only) | `""` |
| `config.storage.ipfsconfig.remoteapi` | remote api location (ipfs only) | `""` |
| `config.logging.loggingtype` | format for logging output | `"json"` |
| `config.logging.channels` | logging types | `[]` |
| `config.secrets.symmetric` | symmetric secrets (publicid, passphrase) | `[]` |
| `config.secrets.openpgp.privateid` | id of private key to sign with | `""` |
| `config.secrets.openpgp.file` | name of the file mounted from secret | `"/secrets/keyring"` |
| `controller.enabled` | enable the [shared-secrets](https://github.com/monax/shared-secrets) controller | `false` |
| `controller.keep` | keep the shared-secrets crd after chart deletion | `true` |
| `secrets.creds` | required secret for cloud providers | `"cloud-credentials"` |
| `secrets.keyring` | required secret for openpgp grants | `"private-keyring"` |
| `persistence.size` | size of local store | `"10Gi"` |
| `persistence.storageClass` | pvc type | `"standard"` |
| `persistence.accessMode` | pvc access | `"ReadWriteOnce"` |
| `persistence.persistentVolumeReclaimPolicy` | pvc policy | `"Retain"` |
| `persistence.annotations` | optional annotations | `{}` |
| `persistence.annotations."helm.sh/resource-policy"` | keep pvc | `keep` |
| `service.type` | type of service | `"ClusterIP"` |
| `service.port` | default listening port | `53431` |
| `ingress` | settings for ingress | `{}` |
| `resources` | pod resources | `{}` |
| `nodeSelector` | optional settings | `{}` |
| `tolerations` | optional settings | `[]` |
| `affinity` | session affinity | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release stable/hoard
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/hoard
```

## Cloud Examples

For each of the supported cloud back-ends, please ensure you have the appropriate credentials as identified by the corresponding environment variables.

### [AWS](https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html)

```bash
kubectl create secret generic cloud-credentials --from-literal access-key-id=${AWS_ACCESS_KEY_ID} --from-literal secret-access-key=${AWS_SECRET_ACCESS_KEY}
helm install --name my-release stable/hoard --set storage.type=aws,storage.region="eu-central-1",storage.bucket="my-bucket",storage.prefix="folder",storage.secret="cloud-credentials"
```

### [Azure](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-manage)

```bash
kubectl create secret generic cloud-credentials --from-literal storage-account-name=${AZURE_STORAGE_ACCOUNT_NAME} --from-literal storage-account-key=${AZURE_STORAGE_ACCOUNT_KEY}
helm install --name my-release stable/hoard --set storage.type=azure,storage.bucket="my-bucket",storage.prefix="folder",storage.secret="cloud-credentials"
```

### [GCP](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

```bash
kubectl create secret generic cloud-credentials --from-literal service-key=${GCLOUD_SERVICE_KEY}
helm install --name my-release stable/hoard --set storage.type=gcp,storage.bucket="my-bucket",storage.prefix="folder",storage.secret="cloud-credentials"
```

## OpenPGP Grants

Once configured, hoard can share access to a secret file by encrypting it with the public key of the recipient:

```bash
kubectl create secret generic private-keyring --from-file ${GOPATH}/src/github.com/monax/hoard/grant/private.key.asc
helm install --name my-release stable/hoard --set openpgp.id="10449759736975846181",openpgp.secret=private-keyring
```

## [Shared Secrets](https://github.com/monax/shared-secrets)

To enable Hoard to act as a 'secrets broker', deploy our CustomResourceDefinition and controller:

```bash
helm install --name my-release stable/hoard --set controller.enabled=true
```
