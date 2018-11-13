# YOURLS

[YOURLS](https://yourls.org/) is a set of PHP scripts that will allow you to run Your Own URL Shortener.

## TL;DR;

```console
$ helm install stable/yourls
```

## Introduction

This chart bootstraps a [YOURLS](https://hub.docker.com/_/yourls/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the YOURLS application.

charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/yourls
```

The command deploys YOURLS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the YOURLS chart and their default values.

|            Parameter             |                Description                 |                         Default                         |
|----------------------------------|--------------------------------------------|---------------------------------------------------------|
| `image.registry`                 | YOURLS image registry                      | `docker.io`                                             |
| `image.repository`               | YOURLS image name                          | `yourls`                                                |
| `image.tag`                      | YOURLS image tag                           | `{VERSION}`                                             |
| `image.pullPolicy`               | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`              | Specify image pull secrets                 | `nil`                                                   |
| `yourlsSite`                     | Short URLs site refering to the app        | `http://yourls`                                         |
| `yourlsUsername`                 | User of the application                    | `user`                                                  |
| `yourlsPassword`                 | Application password                       | _random 10 character long alphanumeric string_          |
| `yourlsTablePrefix`              | Table prefix                               | `yourls_`                                               |
| `allowEmptyPassword`             | Allow DB blank passwords                   | `true`                                                  |
| `extraEnv`                       | Additional environment variables           | `[]`                                                    |
| `replicaCount`                   | Number of YOURLS Pods to run               | `1`                                                     |
| `mariadb.enabled`                | Deploy MariaDB container(s)                | `true`                                                  |
| `mariadb.rootUser.password`      | MariaDB admin password                     | `nil`                                                   |
| `mariadb.db.name`                | Database name to create                    | `yourls`                                                |
| `mariadb.db.user`                | Database user to create                    | `yourls`                                                |
| `mariadb.db.password`            | Password for the database                  | _random 10 character long alphanumeric string_          |
| `externalDatabase.host`          | Host of the external database              | `localhost:3306`                                        |
| `externalDatabase.user`          | Existing username in the external db       | `yourls`                                                |
| `externalDatabase.password`      | Password for the above username            | `nil`                                                   |
| `externalDatabase.database`      | Name of the existing database              | `yourls`                                                |
| `service.type`                   | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.externalTrafficPolicy`  | Enable client source IP preservation       | `Cluster`                                               |
| `nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `nodePorts.https`                | Kubernetes https node port                 | `""`                                                    |
| `healthcheckHttps`               | Use https for liveliness and readiness     | `false`                                                 |
| `ingress.enabled`                | Enable ingress controller resource         | `false`                                                 |
| `ingress.hosts[0].name`          | Hostname to your YOURLS installation       | `yourls.local`                                          |
| `ingress.hosts[0].path`          | Path within the url structure              | `/`                                                     |
| `ingress.hosts[0].tls`           | Utilize TLS backend in ingress             | `false`                                                 |
| `ingress.hosts[0].certManager`   | Add annotations for cert-manager           | `false`                                                 |
| `ingress.hosts[0].tlsSecret`     | TLS Secret (certificates)                  | `yourls.local-tls-secret`                               |
| `ingress.hosts[0].annotations`   | Annotations for this host's ingress record | `[]`                                                    |
| `ingress.secrets[0].name`        | TLS Secret Name                            | `nil`                                                   |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                     | `nil`                                                   |
| `ingress.secrets[0].key`         | TLS Secret Key                             | `nil`                                                   |
| `persistence.enabled`            | Enable persistence using PVC               | `true`                                                  |
| `persistence.existingClaim`      | Enable persistence using an existing PVC   | `nil`                                                   |
| `persistence.storageClass`       | PVC Storage Class                          | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`         | PVC Access Mode                            | `ReadWriteOnce`                                         |
| `persistence.size`               | PVC Storage Request                        | `10Gi`                                                  |
| `nodeSelector`                   | Node labels for pod assignment             | `{}`                                                    |
| `tolerations`                    | List of node taints to tolerate            | `[]`                                                    |
| `affinity`                       | Map of node/pod affinities                 | `{}`                                                    |

The above parameters map to the env variables defined in [YOURLS](https://hub.docker.com/_/yourls/). For more information please refer to the [yourls](https://hub.docker.com/_/yourls/) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set yourlsUsername=admin,yourlsPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/yourls
```

The above command sets the YOURLS administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/yourls
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Production and horizontal scaling

The following repo contains the recommended production settings for yourls capture in an alternative [values file](values-production.yaml). Please read carefully the comments in the values-production.yaml file to set up your environment appropriately.

To horizontally scale this chart, first download the [values-production.yaml](values-production.yaml) file to your local folder, then:

```console
$ helm install --name my-release -f ./values-production.yaml stable/yourls
```

Note that [values-production.yaml](values-production.yaml) includes a replicaCount of 3, so there will be 3 YOURLS pods. As a result, to use the /admin portal and to ensure you can scale yourls you need to provide a ReadWriteMany PVC, if you don't have a provisioner for this type of storage, we recommend that you install the nfs provisioner and map it to a RWO volume.

```console
$ helm install stable/nfs-server-provisioner --set persistence.enabled=true,persistence.size=10Gi
$ helm install --name my-release -f values-production.yaml --set persistence.storageClass=nfs stable/yourls
```

## Persistence

The [YOURLS](https://hub.docker.com/_/yourls/) image stores the YOURLS data and configurations at the `/yourls` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Using an external database

Sometimes you may want to have YOURLS connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#configuration). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example:

```console
$ helm install stable/yourls \
    --set mariadb.enabled=false,externalDatabase.host=myexternalhost:3306,externalDatabase.user=myuser,externalDatabase.password=mypassword,externalDatabase.database=mydatabase
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

## Ingress

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize
the ingress controller to serve your YOURLS application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this
YOURLS installation, however, it is possible to have more than one
host.  To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause YOURLS to generate HTTPS URLs, and
YOURLS will be connected to at port 443.  The actual secret that
`tlsSecret` references do not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the
ingress controller, however, this is not required.  There are three
common use cases:

* helm generates/manages certificate secrets
* user generates/manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego))
manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would
expect them to look like this:

* certificate files should look like (and there can be more than one
certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
````

If you are going to use Helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please
know that you can create a TLS secret by doing the following:

```
kubectl create secret tls yourls.local-tls --key /path/to/key.key --cert /path/to/cert.crt
```

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)
for more information.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `3.0.0`. The following example assumes that the release name is `yourls`:

```console
$ kubectl patch deployment yourls-yourls --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset yourls-mariadb --cascade=false
```
