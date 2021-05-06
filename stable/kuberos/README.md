# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Kuberos OIDC Helper

This is a config snippet generator for a k8s cluster

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;
Sorry you will need to look at the [configuration](#configuration) values below for this one.

```console
$ helm install incubator/kuberos -f custom-values.yaml
```

## Warning
The config snippets that are generated from this chart include OIDC connection details in clear text.
These include content that would normally be in secrets.

## Introduction
This chart deploys the [kuberos](https://github.com/negz/kuberos) code
snippet generator for clusters using both
* OIDC - OpenID Connect, an authentication layer on top of OAuth 2.0
* RBAC - Role Based Access Controls (in your k8s cluster)

It provides a quick and easy way for an authenticated user to generate
and download config for kubectl.

This work is [inspired from step 7 of the work](https://medium.com/@noqcks/secure-your-kubernetes-cluster-with-google-oidc-e1905c923522)
@noqcks did using other tooling.


## Prerequisites
- Kubernetes 1.8+ with RBAC enabled
- An OIDC provider eg G Suite
- RBAC on your cluster configured to use OIDC

## Configuration

The following table lists the configurable parameters of the kuberos chart

## Config params which probably need changing
These ones will be site specific and may contain sensitive information

| Parameter                   | Description                               | Default                                               |
| --------------------------- | -------------------------------           | ----------------------------------------------------- |
| `kuberos`                   | App Specific config options               | See below                                             |
|   `oidcClientURL`           | URL of OIDC provider endpoint             | `https://accounts.google.com`                         |
|   `oidcClientID`            | Your unique client ID                     | `REDACTED.apps.googleusercontent.com`                 |
|   `oidcSecret`              | The password for the Client ID above.     | Junk    [See Provider below](#oidc-provider-setup)    |
|   `clusters`                | List of clusters to generate config for   | See below                                             |
|       `name`                | The friendly name of the cluster          | `dev-cluster`                                         |
|       `apiServer`           | The endpoint for kubectl to use           | `'https://api.dev-cluster.example.com`                |
|       `caCrt`               | The Public CA  cert for the cluster       | See values.yaml                                       |
| `ingress`                   | A standard ingress block                  | See below                                             |
|   `enabled`                 | Enables or Disables the ingress block     | `false`                                               |
|   `annotations`             | Ingress annotations                       | `{}`                                                  |
|   `hosts`                   | List of FQDN's the be browsed to          | Not Set                                               |
|   `tls`                     | List of SSL certs to use                  | Empty list                                            |
|     `secretName`            | Name of the secret to use                 | Not Set                                               |
|     `hosts`                 | List of FQDN's the above secret is associated with| Not Set                                       |
| `service`                   | A standard service block                  | See below                                             |
|   `type`                    | Service type                              | `ClusterIP`                                           |
|   `port`                    | Service port                              | `80`                                                  |
|   `annotations`             | Service annotations                       | `{}`                                                  |


### Other Config params can be left alone

In some conditions you might want to set `image.tag` to `latest` and then `image.pullPolicy` to `Always`
this is generally advised against for stability reasons.

In general config params not listed above can be ignored / left alone.
The rest of the params are standard enough the google and other charts will be better at explaining them than me


## OIDC (Provider) Setup
You will need to obtain the OIDC details of the provider you need to use. This will contain the Issuer URL, Client ID and the Client Secret.
In the case of Google (The provider which was used when initially creating this) go to the [Developer / Credentials](https://console.developers.google.com/apis/credentials) console. You will need to add the ingress url to both
* *Authorised JavaScript origins* - https://kuberos.example.com
* *Authorised redirect URIs* - https://kuberos.example.com/ui

If you used kops the credentials you're after are
```
apiVersion: kops/v1alpha2
kind: Cluster
  authorization:
    rbac: {}
  kubeAPIServer:
    authorizationRbacSuperUser: admin
    oidcClientID: UNIQUE_ID_REDACTED.apps.googleusercontent.com
    oidcIssuerURL: https://accounts.google.com
    oidcUsernameClaim: email
```
For G Suite :
The redacted part of a ClientID is about 45 alphanumeric characters long (may also contain a hyphen or two)
The client secret will be about 25 alphanumeric chacters (may also contain a hyphen or two)
