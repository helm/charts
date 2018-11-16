Pachyderm Helm Chart
====================

Pachyderm is a language-agnostic and cloud infrastructure-agnostic large-scale data processing framework based on software containers. This chart can be used to deploy Pachyderm backed by object stores of different Cloud providers.

* https://pachyderm.io
* https://github.com/pachyderm/pachyderm


Prerequisites Details
---------------------

-	Dynamic provisioning of PVs (for non-local deployments)

General chart settings
----------------------

The following table lists the configurable parameters of `pachd` and their default values:

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `rbac.create`            | Enable RBAC           | `true`            |
| `pachd.image.repository` | Container image name  | `pachyderm/pachd` |
| `pachd.pfsCache`         | File System cache size| `0G`              |
| `*.image.tag`            | Container image tag   | `<latest version>`|
| `*.image.pullPolicy`     | Image pull policy     | `Always`          |
| `*.worker.repository`    | Worker image name     | `pachyderm/worker`|
| `*.worker.tag`           | Worker image tag      | `<latest version>`|
| `*.replicaCount`         | Number of pachds      | `1`               |
| `*.resources.requests`   | Memory and cpu request| `{512M,250m}`     |


Next table lists the configurable parameters of `etcd` and their default values:

| Parameter                   | Description           | Default               |
|-----------------------------|-----------------------|-----------------------|
| `etcd.image.repository`     | Container image name  | `quay.io/coreos/etcd` |
| `*.image.tag`               | Container image tag   | `<latest version>`    |
| `*.image.pullPolicy`        | Image pull policy     | `IfNotPresent`        |
| `*.resources.requests`      | Memory and cpu request| `{250M,250m}`         |
| `*.persistence.enabled`     | Enable persistence    | `false`               |
| `*.persistence.size`        | Storage request       | `20G`                 |
| `*.persistence.accessMode`  | Access mode for PV    | `ReadWriteOnce`       |
| `*.persistence.storageClass`| PVC storage class     | `nil`                 |


In order to set which object store credentials you want to use, please set the flag `credentials` with one of the following values: `local | s3 | google | amazon | microsoft`.

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `credentials`            | Backend credentials   | ""                |


Based on the storage credentials used, fill in the corresponding parameters for your object store. Note that The `local` installation will deploy Pachyderm on your local Kubernetes cluster (i.e: minikube) backed by your local storage unit. 


On-premises deployment
------------------------

- On an on-premise environment like Openstack, a `S3 endpoint` can be used as storage backend. The following credentials (such as Minio credentials) are configurable:

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `s3.accessKey`           | S3 access key         | `""`              |
| `s3.secretKey`           | S3 secret key         | `""`              |
| `s3.bucketName`          | S3 bucket name        | `""`              |
| `s3.endpoint`            | S3 endpoint           | `""`              |
| `s3.secure`              | S3 secure             | `"0"`             |
| `s3.signature`           | S3 signature          | `"1"`             |


Google Cloud 
-------------

-	With `Google Cloud` credentials, you must define your `GCS bucket name`:

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `google.bucketName`      | GCS bucket name       | `""`              |
| `google.credentials`     | GCP credentials       | `""`              |


Amazon Web Services
---------------------

-	On `Amazon Web Services`, please set the next values:

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `amazon.bucketName`      | Amazon bucket name    | `""`              |
| `amazon.distribution`    | Amazon distribution   | `""`              |
| `amazon.id`              | Amazon id             | `""`              |
| `amazon.region`          | Amazon region         | `""`              |
| `amazon.secret`          | Amazon secret         | `""`              |
| `amazon.token`           | Amazon token          | `""`              |


Microsoft Azure
---------------------

-	As for `Microsoft Azure`, you must specify the following parameters:

| Parameter                | Description           | Default           |
|--------------------------|-----------------------|-------------------|
| `microsoft.container`    | Container             | `""`              |
| `microsoft.id`           | Account name          | `""`              |
| `microsoft.secret`       | Account key           | `""`              |


How to install the chart
------------------------

We strongly suggest that the installation of Pachyderm should be performed in its own namespace. Note that you should have RBAC enabled in your cluster to make the installation work with the default settings. The default installation will deploy Pachyderm on your local Kubernetes cluster:

```console
$ helm install --namespace pachyderm --name my-release stable/pachyderm
```

You should install the chart specifying each parameter using the `--set key=value[,key=value]` argument to helm install. Please consult the `values.yaml` file for more information regarding the parameters. For example:


```console
$ helm install --namespace pachyderm --name my-release \
--set credentials=s3,s3.accessKey=myaccesskey,s3.secretKey=mysecretkey,s3.bucketName=default_bucket,s3.endpoint=domain.subdomain:8080,etcd.persistence.enabled=true,etcd.persistence.accessMode=ReadWriteMany \
stable/pachyderm
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart:

```console
$ helm install --namespace pachyderm --name my-release -f values.yaml stable/pachyderm
```

Accessing the pachd service
---------------------------

In order to use Pachyderm, please login through ssh to the master node and install the Pachyderm client:

```console
$ curl -o /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v1.7.3/pachctl_1.7.3_amd64.deb && sudo dpkg -i /tmp/pachctl.deb
```

Please note that the client version should correspond with the pachd service version. For more information please consult: http://pachyderm.readthedocs.io/en/latest/index.html. Also, if you have your kubernetes client properly configured to talk with your remote cluster, you can simply install `pachctl` on your local machine and execute: `pachctl --namespace <namespace> port-forward &`.

Clean-up
-------

In order to remove the Pachyderm release, you can execute the following commands:

```console
$ helm list
$ helm delete --purge <release-name>
```
