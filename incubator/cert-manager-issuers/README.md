# cert-manager-issuers

## Quickstart

To setup the [letsencrypt](https://letsencrypt.org/) staging and prod http01 ACME endpoints as ClusterIssuers (so you can use the kube-lego style ingress annotation `kubernetes.io/tls-acme: "true"`):

### Install cert-manager

First install the [cert-manager chart](https://github.com/helm/charts/tree/master/stable/cert-manager) with the ingress shim set up:

```
$ helm install --name my-cert-manager-release \
--set ingressShim.defaultIssuerName=letsencrypt-prod,ingressShim.defaultIssuerKind=ClusterIssuer \
stable/cert-manager
```

### Install the issuers

Then install this chart with the default values.yaml and your email address:

```
$ helm install --name my-cert-manager-issuers-release \
-f values.yaml \
--set email=<you@example.com> \
incubator/cert-manager-issuers
```

### Verifying

```
kubectl logs -l app=cert-manager
```

should show your certificates being provisioned. Note that you _must_ set a valid email address per letsencrypt TOS. @example.com addresses will not work.

## Values

### Commonly used values

| Parameter                         | Description                                | Default                                                   |
| --------------------------------- | ------------------------------------------ | --------------------------------------------------------- |
| `email`            | email to use for acme registration               | `you@example.com`                                                     |

It is recommended to provide more issuers using a `values.yaml` file. The two letsencrypt http01 endpoints are provided as [ClusterIssuers](http://docs.cert-manager.io/en/latest/reference/issuers.html). Emails set inside an `issuer` override the global one.

## FAQ

### Why isn't this chart part of cert-manager?

Due to technical limitations of helm v2, custom resource definitions must be created before a custom resource can be defined. This means that no issuers are included in the [cert-manager helm chart](https://github.com/helm/charts/tree/master/stable/cert-manager), as they would fail to create.

## Stability

This chart is in alpha. Backwards incompatible changes will be avoided if possible, but no guarantees.

## Contributing

PRs are welcome.
