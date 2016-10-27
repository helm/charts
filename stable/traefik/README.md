# Traefik

[Traefik](http://traefik.io/) is a modern HTTP reverse proxy and load balancer made to deploy
microservices with ease.

## Introduction

This chart bootstraps Traefik as a Kubernetes ingress controller with optional support for SSL and
Let's Encrypt.

__N.B.__: Operators will typically wish to install this component into the `kube-system` namespace
where that namespace's default service account will ensure adequate privileges to watch `Ingress`
resources _cluster-wide_.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- You are deploying the chart to a cluster with a cloud provider capable of provisioning an
external load balancer (e.g. AWS or GKE)
- You control DNS for the domain(s) you intend to route through Traefik

### Suggested:

- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/traefik --name my-release --namespace kube-system
```

After installing the chart, create a DNS CNAME record for applicable domains to direct inbound
traffic the load balancer. You can you the command below to find the load balancer's DNS name:

```bash
$ kubectl describe service traefik-ingress-controller -n kube-system | grep Ingress
```

__N.B.__: It is only _after_ this step is complete that Traefik will be able to successfully use
the ACME protocol to obtain certificates from Let's Encrypt.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Traefik chart and their default values.

| Parameter                       | Description                                                          | Default                                   |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------------------------- |
| `imageTag`                      | The version of the official Traefik image to use                     | `v1.1.0-rc3`                              |
| `serviceType`                   | A valid Kubernetes service type                                      | `LoadBalancer`                            |
| `ssl.enabled`                   | Whether to enable HTTPS                                              | `false`                                   |
| `ssl.enforced`                  | Whether to redirect HTTP requests to HTTPS                           | `false`                                   |
| `ssl.defaultCert`               | Base64 encoded default certficate                                    | A self-signed certificate                 |
| `ssl.defaultKey`                | Base64 encoded private key for the certificate above                 | The private key for the certificate above |
| `acme.enabled`                  | Whether to use Let's Encrypt to obtain certificates                  | `false`                                   |
| `acme.email`                    | Email address to be used in certificates obtained from Let's Encrypt | `admin@example.com`                       |
| `acme.persistence.enabled`      | Create a volume to store ACME certs (if ACME is enabled)             | `true`                                    |
| `acme.persistence.storageClass` | Type of `StorageClass` to request-- will be cluster-specific         | `generic`                                 |
| `acme.persistence.accessMode`   | `ReadWriteOnce` or `ReadOnly`                                        | `ReadWriteOnce`                           |
| `acme.persistence.size`         | Minimum size of the volume requested                                 | `1Gi`                                     |
| `dashboard.enabled`             | Whether to enable the Traefik dashboard                              | `false`                                   |
| `dashboard.domain`              | Domain for the Traefik dashboard                                     | `traefik.example.com`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release --namespace kube-system --set dashboard.enabled=true,dashboard.domain=traefik.example.com stable/traefik
```

The above command enables the Traefik dashboard on the domain `traefik.example.com`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name my-release -f values.yaml stable/traefik
```
