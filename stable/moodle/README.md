# Moodle

[Moodle](https://www.moodle.org) Moodle is a learning platform designed to provide educators, administrators and learners with a single robust, secure and integrated system to create personalised learning environments

## TL;DR;

```console
$ helm install stable/moodle
```

## Introduction

This chart bootstraps a [Moodle](https://github.com/bitnami/bitnami-docker-moodle) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Moodle application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/moodle
```

The command deploys Moodle on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Moodle chart and their default values.

|              Parameter              |               Description               |                   Default                   |
|-------------------------------------|-----------------------------------------|---------------------------------------------|
| `image`                             | Moodle image                            | `bitnami/moodle:{VERSION}`                  |
| `imagePullPolicy`                   | Image pull policy                       | `IfNotPresent`                              |
| `moodleUsername`                    | User of the application                 | `user`                                      |
| `moodlePassword`                    | Application password                    | _random 10 character alphanumeric string_   |
| `moodleEmail`                       | Admin email                             | `user@example.com`                          |
| `smtpHost`                          | SMTP host                               | `nil`                                       |
| `smtpPort`                          | SMTP port                               | `nil` (but moodle internal default is 25)   |
| `smtpProtocol`                      | SMTP Protocol (options: ssl,tls, nil)   | `nil`                                       |
| `smtpUser`                          | SMTP user                               | `nil`                                       |
| `smtpPassword`                      | SMTP password                           | `nil`                                       |
| `serviceType`                       | Kubernetes Service type                 | `LoadBalancer`                              |
| `ingress.enabled`                   | If ingress should be created            | `false`                                     |
| `ingress.annotations`               | Any ingress annotations                 | `nil`                                       |
| `ingress.hosts`                     | List of Ingress hosts                   | `nil`                                       |
| `ingress.tls`                       | List of certs. If defined, https is set | `nil`                                       |
| `affinity`                          | Set affinity for the moodle pods        | `nil`                                       |
| `resources`                         | CPU/Memory resource requests/limits     | Memory: `512Mi`, CPU: `300m`                |
| `persistence.enabled`               | Enable persistence using PVC            | `true`                                      |
| `persistence.storageClass`          | PVC Storage Class for Moodle volume     | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`            | PVC Access Mode for Moodle volume       | `ReadWriteOnce`                             |
| `persistence.size`                  | PVC Storage Request for Moodle volume   | `8Gi`                                       |
| `persistence.existingClaim`         | If PVC exists&bounded for Moodle        | `nil` (when nil, new one is requested)      |
| `mariadb.mariadbRootPassword`       | MariaDB admin password                  | `nil` (uses alpha storage class annotation) |
| `mariadb.persistence.enabled`       | Enable MariaDB persistence using PVC    | `true`                                      |
| `mariadb.persistence.storageClass`  | PVC Storage Class for MariaDB volume    | `generic`                                   |
| `mariadb.persistence.accessMode`    | PVC Access Mode for MariaDB volume      | `ReadWriteOnce`                             |
| `mariadb.persistence.size`          | PVC Storage Request for MariaDB volume  | `8Gi`                                       |
| `mariadb.persistence.existingClaim` | If PVC exists&bounded for MariaDB       | `nil` (when nil, new one is requested)      |
| `mariadb.affinity`                  | Set affinity for the MariaDB pods       | `nil`                                       |
| `mariadb.resources`                 | CPU/Memory resource requests/limits     | Memory: `256Mi`, CPU: `250m`                |

The above parameters map to the env variables defined in [bitnami/moodle](http://github.com/bitnami/bitnami-docker-moodle). For more information please refer to the [bitnami/moodle](http://github.com/bitnami/bitnami-docker-moodle) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set moodleUsername=admin,moodlePassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/moodle
```

The above command sets the Moodle administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/moodle
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Ingress without TLS
For using ingress (example without tls):
```console
$ helm install --name my-release \
  --set ingress.enabled=True,ingress.hosts[0]=moodle.domain.com,serviceType=ClusterIP,moodleUsername=admin,moodlePassword=password,mariadb.mariadbRootPassword=secretpassword stable/moodle
```

These are the *3 mandatory parameters* when *Ingress* is desired:
`ingress.enabled=True,ingress.hosts[0]=moodle.domain.com,serviceType=ClusterIP`

### Ingress TLS
If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
$ kubectl create secret tls moodle-server-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the Ingress TLS section of your custom `values.yaml` file:

```console
ingress:
  ## If true, Moodle server Ingress will be created
  ##
  enabled: true

  ## Moodle server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## Moodle server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - moodle.domain.com

  ## Moodle server Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  tls:
    - secretName: moodle-server-tls
      hosts:
        - moodle.domain.com
```

## Persistence

The [Bitnami Moodle](https://github.com/bitnami/bitnami-docker-moodle) image stores the Moodle data and configurations at the `/bitnami/moodle` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, vpshere, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
You may want to review the [PV reclaim policy](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/), and update as required. By default it's set to delete, and when moodle is uninstalled, data is also removed.
