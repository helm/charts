# Profile CustomResource

Profile CustomResources (CRs) are used to provide configuration information to
[Kanister](https://kansiter.io), a framework that enables application-level data
management on Kubernetes.

## TL;DR;

```bash
# Add the Kanister helm repo
$ helm repo add kanister https://charts.kanister.io/

# Create a Profile with the default name in the kanister namespace
$ helm install kanister/profile --namespace kanister \
     --set defaultProfile=true \
     --set s3.accessKey="${AWS_ACCESS_KEY}" \
     --set s3.secretKey="${AWS_SECRET_KEY}" \
     --set s3.bucket='my-kanister-bucket'
```

## Overview

This chart installs a Profile CR for [Kanister](http://kanister.io) using the
[Helm](https://helm.sh) package manager.

Profiles provide strongly-typed configuration for Kanister.  Because a Profile
is structured, the Kanister framework is able to provide support for advanced
features. Rather than relying on one-off implementations in Blueprints that
consume ConfigMaps Kanister introspect and use configuration from Profiles.

The schema for Profiles is specified by the CustomResourceDefinition (CRD),
which can be found [here](https://github.com/kanisterio/kanister/blob/master/pkg/apis/cr/v1alpha1/types.go#L234).

Currently Profiles can be used to configure access to object storage compatible
with the [S3 protocol](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html).

## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled or 1.9+ without Beta APIs.
- Kanister version 0.8.0 with `profiles.cr.kanister.io` CRD installed

> **Note**: The Kanister controller will create the Profile CRD at Startup.

## Configuration

The following table lists the configurable PostgreSQL Kanister blueprint and
Profile CR parameters and their default values. The Profile CR parameters are
passed to the profile sub-chart.

| Parameter        | Description                                                                                                                        | Default   |
| ---              | ---                                                                                                                                | ---       |
| `defaultProfile` | (Optional) Set to ``true`` to create a profile with name `default-profile`.                                                        | ``false`` |
| `profileName`    | (Required if `! defaultProfile`) Name of the Profile CR.                                                                           | `nil`     |
| `s3.accessKey`   | (Required) API Key for an s3 compatible object store.                                                                              | `nil`     |
| `s3.secretKey`   | (Required) Corresponding secret for `accessKey`.                                                                                   | `nil`     |
| `s3.bucket`      | (Required) Bucket used to store Kanister artifacts.<br><br>The bucket must already exist.                                          | `nil`     |
| `s3.region`      | (Optional) Region to be used for the bucket.                                                                                       | `nil`     |
| `s3.endpoint`    | (Optional) The URL for an s3 compatible object store provider. Can be omitted if provider is AWS. Required for any other provider. | `nil`     |
| `verifySSL`      | (Optional) Set to ``false`` to disable SSL verification on the s3 endpoint.                                                        | `true`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm
install`. For example:

```bash
$ helm install kanister/profile my-profile-release --namespace kanister \
     --set profileName='my-profile' \
     --set s3.endpoint='https://my-custom-s3-provider:9000' \
     --set s3.accessKey="${AWS_ACCESS_KEY}" \
     --set s3.secretKey="${AWS_SECRET_KEY}" \
     --set s3.bucket='my-kanister-bucket'
     --set s3.verifySSL='true'
```
