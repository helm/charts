# ChartMuseum Helm Chart

Deploy your own private ChartMuseum.   

Please also see https://github.com/kubernetes-helm/chartmuseum   

## Prerequisites

* Kubernetes with extensions/v1beta1 available
* [If enabled] A persistent storage resource and RW access to it
* [If enabled] Kubernetes StorageClass for dynamic provisioning

## Configuration

By default this chart will not have persistent storage, and the API service
will be *DISABLED*.  This protects against unauthorized access to the API
with default configuration values.

For a more robust solution supply helm install with a custom values.yaml   
You are also required to create the StorageClass resource ahead of time:   
```
kubectl create -f /path/to/storage_class.yaml
```

The following table lists common configurable parameters of the chart and
their default values. See values.yaml for all available options. 

|       Parameter                        |           Description                       |                         Default                     |
|----------------------------------------|---------------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`                     | Container pull policy                       | `IfNotPresent`                                      |
| `image.repository`                     | Container image to use                      | `chartmuseum/chartmuseum`                           |
| `image.tag`                            | Container image tag to deploy               | `v0.4.2`                                            |
| `persistence.accessMode`               | Access mode to use for PVC                  | `ReadWriteOnce`                                     |
| `persistence.enabled`                  | Whether to use a PVC for persistent storage | `false`                                             |
| `persistence.size`                     | Amount of space to claim for PVC            | `8Gi`                                               |
| `persistence.storageClass`             | Storage Class to use for PVC                | `-`                                                 |
| `replicaCount`                         | k8s replicas                                | `1`                                                 |
| `resources.limits.cpu`                 | Container maximum CPU                       | `100m`                                              |
| `resources.limits.memory`              | Container maximum memory                    | `128Mi`                                             |
| `resources.requests.cpu`               | Container requested CPU                     | `80m`                                               |
| `resources.requests.memory`            | Container requested memory                  | `64Mi`                                              |
| `nodeSelector`                         | Map of node labels for pod assignment       | `{}`                                                |
| `tolerations`                          | List of node taints to tolerate             | `[]`                                                |
| `affinity`                             | Map of node/pod affinities                  | `{}`                                                |
| `env.open.STORAGE`                     | Storage Backend to use                      | `local`                                             |
| `env.open.ALIBABA_BUCKET`              | Bucket to store charts in for Alibaba       | ``                                                  |
| `env.open.ALIBABA_PREFIX`              | Prefix to store charts under for Alibaba    | ``                                                  |
| `env.open.ALIBABA_ENDPOINT`            | Alternative Alibaba endpoint                | ``                                                  |
| `env.open.ALIBABA_SSE`                 | Server side encryption algoritm to use      | ``                                                  |
| `env.open.AMAZON_BUCKET`               | Bucket to store charts in for AWS           | ``                                                  |
| `env.open.AMAZON_ENDPOINT`             | Alternative AWS endpoint                    | ``                                                  |
| `env.open.AMAZON_PREFIX`               | Prefix to store charts under for AWS        | ``                                                  |
| `env.open.AMAZON_REGION`               | Region to use for bucket access for AWS     | ``                                                  |
| `env.open.AMAZON_SSE`                  | Server side encryption algoritm to use      | ``                                                  |
| `env.open.GOOGLE_BUCKET`               | Bucket to store charts in for GCP           | ``                                                  |
| `env.open.GOOGLE_PREFIX`               | Prefix to store charts under for GCP        | ``                                                  |
| `env.open.STORAGE_MICROSOFT_CONTAINER` | Container to store charts under for MS      | ``                                                  |
| `env.open.STORAGE_MICROSOFT_PREFIX`    | Prefix to store charts under for MS         | ``                                                  |
| `env.open.CHART_POST_FORM_FIELD_NAME`  | Form field to query for chart file content  | ``                                                  |
| `env.open.PROV_POST_FORM_FIELD_NAME`   | Form field to query for chart provenance    | ``                                                  |
| `env.open.DEBUG`                       | Show debug messages                         | `false`                                             |
| `env.open.LOG_JSON`                    | Output structured logs in JSON              | `true`                                              |
| `env.open.DISABLE_METRICS`             | Disable Prometheus metrics                  | `true`                                              |
| `env.open.DISABLE_API`                 | Disable all routes prefixed with /api       | `true`                                              |
| `env.open.ALLOW_OVERWRITE`             | Allow chart versions to be re-uploaded      | `false`                                             |
| `env.open.CHART_URL`                   | Absolute url for .tgzs in index.yaml        | ``                                                  |
| `env.open.AUTH_ANONYMOUS_GET`          | Allow anon GET operations when auth is used | `false`                                             |
| `env.open.CONTEXT_PATH`                | Set the base context path                   | ``                                                  |
| `env.open.INDEX_LIMIT`                 | Parallel scan limit for the repo indexer    | ``                                                  |
| `env.secret.BASIC_AUTH_USER`           | Username for basic HTTP authentication      | ``                                                  |
| `env.secret.BASIC_AUTH_PASS`           | Password for basic HTTP authentication      | ``                                                  |

  secret:
    # username for basic http authentication
    BASIC_AUTH_USER:
    # password for basic http authentication
    BASIC_AUTH_PASS:

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

## Installation

```shell
helm install --name my-chartmuseum -f custom.yaml incubator/chartmuseum
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

## Example storage

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
