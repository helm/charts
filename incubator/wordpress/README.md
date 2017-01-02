# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## Introduction

This chart bootstraps a [WordPress](https://wordpress.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Requirements

This chart has been designed and tested under a bare metal installation of Kubernetes. As far as I know there is an open issue about the way a service is exposed to the world in bare metal clusters. So this chart uses NodePort in Services and Ingress Controller for publishing services. More info [here](https://github.com/kubernetes/ingress/issues/17) and [here](https://medium.com/@rothgar/exposing-services-using-ingress-with-on-prem-kubernetes-clusters-f413d87b6d34#.c67kqh60k). 

After the deployment you should be able to access the service through the `hostname` var setted on `values.yaml`. Update the DNS records before in order to point the Node IP where the ingress controller is running on.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- Ingress controller running. (Tested with Traefik)
- PV provisioner support in the underlying infrastructure
- MySQL Server running
- NFS Server running for persistence

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ git clone https://github.com/nordri/helm-wordpress
$ helm install --name my-release ./helm-wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the WordPress chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `image`                              | WordPress image                          | `wordpress:latest`                                         |
| `db_server`                          | IP or Hostname of Database               |                                                            |
| `root_db_password`                   | MySQL root password                      |                                                            |
| `nfs_path`                           | PATH for nfs export                      | `svrnfs`                                                   |
| `nfs_server`                         | IP or Hostname of NFS Server             |                                                            |
| `pv_size`                            | PV Storage Request for WP Volume         | `20Gi`                                                     |
| `pvc_size`                           | PVC Storage Request for WordPress volume | `2Gi`                                                      |
| `hostname`                           | Hostname for the ingress controller      | `wordpress`                                                |
| `resources.requests.memory`          | Memory Limit                             | `128Mi`                                                    |
| `resources.requests.cpu`             | CPU Limit                                | `100m`                                                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set root_db_password=s3cr3t \
    helm-wordpress
```

The above command uses `s3cr3t` as MySQL root password.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml helm-wordpress
```

## Persistence

This Chart uses NFS server for persistence. The exported volume is mounted under `/var/www/html` where Apache HTTPD server puts the web pages. You should use an export for each WP installation.
