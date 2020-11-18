# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# ChartMuseum Helm Chart

Deploy your own private ChartMuseum.

Please also see https://github.com/kubernetes-helm/chartmuseum

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Table of Content

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [ChartMuseum Helm Chart](#chartmuseum-helm-chart)
  - [Table of Content](#table-of-content)
  - [Prerequisites](#prerequisites)
  - [Configuration](#configuration)
  - [Installation](#installation)
    - [Using with Amazon S3](#using-with-amazon-s3)
      - [permissions grant with access keys](#permissions-grant-with-access-keys)
      - [permissions grant with IAM instance profile](#permissions-grant-with-iam-instance-profile)
      - [permissions grant with IAM assumed role](#permissions-grant-with-iam-assumed-role)
      - [permissions grant with IAM Roles for Service Accounts](#permissions-grant-with-iam-roles-for-service-accounts)
    - [Using with Google Cloud Storage](#using-with-google-cloud-storage)
    - [Using with Google Cloud Storage and a Google Service Account](#using-with-google-cloud-storage-and-a-google-service-account)
    - [Using with Microsoft Azure Blob Storage](#using-with-microsoft-azure-blob-storage)
    - [Using with Alibaba Cloud OSS Storage](#using-with-alibaba-cloud-oss-storage)
    - [Using with Openstack Object Storage](#using-with-openstack-object-storage)
    - [Using with Oracle Object Storage](#using-with-oracle-object-storage)
    - [Using an existing secret](#using-an-existing-secret)
    - [Using with local filesystem storage](#using-with-local-filesystem-storage)
    - [Setting local storage permissions with initContainers](#setting-local-storage-permissions-with-initcontainers)
      - [Example storage class](#example-storage-class)
    - [Authentication](#authentication)
      - [Basic Authentication](#basic-authentication)
      - [Bearer/Token auth](#bearertoken-auth)
    - [Ingress](#ingress)
      - [Hosts](#hosts)
      - [Extra Paths](#extra-paths)
      - [Annotations](#annotations)
      - [Example Ingress configuration](#example-ingress-configuration)
  - [Uninstall](#uninstall)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Prerequisites

* [If enabled] A persistent storage resource and RW access to it
* [If enabled] Kubernetes StorageClass for dynamic provisioning

## Configuration

By default this chart will not have persistent storage, and the API service
will be *DISABLED*.  This protects against unauthorized access to the API
with default configuration values.

In addition, by default, pod `securityContext.fsGroup` is set to `1000`. This
is the user/group that the ChartMuseum container runs as, and is used to
enable local persitant storage. If your cluster has DenySecurityContext enabled,
you can set `securityContext` to `{}` and still use this chart with one of
the cloud storage options.

For a more robust solution supply helm install with a custom values.yaml
You are also required to create the StorageClass resource ahead of time:
```
kubectl create -f /path/to/storage_class.yaml
```

The following table lists common configurable parameters of the chart and
their default values. See values.yaml for all available options.

| Parameter                               | Description                                                                 | Default                              |
| --------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------ |
| `image.pullPolicy`                      | Container pull policy                                                       | `IfNotPresent`                       |
| `image.repository`                      | Container image to use                                                      | `chartmuseum/chartmuseum`            |
| `image.tag`                             | Container image tag to deploy                                               | `v0.12.0`                            |
| `persistence.accessMode`                | Access mode to use for PVC                                                  | `ReadWriteOnce`                      |
| `persistence.enabled`                   | Whether to use a PVC for persistent storage                                 | `false`                              |
| `persistence.path`                      | PV mount path                                                               | `/storage`                           |
| `persistence.size`                      | Amount of space to claim for PVC                                            | `8Gi`                                |
| `persistence.labels`                    | Additional labels for PVC                                                   | `{}`                                 |
| `persistence.storageClass`              | Storage Class to use for PVC                                                | `-`                                  |
| `persistence.volumeName`                | Volume to use for PVC                                                       | ``                                   |
| `persistence.pv.enabled`                | Whether to use a PV for persistent storage                                  | `false`                              |
| `persistence.pv.capacity.storage`       | Storage size to use for PV                                                  | `8Gi`                                |
| `persistence.pv.accessMode`             | Access mode to use for PV                                                   | `ReadWriteOnce`                      |
| `persistence.pv.nfs.server`             | NFS server for PV                                                           | ``                                   |
| `persistence.pv.nfs.path`               | Storage Path                                                                | ``                                   |
| `persistence.pv.pvname`                 | Custom name for private volume                                              | ``                                   |
| `volumePermissions.image.registry`      | Init container volume-permissions image registry                            | `docker.io`                          |
| `volumePermissions.image.repository`    | Init container volume-permissions image name                                | `bitnami/minideb`                    |
| `volumePermissions.image.tag`           | Init container volume-permissions image tag                                 | `buster`                             |
| `volumePermissions.image.pullPolicy`    | Init container volume-permissions image pull policy                         | `Always`                             |
| `replicaCount`                          | k8s replicas                                                                | `1`                                  |
| `resources.limits.cpu`                  | Container maximum CPU                                                       | `100m`                               |
| `resources.limits.memory`               | Container maximum memory                                                    | `128Mi`                              |
| `resources.requests.cpu`                | Container requested CPU                                                     | `80m`                                |
| `resources.requests.memory`             | Container requested memory                                                  | `64Mi`                               |
| `secret.labels`                         | Additional labels for secret                                                | `false`                              |
| `serviceAccount.create`                 | If true, create the service account                                         | `false`                              |
| `serviceAccount.name`                   | Name of the serviceAccount to create or use                                 | `{{ chartmuseum.fullname }}`         |
| `serviceAccount.annotations`            | Additional Service Account annotations                                      | `{}`                                 |
| `securityContext.enabled`               | Enable securityContext                                                      | `true`                               |
| `securityContext.fsGroup`               | Group ID for the container                                                  | `1000`                               |
| `securityContext.runAsNonRoot`          | Running Pods as non-root                                                    | ``                                   |
| `securityContext.supplementalGroups`    | Control which group IDs containers add                                      | ``                                   |
| `containerSecurityContext`              | Additional Container securityContext (ex. allowPrivilegeEscalation)         | `{}`                                 |
| `priorityClassName      `               | priorityClassName                                                           | `""`                                 |
| `nodeSelector`                          | Map of node labels for pod assignment                                       | `{}`                                 |
| `tolerations`                           | List of node taints to tolerate                                             | `[]`                                 |
| `affinity`                              | Map of node/pod affinities                                                  | `{}`                                 |
| `schedulerName`                         | Kubernetes scheduler to use                                                 | `default`                            |
| `env.open.STORAGE`                      | Storage Backend to use                                                      | `local`                              |
| `env.open.STORAGE_ALIBABA_BUCKET`       | Bucket to store charts in for Alibaba                                       | ``                                   |
| `env.open.STORAGE_ALIBABA_PREFIX`       | Prefix to store charts under for Alibaba                                    | ``                                   |
| `env.open.STORAGE_ALIBABA_ENDPOINT`     | Alternative Alibaba endpoint                                                | ``                                   |
| `env.open.STORAGE_ALIBABA_SSE`          | Server side encryption algorithm to use                                     | ``                                   |
| `env.open.STORAGE_AMAZON_BUCKET`        | Bucket to store charts in for AWS                                           | ``                                   |
| `env.open.STORAGE_AMAZON_ENDPOINT`      | Alternative AWS endpoint                                                    | ``                                   |
| `env.open.STORAGE_AMAZON_PREFIX`        | Prefix to store charts under for AWS                                        | ``                                   |
| `env.open.STORAGE_AMAZON_REGION`        | Region to use for bucket access for AWS                                     | ``                                   |
| `env.open.STORAGE_AMAZON_SSE`           | Server side encryption algorithm to use                                     | ``                                   |
| `env.open.STORAGE_GOOGLE_BUCKET`        | Bucket to store charts in for GCP                                           | ``                                   |
| `env.open.STORAGE_GOOGLE_PREFIX`        | Prefix to store charts under for GCP                                        | ``                                   |
| `env.open.STORAGE_MICROSOFT_CONTAINER`  | Container to store charts under for MS                                      | ``                                   |
| `env.open.STORAGE_MICROSOFT_PREFIX`     | Prefix to store charts under for MS                                         | ``                                   |
| `env.open.STORAGE_OPENSTACK_CONTAINER`  | Container to store charts for openstack                                     | ``                                   |
| `env.open.STORAGE_OPENSTACK_PREFIX`     | Prefix to store charts for openstack                                        | ``                                   |
| `env.open.STORAGE_OPENSTACK_REGION`     | Region of openstack container                                               | ``                                   |
| `env.open.STORAGE_OPENSTACK_CACERT`     | Path to a CA cert bundle for openstack                                      | ``                                   |
| `env.open.STORAGE_ORACLE_COMPARTMENTID` | Compartment ID for Oracle Object Store                                      | ``                                   |
| `env.open.STORAGE_ORACLE_BUCKET`        | Bucket to store charts in Oracle Object Store                               | ``                                   |
| `env.open.STORAGE_ORACLE_PREFIX`        | Prefix to store charts for Oracle object Store                              | ``                                   |
| `env.open.CHART_POST_FORM_FIELD_NAME`   | Form field to query for chart file content                                  | ``                                   |
| `env.open.PROV_POST_FORM_FIELD_NAME`    | Form field to query for chart provenance                                    | ``                                   |
| `env.open.DEPTH`                        | levels of nested repos for multitenancy.                                    | `0`                                  |
| `env.open.DEBUG`                        | Show debug messages                                                         | `false`                              |
| `env.open.LOG_JSON`                     | Output structured logs in JSON                                              | `true`                               |
| `env.open.DISABLE_STATEFILES`           | Disable use of index-cache.yaml                                             | `false`                              |
| `env.open.DISABLE_METRICS`              | Disable Prometheus metrics                                                  | `true`                               |
| `env.open.DISABLE_API`                  | Disable all routes prefixed with /api                                       | `true`                               |
| `env.open.ALLOW_OVERWRITE`              | Allow chart versions to be re-uploaded                                      | `false`                              |
| `env.open.CHART_URL`                    | Absolute url for .tgzs in index.yaml                                        | ``                                   |
| `env.open.AUTH_ANONYMOUS_GET`           | Allow anon GET operations when auth is used                                 | `false`                              |
| `env.open.CONTEXT_PATH`                 | Set the base context path                                                   | ``                                   |
| `env.open.INDEX_LIMIT`                  | Parallel scan limit for the repo indexer                                    | ``                                   |
| `env.open.CACHE`                        | Cache store, can be one of: redis                                           | ``                                   |
| `env.open.CACHE_REDIS_ADDR`             | Address of Redis service (host:port)                                        | ``                                   |
| `env.open.CACHE_REDIS_DB`               | Redis database to be selected after connect                                 | `0`                                  |
| `env.open.BEARER_AUTH`                  | Enable bearer auth                                                          | `false`                              |
| `env.open.AUTH_REALM`                   | Realm used for bearer authentication                                        | ``                                   |
| `env.open.AUTH_SERVICE`                 | Service used for bearer authentication                                      | ``                                   |
| `env.field`                             | Expose pod information to containers through environment variables          | ``                                   |
| `env.existingSecret`                    | Name of the existing secret use values                                      | ``                                   |
| `env.existingSecret.BASIC_AUTH_USER`    | Key name in the secret for the Username                                     | ``                                   |
| `env.existingSecret.BASIC_AUTH_PASS`    | Key name in the secret for the Password                                     | ``                                   |
| `env.secret.BASIC_AUTH_USER`            | Username for basic HTTP authentication                                      | ``                                   |
| `env.secret.BASIC_AUTH_PASS`            | Password for basic HTTP authentication                                      | ``                                   |
| `env.secret.CACHE_REDIS_PASSWORD`       | Redis requirepass server configuration                                      | ``                                   |
| `extraArgs`                             | Pass extra arguments to the chartmuseum binary                              | ``                                   |
| `gcp.secret.enabled`                    | Flag for the GCP service account                                            | `false`                              |
| `gcp.secret.name`                       | Secret name for the GCP json file                                           | ``                                   |
| `gcp.secret.key`                        | Secret key for te GCP json file                                             | `credentials.json`                   |
| `oracle.secret.enabled`                 | Flag for Oracle OCI account                                                 | `false`                              |
| `oracle.secret.name`                    | Secret name for OCI config and key                                          | ``                                   |
| `oracle.secret.config`                  | Secret key that holds the OCI config                                        | `config`                             |
| `oracle.secret.key_file`                | Secret key that holds the OCI private key                                   | `key_file`                           |
| `bearerAuth.secret.enabled`             | Flag for bearer auth public key secret                                      | ``                                   |
| `bearerAuth.secret.publicKey`           | The name of the secret with the public key                                  | ``                                   |
| `service.type`                          | Kubernetes Service type                                                     | `ClusterIP`                          |
| `service.clusterIP`                     | Static clusterIP or None for headless services                              | `nil`                                |
| `service.externalTrafficPolicy`         | Source IP preservation (only for Service type NodePort and LoadBalancer)    | `Local`                              |
| `service.loadBalancerSourceRanges`      | Restricts access for LoadBalancer (only for Service type LoadBalancer)      | `[]`                                 |
| `service.servicename`                   | Custom name for service                                                     | ``                                   |
| `service.labels`                        | Additional labels for service                                               | `{}`                                 |
| `serviceMonitor.enabled`                | Enable the ServiceMontor resource to be deployed                            | `false`                              |
| `serviceMonitor.labels`                 | Labels for the servicemonitor used by the Prometheus Operator               | `{}`                                 |
| `serviceMonitor.namespace`              | Namespace of the ServiceMonitor resource                                    | `{{ .Release.Namespace }}`           |
| `serviceMonitor.metricsPath`            | Path to the Chartmuseum metrics path                                        | `/metrics`                           |
| `serviceMonitor.interval`               | Scrape interval, If not set, the Prometheus default scrape interval is used | `nil`                                |
| `serviceMonitor.timeout`                | Scrape request timeout. If not set, the Prometheus default timeout is used  | `nil`                                |
| `deployment.labels`                     | Additional labels for deployment                                            | `{}`                                 |
| `deployment.matchlabes`                 | Match labels for deployment selector                                        | `{}`                                 |
| `ingress.enabled`                       | Enable ingress controller resource                                          | `false`                              |
| `ingress.annotations`                   | Ingress annotations                                                         | `[]`                                 |
| `ingress.labels`                        | Ingress labels                                                              | `[]`                                 |
| `ingress.hosts[0].name`                 | Hostname for the ingress                                                    | ``                                   |
| `ingress.hosts[0].path`                 | Path within the url structure                                               | ``                                   |
| `ingress.hosts[0].tls `                 | Enable TLS on the ingress host                                              | `false`                              |
| `ingress.hosts[0].tlsSecret`            | TLS secret to use (must be manually created)                                | ``                                   |
| `ingress.hosts[0].serviceName`          | The name of the service to route traffic to.                                | `{{ .Values.service.externalPort }}` |
| `ingress.hosts[0].servicePort`          | The port of the service to route traffic to.                                | `{{ .chartmuseum. }}`                |
| `ingress.extraPaths[0].path`            | Path within the url structure.                                              | ``                                   |
| `ingress.extraPaths[0].service`         | The name of the service to route traffic to.                                | ``                                   |
| `ingress.extraPaths[0].port`            | The port of the service to route traffic to.                                | ``                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

## Installation

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using with Amazon S3
Make sure your environment is properly setup to access `my-s3-bucket`

You need at least the following permissions inside your IAM Policy
```yaml
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListObjects",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::my-s3-bucket"
    },
    {
      "Sid": "AllowObjectsCRUD",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-s3-bucket/*"
    }
  ]
}
```

You can grant it to `chartmuseum` by several ways:

#### permissions grant with access keys

Grant permissions to `special user` and us it's access keys for auth on aws

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: amazon
    STORAGE_AMAZON_BUCKET: my-s3-bucket
    STORAGE_AMAZON_PREFIX:
    STORAGE_AMAZON_REGION: us-east-1
  secret:
    AWS_ACCESS_KEY_ID: "********" ## aws access key id value
    AWS_SECRET_ACCESS_KEY: "********" ## aws access key secret value
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

#### permissions grant with IAM instance profile

You can grant permissions to k8s node IAM instance profile.
For more information read this [article](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html)

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: amazon
    STORAGE_AMAZON_BUCKET: my-s3-bucket
    STORAGE_AMAZON_PREFIX:
    STORAGE_AMAZON_REGION: us-east-1
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

#### permissions grant with IAM assumed role

To provide access with assumed role you need to install [kube2iam](https://github.com/kubernetes/charts/tree/master/stable/kube2iam)
and create role with granded permissions.

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: amazon
    STORAGE_AMAZON_BUCKET: my-s3-bucket
    STORAGE_AMAZON_PREFIX:
    STORAGE_AMAZON_REGION: us-east-1
replica:
  annotations:
    iam.amazonaws.com/role: "{assumed role name}"
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

#### permissions grant with IAM Roles for Service Accounts

For Amazon EKS clusters, access can be provided with a service account using [IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: amazon
    STORAGE_AMAZON_BUCKET: my-s3-bucket
    STORAGE_AMAZON_PREFIX:
    STORAGE_AMAZON_REGION: us-east-1
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{aws account ID}:role/{assumed role name}"
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using with Google Cloud Storage
Make sure your environment is properly setup to access `my-gcs-bucket`

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: google
    STORAGE_GOOGLE_BUCKET: my-gcs-bucket
    STORAGE_GOOGLE_PREFIX:
```

### Using with Google Cloud Storage and a Google Service Account

A Google service account credentials are stored in a json file. There are two approaches here. Ideally you don't want to send your secrets to tiller. In that case, before installing this chart, you should create a secret with those credentials:

```shell
kubectl create secret generic chartmuseum-secret --from-file=credentials.json="my-project-45e35d85a593.json"
```

Then you can either use a `VALUES` yaml with your values or set those values in the command line:

```shell
helm install stable/chartmuseum --debug  --set gcp.secret.enabled=true,env.open.STORAGE=google,env.open.DISABLE_API=false,env.open.STORAGE_GOOGLE_BUCKET=my-gcp-chartmuseum,gcp.secret.name=chartmuseum-secret
```

If you prefer to use a yaml file:

```yaml
env:
  open:
    STORAGE: google
    STORAGE_GOOGLE_BUCKET: my-gcs-bucket
    STORAGE_GOOGLE_PREFIX:

gcp:
  secret:
    enabled: true
    name: chartmuseum-secret
    key: credentials.json
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

In case that you don't mind adding your secret to tiller (you shouldn't do it), this are the commands

```yaml
env:
  open:
    STORAGE: google
    STORAGE_GOOGLE_BUCKET: my-gcs-bucket
    STORAGE_GOOGLE_PREFIX:
  secret:
    GOOGLE_CREDENTIALS_JSON: my-json-file-base64-encoded
gcp:
  secret:
    enabled: true

```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

To set the values directly in the command line, use the following command. Note that we have to base64 encode the json file because we cannot pass a multi-line text as a value.

```shell
export JSONKEY=$(cat my-project-77e35d85a593.json | base64)
helm install stable/chartmuseum --debug  --set gcp.secret.enabled=true,env.secret.GOOGLE_CREDENTIALS_JSON=${JSONKEY},env.open.STORAGE=google,env.open.DISABLE_API=false,env.open.STORAGE_GOOGLE_BUCKET=my-gcp-chartmuseum
```

### Using with Microsoft Azure Blob Storage

Make sure your environment is properly setup to access `mycontainer`.

To do so, you must set the following env vars:
- `AZURE_STORAGE_ACCOUNT`
- `AZURE_STORAGE_ACCESS_KEY`

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: microsoft
    STORAGE_MICROSOFT_CONTAINER: mycontainer
    # prefix to store charts for microsoft storage backend
    STORAGE_MICROSOFT_PREFIX:
  secret:
    AZURE_STORAGE_ACCOUNT: "********" ## azure storage account
    AZURE_STORAGE_ACCESS_KEY: "********" ## azure storage account access key
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using with Alibaba Cloud OSS Storage

Make sure your environment is properly setup to access `my-oss-bucket`.

To do so, you must set the following env vars:
- `ALIBABA_CLOUD_ACCESS_KEY_ID`
- `ALIBABA_CLOUD_ACCESS_KEY_SECRET`

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: alibaba
    STORAGE_ALIBABA_BUCKET: my-oss-bucket
    STORAGE_ALIBABA_PREFIX:
    STORAGE_ALIBABA_ENDPOINT: oss-cn-beijing.aliyuncs.com
  secret:
    ALIBABA_CLOUD_ACCESS_KEY_ID: "********" ## alibaba OSS access key id
    ALIBABA_CLOUD_ACCESS_KEY_SECRET: "********" ## alibaba OSS access key secret
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using with Openstack Object Storage

Make sure your environment is properly setup to access `mycontainer`.

To do so, you must set the following env vars (depending on your openstack version):
- `OS_AUTH_URL`
- either `OS_PROJECT_NAME` or `OS_TENANT_NAME` or `OS_PROJECT_ID` or `OS_TENANT_ID`
- either `OS_DOMAIN_NAME` or `OS_DOMAIN_ID`
- either `OS_USERNAME` or `OS_USERID`
- `OS_PASSWORD`

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: openstack
    STORAGE_OPENSTACK_CONTAINER: mycontainer
    STORAGE_OPENSTACK_PREFIX:
    STORAGE_OPENSTACK_REGION: YOURREGION
  secret:
    OS_AUTH_URL: https://myauth.url.com/v2.0/
    OS_TENANT_ID: yourtenantid
    OS_USERNAME: yourusername
    OS_PASSWORD: yourpassword
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```
### Using with Oracle Object Storage

Oracle (OCI) configuration and private key need to be added to a secret and are mounted at /home/chartmuseum/.oci. Your OCI config needs to be under [DEFAULT] and your `key_file` needs to be /home/chartmuseum/.oci/oci.key.  See https://docs.cloud.oracle.com/iaas/Content/API/Concepts/sdkconfig.htm

```shell
kubectl create secret generic chartmuseum-secret --from-file=config=".oci/config" --from-file=key_file=".oci/oci.key"
```

Then you can either use a `VALUES` yaml with your values or set those values in the command line:

```shell
helm install stable/chartmuseum --debug  --set env.open.STORAGE=oracle,env.open.STORAGE_ORACLE_COMPARTMENTID=ocid1.compartment.oc1..abc123,env.open.STORAGE_ORACLE_BUCKET=myocibucket,env.open.STORAGE_ORACLE_PREFIX=chartmuseum,oracle.secret.enabled=true,oracle.secret.name=chartmuseum-secret
```

If you prefer to use a yaml file:

```yaml
env:
  open:
    STORAGE: oracle
    STORAGE_ORACLE_COMPARTMENTID: ocid1.compartment.oc1..abc123
    STORAGE_ORACLE_BUCKET:        myocibucket
    STORAGE_ORACLE_PREFIX:        chartmuseum

oracle:
  secret:
    enabled: enabled
    name: chartmuseum-secret
    config: config
    key_file: key_file

```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using an existing secret

It is possible to pre-create a secret in kubernetes and get this chart to use that

Given you are for example using the above AWS example

You could create a Secret like this

```shell
 kubectl create secret generic chartmuseum-secret --from-literal="aws-access-key=myaccesskey" --from-literal="aws-secret-access-key=mysecretaccesskey" --from-literal="basic-auth-user=curator" --from-literal="basic-auth-pass=mypassword"
```

Specify `custom.yaml` with such values

```yaml
env:
  open:
    STORAGE: amazonexistingSecret
    STORAGE_AMAZON_BUCKET: my-s3-bucket
    STORAGE_AMAZON_PREFIX:
    STORAGE_AMAZON_REGION: us-east-1
  existingSecret: chartmuseum-secret
  existingSecretMappings:
    AWS_ACCESS_KEY_ID: aws-access-key
    AWS_SECRET_ACCESS_KEY: aws-secret-access-key
    BASIC_AUTH_USER: basic-auth-user
    BASIC_AUTH_PASS: basic-auth-pass
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Using with local filesystem storage
By default chartmuseum uses local filesystem storage.
But on pod recreation it will lose all charts, to prevent that enable persistent storage.

```yaml
env:
  open:
    STORAGE: local
persistence:
  enabled: true
  accessMode: ReadWriteOnce
  size: 8Gi
  ## A manually managed Persistent Volume and Claim
  ## Requires persistence.enabled: true
  ## If defined, PVC must be created manually before volume will be bound
  # existingClaim:

  ## Chartmuseum data Persistent Volume Storage Class
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  # storageClass: "-"
```

Run command to install

```shell
helm install --name my-chartmuseum -f custom.yaml stable/chartmuseum
```

### Setting local storage permissions with initContainers

Some clusters do not allow using securityContext to set permissions for persistent volumes. Instead, an initContainer can be created to run `chown` on the mounted volume. To enable it, set `securityContext.enabled` to `false`.


#### Example storage class

Example storage-class.yaml provided here for use with a Ceph cluster.

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: storage-volume
provisioner: kubernetes.io/rbd
parameters:
  monitors: "10.11.12.13:4567,10.11.12.14:4567"
  adminId: admin
  adminSecretName: thesecret
  adminSecretNamespace: default
  pool: chartstore
  userId: user
  userSecretName: thesecret
```

### Authentication

By default this chart does not have any authentication configured and allows anyone to fetch or upload (assuming the API is enabled) charts there are two supported methods of authentication

#### Basic Authentication

This allows all API routes to be protected by HTTP basic auth, this is configured either as plain text in the values that gets stored as a secret in the kubernetes cluster by setting:

```yaml
env:
  secret:
    BASIC_AUTH_USER: curator
    BASIC_AUTH_PASS: mypassword
```

Or by using values from an existing secret in the cluster that can be created using:

```shell
kubectl create secret generic chartmuseum-secret --from-literal="basic-auth-user=curator" --from-literal="basic-auth-pass=mypassword"
```

This secret can be used in the values file as follows:

```yaml
env:
  existingSecret: chartmuseum-secret
  existingSecretMappings:
    BASIC_AUTH_USER: basic-auth-user
    BASIC_AUTH_PASS: basic-auth-pass
```

#### Bearer/Token auth

When using this ChartMuseum is configured with a public key, and will accept RS256 JWT tokens signed by the associated private key, passed in the Authorization header. You can use the [chartmuseum/auth](https://github.com/chartmuseum/auth) Go library to generate valid JWT tokens. For more information about how this works, please see [chartmuseum/auth-server-example](https://github.com/chartmuseum/auth-server-example)

To use this the public key should be stored in a secret this can be done with

```shell
kubectl create secret generic chartmuseum-public-key --from-file=public-key.pem
```

And Bearer/Token auth can be configured using the following values

```yaml
env:
  open:
    BEARER_AUTH: true
    AUTH_REALM: <realm>
    AUTH_SERVICE: <service>

bearerAuth:
  secret:
    enabled: true
    publicKeySecret: chartmuseum-public-key
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://hub.kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://hub.kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to expose Kubeapps.

To enable ingress integration, please set `ingress.enabled` to `true`

#### Hosts

Most likely you will only want to have one hostname that maps to this Chartmuseum installation, however, it is possible to have more than one host. To facilitate this, the `ingress.hosts` object is an array.  TLS secrets referenced in the ingress host configuration must be manually created in the namespace.

In most cases, you should not specify values for `ingress.hosts[0].serviceName` and `ingress.hosts[0].servicePort`. However, some ingress controllers support advanced scenarios requiring you to specify these values. For example, [setting up an SSL redirect using the AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/tasks/ssl_redirect/).

#### Extra Paths

Specifying extra paths to prepend to every host configuration is especially useful when configuring [custom actions with AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#actions).

```shell
helm install --name my-chartmuseum stable/chartmuseum \
  --set ingress.enabled=true \
  --set ingress.hosts[0].name=chartmuseum.domain.com \
  --set ingress.extraPaths[0].service=ssl-redirect \
  --set ingress.extraPaths[0].port=use-annotation \
```


#### Annotations

For annotations, please see [this document for nginx](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md) and [this document for Traefik](https://docs.traefik.io/configuration/backends/kubernetes/#general-annotations). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers. Annotations can be set using `ingress.annotations`.

#### Example Ingress configuration

```shell
helm install --name my-chartmuseum stable/chartmuseum \
  --set ingress.enabled=true \
  --set ingress.hosts[0].name=chartmuseum.domain.com \
  --set ingress.hosts[0].path=/
  --set ingress.hosts[0].tls=true
  --set ingress.hosts[0].tlsSecret=chartmuseum.tls-secret
```

## Uninstall

By default, a deliberate uninstall will result in the persistent volume
claim being deleted.

```shell
helm delete my-chartmuseum
```

To delete the deployment and its history:
```shell
helm delete --purge my-chartmuseum
```
