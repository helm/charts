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
| `image.tag`                       | Container image tag to deploy            | `.Chart.appVersion`                            |
| `vault.dev`                       | Use Vault in dev mode                    | true (set to false in production)   |
| `vault.extraArgs`                 | Additional arguments for vault server command | `[]`                           |
| `vault.extraEnv`                  | Extra env vars for Vault pods            | `{}`                                |
| `vault.extraContainers`           | Sidecar containers to add to the vault pod | `{}`                              |
| `vault.extraInitContainers`       | Init containers to be added to the vault pod | `{}`                            |
| `vault.extraVolumes`              | Additional volumes to the controller pod | `{}`                                |
| `vault.extraVolumeMounts`         | Extra volumes to mount to the controller pod | `{}`                                |
| `vault.existingConfigName`        | Location of existing Vault configuration | nil                                 |
| `vault.config`                    | Vault configuration                      | No default backend                  |
| `replicaCount`                    | k8s replicas                             | `3`                                 |
| `resources.limits.cpu`            | Container requested CPU                  | `nil`                               |
| `resources.limits.memory`         | Container requested memory               | `nil`                               |
| `affinity`                        | Affinity settings                        | See values.yaml                     |
| `service.loadBalancerIP`          | Assign a static IP to the loadbalancer   | `nil`                               |
| `service.loadBalancerSourceRanges`| IP whitelist for service type loadbalancer   | `[]`                            |
| `service.annotations`             | Annotations for service                  | `{}`                                |
| `service.externalPort`            | External port for the service            | `8200`                              |
| `service.port`                    | The API port Vault is using              | `8200`                              |
| `service.clusterExternalPort`     | External cluster port for the service    | `nil`                               |
| `service.clusterPort`             | The cluster port Vault is using          | `8201`                              |
| `annotations`                     | Annotations for deployment               | `{}`                                |
| `labels`                          | Extra labels for deployment              | `{}`                                |
| `ingress.labels`                  | Labels for ingress                       | `{}`                                |
| `podAnnotations`                  | Annotations for pods                     | `{}`                                |
| `priorityClassName`               | Priority class name for pods             | `""`                                |
| `minReadySeconds`                 | Minimum number of seconds that newly created replicas must be ready without any containers crashing | `0`                                |
| `podLabels`                       | Extra labels for pods                    | `{}`                                |
| `serviceAccount.create`           | Specifies whether a ServiceAccount should be created | `true`                 |
| `serviceAccount.name`             | The name of the ServiceAccount to create | Generated from fullname template    |
| `rbac.create`                     | Specifies whether RBAC should be created | `true`                              |
| `consulAgent.join`                | If set, start start a consul agent       | `nil`                               |
| `consulAgent.repository`          | Container image for consul agent         | `consul`                            |
| `consulAgent.tag`                 | Container image tag for consul agent     | `1.4.0`                             |
| `consulAgent.pullPolicy`          | Container pull policy for consul agent   | `IfNotPresent`                      |
| `consulAgent.gossipKeySecretName` | k8s secret containing gossip key         | `nil` (see values.yaml for details) |
| `consulAgent.HttpPort`            | HTTP port for consul agent API           | `8500`                              |
| `consulAgent.resources`           | Container resources for consul agent     | `nil`                               |
| `vaultExporter.enabled`           | Enable or disable vault exporter         | `false`                             |
| `vaultExporter.repository`        | Container image for vault exporter       | `grapeshot/vault_exporter`          |
| `vaultExporter.tag`               | Container image tag for vault exporter   | `v0.1.2`                            |
| `vaultExporter.pullPolicy`        | Image pull policy that sould be used     | `IfNotPresent`                      |
| `vaultExporter.vaultAddress`      | Vault address that exporter should use   | `127.0.0.1:8200`                    |
| `vaultExporter.tlsCAFile`         | Vault TLS CA certificate mount path      | `/vault/tls/ca.crt`                 |

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

## Optional Vault Exporter
If you want to monitor Vault with Prometheus you can simply enable the Vault exporter
which then runs as a sidecar container within the same pod as Vault itself. To use the
exporter just set `vaultExporter.enabled` to true and set the other variables according to
your needs.

If your Vault is set up with TLS make sure to specify the CA certificate path properly.
This is done through the parameter `vaultExporter.tlsCAFile`.

## Using Vault

Once the Vault pod is ready, it can be accessed using a `kubectl
port-forward`:

```console
$ kubectl port-forward vault-pod 8200
$ export VAULT_ADDR=http://127.0.0.1:8200
$ vault status
```

## Migrating Custom Secrets

Previous versions of this chart had a configuration option `vault.customSecrets`.
Custom secrets should now be expressed with `vault.extraVolumeMounts`. For example:

```yaml
vault:
  customSecrets:
    - secretName: vault-tls
      mountPath: /vault/tls
```

Would be expressed as:

```yaml
vault:
  extraVolumes:
    - name: vault-tls
      secret:
        secretName: vault-tls
  extraVolumeMounts:
    - name: vault-tls
      mountPath: /vault/tls
      readOnly: true
```
