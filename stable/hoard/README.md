# Hoard

[Hoard](https://github.com/monax/hoard) is a stateless, deterministically encrypted, content-addressed object store. It currently supports local persistent storage, [S3](https://aws.amazon.com/s3/) and [GCS](https://cloud.google.com/storage/) backends, though [IPFS](https://ipfs.io) integration is currently under development. Files that are sent to Hoard are symmetrically encrypted, where the secret is the hash of the plaintext file, and then stored in the configured backend - this enables any party with knowledge of the hash or original file to retrieve it from the store.

## Introduction

This chart bootstraps a hoard daemon on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installation

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/hoard
```

The [configuration](#configuration) section below lists all possible parameters that can be configured during installation.


### S3 Example

To deploy with an S3 backend, use the following command. Please first create appropriate [AWS Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html) and apply them to the Kubernetes secret `s3-credentials`.

```bash
$ helm install --name my-release stable/hoard --set storage.type=s3,storage.prefix="folder",storage.region="eu-central-1",storage.bucket="my-bucket",storage.credentialsSecret="s3-credentials"
```

## Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the Hoard chart and its default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | number of daemons | `1` |
| `image.repository` | docker image | `"quay.io/monax/hoard"` |
| `image.tag` | version | `"1.1.5"` |
| `image.pullPolicy` | pull policy | `"IfNotPresent"` |
| `storage.type` | backend object store (local, s3 or gcp)| `"local"` |
| `storage.region` | object store location (non-local) | `""` |
| `storage.bucket` | object storage container (non-local) | `""` |
| `storage.prefix` | bucket folder (non-local) | `"hoard"` |
| `storage.credentialsSecret` | required secret for gcs or s3 | `""` |
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
