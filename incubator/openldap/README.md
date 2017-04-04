# Openldap

__DISCLAIMER:__ While this chart has been well-tested, testers have encountered occasional issues
with the Traefik software itself. Be advised that your mileage may vary.

## Introduction

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- You are deploying the chart to a cluster with a cloud provider capable of provisioning an
external load balancer (e.g. AWS or GKE)
- You control DNS for the domain(s) you intend to route through Traefik
- __Suggested:__ PV provisioner support in the underlying infrastructure

## Installing the Chart

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the
release.

## Configuration

The following tables lists the configurable parameters of the Traefik chart and their default values.

| Parameter                       | Description                                                          | Default                                   |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------------------------- |
| `imageTag`                      | The version of image to use                                          | `latest`                                  |
| `imagePullPolicy`               | A valid Kubernetes service type                                      | `Always`                                  |
| `serviceType`                   | A valid Kubernetes service type                                      | `LoadBalancer`                            |
| `cpuRequest`                    | Initial share of CPU requested per Traefik pod                       | `100m`                                    |
| `memoryRequest`                 | Initial share of memory requested per Traefik pod                    | `20Mi`                                    |
| `cpuLimit`                      | CPU limit per Traefik pod                                            | `200m`                                    |
| `memoryLimit`                   | Memory limit per Traefik pod                                         | `30Mi`                                    |
| `ssl.enabled`                   | Whether to enable HTTPS                                              | `false`                                   |
| `ssl.enforced`                  | Whether to redirect HTTP requests to HTTPS                           | `false`                                   |
| `ssl.defaultCert`               | Base64 encoded default certficate                                    | A self-signed certificate                 |
| `ssl.defaultKey`                | Base64 encoded private key for the certificate above                 | The private key for the certificate above |
| `persistence.enabled`           | Create a volume to store ACME certs (if ACME is enabled)             | `true`                                    |
| `persistence.storageClass`      | Type of `StorageClass` to request-- will be cluster-specific         | `generic`                                 |
| `persistence.accessMode`        | `ReadWriteOnce` or `ReadOnly`                                        | `ReadWriteOnce`                           |
| `persistence.size`              | Minimum size of the volume requested                                 | `1Gi`                                     |
| `ldap.setpassword`              | Setup Root user                                                      | `true`                                    |
| `ldap.password`                 | Ldap Root user password                                              |                                           |
| `ldap.domain`                   | Ldap Domain                                                          |                                           |
| `ldap.organisation`             | Ldap Org                                                             |                                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release --set
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name my-release --namespace kube-system --values values.yaml
```
