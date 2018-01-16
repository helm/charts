# Cert-Manager-Certificate

This is for creating the Certificate Third Party Resources for Cert manager

## TL;DR;

```console
$ helm install incubator/cert-manager-certificate -f values-local.yaml
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/cert-manager-certificate -f values-local.yaml
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the drone charts and their default values.

| Parameter        | Description                                        | Default                                          |
| -----------------| -------------------------------------------------- | ------------------------------------------------ |
| `provider`       | Certificate provider                               | `default`                                        |
| `commonName`     | CommonName for certificate                         | `default.example.com`                            |
| `secretName`     | Name of the secret                                 | `default-tls`                                    |
| `issuerRef.name` | issuerRef Name                                     | `default-certs`                                  |
| `issuerRef.kind` | issuerRef Kind                                     | `ClusterIssuer`                                  |
