# Vault Helm Chart

This directory contains a Kubernetes chart to deploy a Vault server.

## Prerequisites Details

* Kubernetes 1.6+

## Chart Details

This chart will do the following:

* Implement a Vault deployment
* Optionally, deploy a consul agent in the pod

Please note that a backend service for Vault (for example, Consul) must
be deployed beforehand and configured with the `vault.config` option. YAML
provided under this option will be converted to JSON for the final Vault
`config.json` file.

> See https://www.vaultproject.io/docs/configuration/ for more information.

## Installing the Chart

To install the chart, use the following, this backs Vault with a Consul cluster:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/vault --set vault.dev=false --set vault.config.storage.consul.address="myconsul-svc-name:8500",vault.config.storage.consul.path="vault"
```

An alternative example using the Amazon S3 backend can be specified using:

```
vault:
  config:
    storage:
      s3:
        access_key: "AWS-ACCESS-KEY"
        secret_key: "AWS-SECRET-KEY"
        bucket: "AWS-BUCKET"
        region: "eu-central-1"
```

## Configuration

The following table lists the configurable parameters of the Vault chart and their default values.

|             Parameter             |              Description                 |               Default               |
|-----------------------------------|------------------------------------------|-------------------------------------|
| `imagePullSecret`                 | The name of the secret to use if pulling from a private registry | `nil`       |
| `image.pullPolicy`                | Container pull policy                    | `IfNotPresent`                      |
| `image.repository`                | Container image to use                   | `vault`                             |
| `image.tag`                       | Container image tag to deploy            | `0.10.1`                            |
| `vault.dev`                       | Use Vault in dev mode                    | true (set to false in production)   |
| `vault.extraEnv`                  | Extra env vars for Vault pods            | `{}`                                |
| `vault.customSecrets`             | Custom secrets available to Vault        | `[]`                                |
| `vault.config`                    | Vault configuration                      | No default backend                  |
| `replicaCount`                    | k8s replicas                             | `3`                                 |
| `resources.limits.cpu`            | Container requested CPU                  | `nil`                               |
| `resources.limits.memory`         | Container requested memory               | `nil`                               |
| `affinity`                        | Affinity settings                        | See values.yaml                     |
| `service.loadBalancerSourceRanges`| IP whitelist for service type loadbalancer   | `[]`                            |
| `service.annotations`             | Annotations for service                  | `{}`                                |
| `annotations`                     | Annotations for deployment               | `{}`                                |
| `ingress.labels`                  | Labels for ingress                       | `{}`                                |
| `podAnnotations`                  | Annotations for pods                     | `{}`                                |
| `consulAgent.join`                | If set, start start a consul agent       | `nil`                               |
| `consulAgent.repository`          | Container image for consul agent         | `consul`                            |
| `consulAgent.tag`                 | Container image tag for consul agent     | `1.0.7`                             |
| `consulAgent.pullPolicy`          | Container pull policy for consul agent   | `IfNotPresent`                      |
| `consulAgent.gossipKeySecretName` | k8s secret containing gossip key         | `nil` (see values.yaml for details) |
| `consulAgent.HttpPort`            | HTTP port for consul agent API           | `8500`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Optional Consul Agent

If you are using the consul storage for vault, you might want a local
consul agent to handle health checks.  By setting `consulAgent.join`
to your consul server, an agent will be started in the vault pod.  In
this case, you should configure vault to connect to consul over
`localhost`.  For example:

```yaml
vault:
  dev: False
  config:
    storage:
      consul:
        address: "localhost:8500"
consulAgent:
  join: consul.service.consul
```

If you are using the `stable/consul` helm chart, consul communications
are encrypted with a gossip key.  You can configure a secret with the
same format as that chart and specify it in the
`consulAgent.gossipKeySecretName` parameter.

## Using Vault

Once the Vault pod is ready, it can be accessed using a `kubectl
port-forward`:

```console
$ kubectl port-forward vault-pod 8200
$ export VAULT_ADDR=http://127.0.0.1:8200
$ vault status
```

### TLS config

This is example of running Vault with Kubernetes generated TLS certificate:

1. Create `CertificateSigningRequest` according to [documentation](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/),
    some useful hosts entries to add:
   - `127.0.0.1` for running Vault commands inside the pod,
   - `*.<namespace>.pod.cluster.local` for direct Pod to Pod communication,
   - `<release>.<namespace>.svc.cluster.local` for communication within cluster,

1. Create `Secret` holding certificate and private key PEM:

```yaml
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: vault-tls
data:
  tls.crt: ${BASE64_ENCODED_CRT}
  tls.key: ${BASE64_ENCODED_PRIVATE_KEY}
```

1. Set up minimal `values.yml` configuration:

```yaml
vault:
  podDNSAsClusterAddr: true
  extraEnv:
  - name: VAULT_ADDR
    value: https://127.0.0.1:8200
  - name: VAULT_CAPATH
    value: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  customSecrets:
  - secretName: vault-tls
    mountPath: /vault/tls
  config:
    listener:
      tcp:
        tls_disable: false
        tls_cert_file: /vault/tls/tls.crt
        tls_key_file: /vault/tls/tls.key
        
# ingress:
#  enable: true
#  annotations:
#    kubernetes.io/ingress.class: "nginx"
#    nginx.ingress.kubernetes.io/secure-backends: "true"
```

### HA unseal script

Script for easier HA mode Vault unsealing:
```bash
#!/bin/sh
set -e
release=$1
namespace=$(helm status vault -o json | jq -r '.namespace')
read -rsp 'Vault Unseal Key: ' key
echo
for pod in $(kubectl -n ${namespace} get pods -l release=${release} -o json | jq -r '.items[] | select(.status.phase == "Running" and (.status.containerStatuses | any(.name == "vault" and (.ready | not)))) | .metadata.name')
do
    kubectl -n ${namespace} exec -ti ${pod} -c vault vault operator unseal "${key}"
done
```