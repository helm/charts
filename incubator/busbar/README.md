# Busbar

A [Busbar](https://github.com/busbar-io/busbar-server) Chart for Kubernetes.

## Installation

Busbar will set up a Busbar API Server, a MongoDB pod, a Redis pod and a Private Docker Registry.

In order for Busbar and the Private Docker Registry to work properly you must to set up your private DNS zone and a S3 bucket/user to host your private Docker registry.

To find complete instructions please refer to the Busbar oficial documentation at [Busbar](https://github.com/busbar-io/busbar-server).

To install the Busbar Chart on your system, run the following command (the options bellow are mandatory):

```bash
helm install busbar \
  --set clusterName=<your_k8s_cluster_name> \
  --set privateDomainName=<your_private_dns_zone> \
  --set kubeRegistry.StorageS3Accesskey=<your_private_registry_s3_buckey_access_key> \
  --set kubeRegistry.StorageS3Secretkey=<your_private_registry_s3_buckey_secret_key> \
  --set kubeRegistry.StorageS3Bucket=<your_private_registry_s3_buckey>
```

## Available Options

| Parameter                         | Description                              | Default                           |
|-----------------------------------|------------------------------------------|-----------------------------------|
| `image.repository`                | Busbar Docker registry/Image             | busbario                          |
| `image.name`                      | Busbar Docker registry/Image             | busbar                            |
| `image.tag`                       | Busbar Image tag to use on installation  | 1.8.1                             |
| `image.pullPolicy`                | Busbar Image pull policy                 | ifNotPresent                      |
| `clusterName`                     | Kubernetes Cluster Name                  | busbar_cluster                    |
| `privateDomainName`               | Private Domain Name                      | private                           |
| `publicDomainName`                | Public Domain Name                       | example.com                       |
| `kubeRegistry.StorageS3Accesskey` | Private Registry S3 Bucket Access Key    | my_private_registry_s3_access_key |
| `kubeRegistry.StorageS3Secretkey` | Private Registry S3 Bucket Secret Key    | my_private_registry_s3_secret_key |
| `kubeRegistry.StorageS3Bucket`    | Private Registry S3 Bucket               | my_private_registry_s3_bucket     |

## Image Repositories:

- Busbar - https://github.com/busbar-io/busbar-server
- MongoDB - https://github.com/bitnami/bitnami-docker-mongodb
- Redis - https://github.com/bitnami/bitnami-docker-redis
- Docker Registry - https://github.com/docker-library/official-images/blob/master/library/registry
