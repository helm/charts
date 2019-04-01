# MTLS Helm Chart

This directory contains a Kubernetes chart to deploy a [MTLS Server][mtls-server].

## Prerequisites Details

* Kubernetes 1.11+

## Chart Details

This chart will do the following:

* Implement a MTLS Deployment

This system itself will not use Client Certificate Authentication as it uses a
detached signed PGP message to check for authentication when generating
certificates from a CSR.

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incuabor https://storage.googleapis.com/kubernetes-charts-incubator
# If you do not already have a CA or Intermediate Certificate run the following
# commands to generate the Root CA and Key which will be used as secrets when
installing.
$ ./scripts/setup.sh
$ ./scripts/create-ca.sh
$ helm install stable/mtls -f values.yaml
```

## Securing your Ingress

To add client certificate authentication to your resource you will need to add
a few annotations to your ingress. These annotations will add the appropriate
secrets and hide enable client certificate authentication.

NOTE: cert-manager will not work with services that integrate with client-cert
authentication unless you create mutliple ingresses and specifically open the
`.well-known`. It is advised that you either add the CA certificate to your
trust store or specifically add a wildcard or other certificate.

On a service that should integrate with mtls you will need to add the following
annotations to your ingress:

```
ingress:
  annotations:
    kubernetes.io/ingress.class: nginx
    # Enable client certificate authentication
    nginx.ingress.kubernetes.io/auth-tls-verify-client: "on"
    # Create the secret containing the trusted ca certificates
    nginx.ingress.kubernetes.io/auth-tls-secret: "<NAMESPACE>/<FULLNAME>-certs"
    # Specify the verification depth in the client certificates chain
    nginx.ingress.kubernetes.io/auth-tls-verify-depth: "1"
    # Specify if certificates are passed to upstream server
    nginx.ingress.kubernetes.io/auth-tls-pass-certificate-to-upstream: "false"
```

## Configuration

The following table lists the configurable parameters of the MTLS Chart and
their defaults.

| Parameter                   | Description                                             | Default                        |
| ---------                   | -----------                                             | -------                        |
| `image.repository`          | `mtls` image repository                                 | `drgrove/mtls`                 |
| `image.tag`                 | `mtls` image tag.                                       | `v0.12.0`                      |
| `image.pullPolicy`          | Image pull policy                                       | `IfNotPresent`                 |
| `secrets.ca_key`            | RSA key for CA                                          |                                |
| `secrets.ca_crt`            | PEM format CA Certificate                               |                                |
| `configMaps['config.ini']`  | Base configuration for `mtls`                           | [see values.yaml](values.yaml) |
| `admin_seeds`               | ASCII Armored PGP Keys for Seeding Admin Trust Database | `{}`                           |
| `user_seeds`                | ASCII Armored PGP Keys for Seeding User Trust Database  | `{}`                           |
| `persistence.enabled`       | Create a volume to store data                           | `true`                         |
| `persistence.size`          | Size of persistent volume claim                         | 10Gi RW                        |
| `persistence.storageClass`  | Type of persistent volume claim                         | `nil`                          |
| `persistence.accessMode`    | ReadWriteOnce or ReadOnly                               | `ReadWriteOnce`                |
| `persistence.existingClaim` | Name of existing persistent volume                      | `nil`                          |
| `persistence.subPath`       | Subdirectory of the volume to mount                     | `nil`                          |
| `persistence.annotations`   | Persistent Volume annotations                           | `{}`                           |
| `nodeSelector`              | Node labels for pod assignment                          | `{}`                           |
| `tolerations`               | Pod taint tolerations for deployment                    | `{}`                           |

[mtls-server]: https://github.com/drGrove/mtls-server
