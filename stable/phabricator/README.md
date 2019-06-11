# Phabricator

[Phabricator](https://www.phacility.com) is a collection of open source web applications that help software companies build better software. Phabricator is built by developers for developers. Every feature is optimized around developer efficiency for however you like to work. Code Quality starts with an effective collaboration between team members.

## TL;DR;

```console
$ helm install stable/phabricator
```

## Introduction

This chart bootstraps a [Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Phabricator application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/phabricator
```

The command deploys Phabricator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Phabricator chart and their default values.

|               Parameter                |                 Description                  |                         Default                          |
|----------------------------------------|----------------------------------------------|----------------------------------------------------------|
| `global.imageRegistry`                 | Global Docker image registry                 | `nil`                                                    |
| `global.imagePullSecrets`              | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                       | Phabricator image registry                   | `docker.io`                                              |
| `image.repository`                     | Phabricator image name                       | `bitnami/phabricator`                                    |
| `image.tag`                            | Phabricator image tag                        | `{TAG_NAME}`                                             |
| `image.pullPolicy`                     | Image pull policy                            | `Always` if `imageTag` is `latest`, else `IfNotPresent`  |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                   | `[]` (does not add image pull secrets to deployed pods)                                                    |
| `phabricatorHost`                      | Phabricator host to create application URLs  | `nil`                                                    |
| `phabricatorAlternateFileDomain`       | Phabricator alternate domain to upload files | `nil`                                                    |
| `phabricatorUsername`                  | User of the application                      | `user`                                                   |
| `phabricatorPassword`                  | Application password                         | _random 10 character long alphanumeric string_           |
| `phabricatorEmail`                     | Admin email                                  | `user@example.com`                                       |
| `phabricatorFirstName`                 | First name                                   | `First Name`                                             |
| `phabricatorLastName`                  | Last name                                    | `Last Name`                                              |
| `smtpHost`                             | SMTP host                                    | `nil`                                                    |
| `smtpPort`                             | SMTP port                                    | `nil`                                                    |
| `smtpUser`                             | SMTP user                                    | `nil`                                                    |
| `smtpPassword`                         | SMTP password                                | `nil`                                                    |
| `smtpProtocol`                         | SMTP protocol [`ssl`, `tls`]                 | `nil`                                                    |
| `mariadb.rootUser.password`            | MariaDB admin password                       | `nil`                                                    |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                 | `80`                                          |
| `service.httpsPort`                    | Service HTTP port                 | `443`                                          |
| `service.loadBalancerIP`            | `loadBalancerIP` for the Phabricator Service | `nil`                                                    |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.nodePorts.https`                 | Kubernetes https node port                  | `""`                                                    |
| `persistence.enabled`                  | Enable persistence using PVC                 | `true`                                                   |
| `persistence.phabricator.storageClass` | PVC Storage Class for Phabricator volume     | `nil` (uses alpha storage class annotation)              |
| `persistence.phabricator.accessMode`   | PVC Access Mode for Phabricator volume       | `ReadWriteOnce`                                          |
| `persistence.phabricator.size`         | PVC Storage Request for Phabricator volume   | `8Gi`                                                    |
| `resources`                            | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                             |
| `ingress.enabled`                      | Enable ingress controller resource           | `false`                                                  |
| `ingress.hosts[0].name`                | Hostname to your Phabricator installation    | `phabricator.local`                                      |
| `ingress.hosts[0].path`                | Path within the url structure                | `/`                                                      |
| `ingress.hosts[0].tls`                 | Utilize TLS backend in ingress               | `false`                                                  |
| `ingress.hosts[0].certManager`         | Add annotations for cert-manager             | `false`                                                  |
| `ingress.hosts[0].tlsSecret`           | TLS Secret (certificates)                    | `phabricator.local-tls-secret`                           |
| `ingress.hosts[0].annotations`         | Annotations for this host's ingress record   | `[]`                                                     |
| `ingress.secrets[0].name`              | TLS Secret Name                              | `nil`                                                    |
| `ingress.secrets[0].certificate`       | TLS Secret Certificate                       | `nil`                                                    |
| `ingress.secrets[0].key`               | TLS Secret Key                               | `nil`                                                    |
| `podAnnotations`                       | Pod annotations                                  | `{}`                                                 |
| `metrics.enabled`                      | Start a side-car prometheus exporter             | `false`                                              |
| `metrics.image.registry`               | Apache exporter image registry                   | `docker.io`                                          |
| `metrics.image.repository`             | Apache exporter image name                       | `lusotycoon/apache-exporter`                         |
| `metrics.image.tag`                    | Apache exporter image tag                        | `v0.5.0`                                             |
| `metrics.image.pullPolicy`             | Image pull policy                                | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`            | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`               | Additional annotations for Metrics exporter pod  | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                    | Exporter resource requests/limit                 | {}                                                    |
| `nodeSelector`                         | Node labels for pod assignment                   | `nil`                                                  |
| `affinity`                             | Node/pod affinities                              | `nil`                                                  |
| `tolerations`                          | List of node taints to tolerate                  | `nil`                                                  |

The above parameters map to the env variables defined in [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator). For more information please refer to the [bitnami/phabricator](http://github.com/bitnami/bitnami-docker-phabricator) image documentation.

> **Note**:
>
> For Phabricator to function correctly, you should specify the `phabricatorHost` parameter to specify the FQDN (recommended) or the public IP address of the Phabricator service.
>
> Optionally, you can specify the `phabricatorLoadBalancerIP` parameter to assign a reserved IP address to the Phabricator service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create phabricator-public-ip
> ```
>
> The reserved IP address can be associated to the Phabricator service by specifying it as the value of the `phabricatorLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set phabricatorUsername=admin,phabricatorPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/phabricator
```

The above command sets the Phabricator administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/phabricator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Phabricator](https://github.com/bitnami/bitnami-docker-phabricator) image stores the Phabricator data and configurations at the `/bitnami/phabricator` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress With Reverse Proxy And Kube Lego

You can define a custom ingress following the example config in values.yaml

`helm install stable/phabricator/ --name my-release --set phabricatorHost=example.com`

Everything looks great but requests over https will cause asset requests to fail. Assuming you want to use HTTPS/TLS you will need to set the base-uri to an https schema.

```
export POD_NAME=$(kubectl get pods -l "app=my-release-phabricator" -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD_NAME /opt/bitnami/phabricator/bin/config set phabricator.base-uri https://example.com
```

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl patch deployment opencart-opencart --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/app"}]'
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
