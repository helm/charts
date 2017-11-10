# Busbar

A [Busbar](https://github.com/busbar-io/busbar-server) Chart for Kubernetes.

## Installation

Busbar will set up a Busbar API Server, a MongoDB pod, a Redis pod and a Private Docker Registry.

In order for Busbar and the Private Docker Registry to work properly you must to set up your private DNS zone and a S3 bucket/user to host your private Docker registry.

To find complete instructions please refer to the Busbar oficial documentation at [Busbar](https://github.com/busbar-io/busbar-server).

To install the Busbar Chart on your system, run the following command (the options bellow are mandatory):

```bash
helm install busbar \
  --set privateDomainName=<your_private_dns_zone> \
  --set registryStorageS3Accesskey=<your_private_registry_s3_buckey_access_key> \
  --set registryStorageS3Secretkey=<your_private_registry_s3_buckey_secret_key> \
  --set registryStorageS3Bucket=<your_private_registry_s3_buckey>
```

## Available Options

| Parameter                    | Description                              | Default                           |
|------------------------------|------------------------------------------|-----------------------------------|
| `busbarDockerRegistry`       | Registry hosting the Busbar Docker Image | busbario                          |
| `busbarDockerTag`            | Busbar Image tag to use on installation  | latest                            |
| `clusterName`                | Kubernetes Cluster Name                  | busbar_cluster                    |
| `privateDomainName`          | Private Domain Name                      | private                           |
| `publicDomainName`           | Public Domain Name                       | example.com                       |
| `registryStorageS3Accesskey` | Private Registry S3 Bucket Access Key    | my_private_registry_s3_access_key |
| `registryStorageS3Secretkey` | Private Registry S3 Bucket Secret Key    | my_private_registry_s3_secret_key |
| `registryStorageS3Bucket`    | Private Registry S3 Bucket               | my_private_registry_s3_bucket     |

## Image Repositories:

- Busbar - https://github.com/busbar-io/busbar-server
- MongoDB - https://github.com/bitnami/bitnami-docker-mongodb
- Redis - https://github.com/bitnami/bitnami-docker-redis
- Docker Registry - https://github.com/docker-library/official-images/blob/master/library/registry
