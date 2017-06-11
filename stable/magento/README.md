# Magento

[Magento](https://magento.org/) is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

## TL;DR;

```console
$ helm install stable/magento
```

## Introduction

This chart bootstraps a [Magento](https://github.com/bitnami/bitnami-docker-magento) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Magento application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/magento
```

The command deploys Magento on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Magento chart and their default values.

|             Parameter              |               Description                |                         Default                          |
|------------------------------------|------------------------------------------|----------------------------------------------------------|
| `image`                            | Magento image                            | `bitnami/magento:{VERSION}`                              |
| `imagePullPolicy`                  | Image pull policy                        | `Always` if `image` tag is `latest`, else `IfNotPresent` |
| `magentoHost`                      | Magento host to create application URLs  | `nil`                                                    |
| `magentoLoadBalancerIP`            | `loadBalancerIP` for the magento Service | `nil`                                                    |
| `magentoUsername`                  | User of the application                  | `user`                                                   |
| `magentoPassword`                  | Application password                     | _random 10 character long alphanumeric string_           |
| `magentoEmail`                     | Admin email                              | `user@example.com`                                       |
| `magentoFirstName`                 | Magento Admin First Name                 | `FirstName`                                              |
| `magentoLastName`                  | Magento Admin Last Name                  | `LastName`                                               |
| `magentoMode`                      | Magento mode                             | `developer`                                              |
| `magentoAdminUri`                  | Magento prefix to access Magento Admin   | `admin`                                                  |
| `mariadb.mariadbRootPassword`      | MariaDB admin password                   | `nil`                                                    |
| `mariadb.persistence.storageClass` | PVC Storage Class for MariaDB volume     | `nil`  (uses alpha storage annotation)                   |
| `mariadb.persistence.accessMode`   | PVC Access Mode for MariaDb volume       | `ReadWriteOnce`                                          |
| `mariadb.persistence.size`         | PVC Storage Request for MariaDB volume   | `8Gi`                                                    |
| `serviceType`                      | Kubernetes Service type                  | `LoadBalancer`                                           |
| `persistence.enabled`              | Enable persistence using PVC             | `true`                                                   |
| `persistence.apache.storageClass`  | PVC Storage Class for Apache volume      | `nil`  (uses alpha storage annotation)                   |
| `persistence.apache.accessMode`    | PVC Access Mode for Apache volume        | `ReadWriteOnce`                                          |
| `persistence.apache.size`          | PVC Storage Request for Apache volume    | `1Gi`                                                    |
| `persistence.magento.storageClass` | PVC Storage Class for Magento volume     | `nil`  (uses alpha storage annotation)                   |
| `persistence.magento.accessMode`   | PVC Access Mode for Magento volume       | `ReadWriteOnce`                                          |
| `persistence.magento.size`         | PVC Storage Request for Magento volume   | `8Gi`                                                    |
| `resources`                        | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                             |

The above parameters map to the env variables defined in [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento). For more information please refer to the [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento) image documentation.

A YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm inspect values stable/magento > values.yaml
$ vi values.yaml
$ helm install --name my-release -f values.yaml stable/magento
```

### Installing on GKE

> **Note**:
>
> For Magento to function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `magentoLoadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `magentoLoadBalancerIP` parameter while installing the chart.

### Installing on minikube

    $ helm inspect values stable/magento > values.yaml

And then edit values.yaml to provide values for at least:

- magentoPassword  (requires both letters and numbers)
- magentoEmail
- mariadb.mariadbRootPassword
- serviceType: NodePort

    $ helm install --name my-release -f values.yaml stable/magento

Magento will partially install, but it needs `magentoHost` to be defined to complete installation.   Edit your values.yaml file to set magentoHost to `minikube ip` and the NodePort from `kubectl describe service my-release-magento`.   For example, my magentoHost was `192.168.42.159:31649`

    $ helm upgrade my-release -f values.yaml stable/magento

After it finishes installing, you can access magento via magentoHost.

### Installing on Metal

Requirements:

- Ingress
- a storage plugin such as glusterfs
- A DNS entry for your installation pointing to your Ingress Load Balancer.   For example a CNAME of my-release.example.com to ingress.example.com

    $ helm inspect values stable/magento > values.yaml

And then edit values.yaml to provide values for at least:

- magentoHost
- magentoPassword  (requires both letters and numbers)
- magentoEmail
- mariadb.mariadbRootPassword
- mariadb.persistence.storageClass
- serviceType: NodePort
- persistence.apache.storageClass
- persistence.magento.storageClass

    $ helm install --name my-release -f values.yaml stable/magento

Create an ingress file ingress.yaml:

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-release-ingress
spec:
  rules:
  - host: my-release.example.com
    http:
      paths:
      - backend:
          serviceName: my-release-magento
          servicePort: 80
```

and install it

    $ kubectl apply -f ingress.yaml

## Persistence

The [Bitnami Magento](https://github.com/bitnami/bitnami-docker-magento) image stores the Magento data and configurations at the `/bitnami/magento` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
