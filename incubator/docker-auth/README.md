Helm Chart for docker_auth
=======================

## Introduction

This [Helm](https://github.com/kubernetes/helm) chart installs [docker_auth](https://github.com/cesanta/docker_auth) in a Kubernetes cluster.

## Prerequisites

- Kubernetes cluster 1.10+
- Helm 2.8.0+

## Installation

### Install the chart

Install the docker-auth helm chart with a release name `my-release`:

```bash
# helm install --name=docker-auth docker-auth
NAME:   docker-auth
LAST DEPLOYED: Mon Sep 23 17:43:25 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME         AGE
docker-auth  0s

==> v1/Service
docker-auth  0s

==> v1/Deployment
docker-auth  0s

==> v1beta1/Ingress
docker-auth  0s

==> v1/Pod(related)

NAME                         READY  STATUS             RESTARTS  AGE
docker-auth-b79f6748d-k7cfb  0/1    ContainerCreating  0         0s

==> v1/Secret

NAME         AGE
docker-auth  0s


NOTES:
1. Get the application URL by running these commands:
  http://docker-auth.test.com/
2. Docker/Distribution configurate `auth.token` as below:
auth:
  token:
    autoredirect: false
    realm: http://docker-auth.test.com/  
    service: token-service
    issuer: Acme auth server
    rootcertbundle: /path/to/server.pem
```

### Uninstallation

To uninstall/delete the `my-release` deployment:

```bash
# helm delete --purge docker-auth
```

## Configuration

The following table lists the configurable parameters of the docker-auth chart and the default values.

| Parameter                                                                   | Description                                                                                                                                                                                                                                                                                                                                     | Default                         |
| --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| **Configmap**                                                                  |
| `configmap.data.server.certificate`                                                               | Content of server.pem                                                                                                                                                                                                                                                                         |                        |
| `configmap.data.server.key`                                                        | Content of server.key                                                                                                                                                                                                                                                                                                                           |                           |
| `configmap.data.token.issuer` | Must match issuer in the Registry config | `Acme auth server` |
| `configmap.data.token.expiration`                                                     | Token Expiration                                                   | `900`                                |
| **ingress**                                                             |
| `ingress.hosts.host`                                                       | Domain to your `docker_auth` installation                                                                                                                                                                                                                                                                                                              | `docker-auth.test.com`                          |
| **High Available**                                                             |
| `replicaCount`                                                       | Replica count for High Available                                                                                                                                                                                                                                                                                                              | `3`                          |
