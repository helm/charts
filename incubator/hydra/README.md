# Hydra
[Hydra](https://github.com/ory/hydra) offers OAuth 2.0 and OpenID Connect Core 1.0 capabilities as a service. Hydra is different, because it works with any existing authentication infrastructure, not just LDAP or SAML. By implementing a consent app (works with any programming language) you build a bridge between Hydra and your authentication infrastructure.

Hydra is able to securely manage JSON Web Keys, and has a sophisticated policy-based access control you can use if you want to.

This chart comes bundled with an installation of Postgres.

## Prerequesites

* Kubernetes 1.4+ with Beta APIs enabled
* PV provisioner to support in the underlying infrastructure
* The ability to point a DNS entry or URL at your installation (for TLS)

## Install

To install the chart:

```
helm install --name=my-release stable/hydra
```

This will create a deployment, a secret, a service, and optionally a PersistentVolumeClaim, prefixed with `my-release`.

## Uninstall

```
helm delete my-release [--purge]
```

Adding the `--purge` flag will completely remove any trace of your release. (No values will be remembered.)

## Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults. These are a mixture of Kubernetes and Hydra-related directives.

Specify each parameter using the --set key=value[,key=value] argument to helm install. For example,

```
helm install --name my-release \
    --set config.hydra.logLevel=debug,config.hydra.logFormat=json \
    ory/hydra
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```
helm install --name my-release -f values.yaml ory/hydra
```

> **Tip**: You can use the default values.yaml with a few exceptions.