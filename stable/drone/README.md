# Drone.io

[Drone](http://docs.drone.io/) is a Continuous Integration platform built on
container technology. Version 2 of this chart is compatible with drone version
1. If you wish to install drone version 0.8, using version 1.x of this chart.

## TL;DR;

```console
$ helm install stable/drone
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/drone
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the drone charts and their default values.

| Parameter                   | Description                                                                                   | Default                     |
|-----------------------------|-----------------------------------------------------------------------------------------------|-----------------------------|
| `images.server.repository`  | Drone **server** image                                                                        | `docker.io/drone/drone`     |
| `images.server.tag`         | Drone **server** image tag                                                                    | `1.0.0-rc.1`                |
| `images.server.pullPolicy`  | Drone **server** image pull policy                                                            | `IfNotPresent`              |
| `images.agent.repository`   | Drone **agent** image                                                                         | `docker.io/drone/agent`     |
| `images.agent.tag`          | Drone **agent** image tag                                                                     | `1.0.0-rc.1`                |
| `images.agent.pullPolicy`   | Drone **agent** image pull policy                                                             | `IfNotPresent`              |
| `images.dind.repository`    | Docker **dind** image                                                                         | `docker.io/library/docker`  |
| `images.dind.tag`           | Docker **dind** image tag                                                                     | `18.06.1-ce-dind`           |
| `images.dind.pullPolicy`    | Docker **dind** image pull policy                                                             | `IfNotPresent`              |
| `images.secrets.repository` | Drone **secrets** image, choose from amazon-secrets, Kubernetes-secrets, or vault-secrets     | `docker.io/drone/kubernetes-secrets` |
| `images.secrets.tag`        | Drone **secrets** image tag                                                                   | `latest`                    |
| `images.secrets.pullPolicy` | Drone **secrets** image pull policy                                                           | `IfNotPresent`              |
| `service.nodePort`          | If `service.type` is `NodePort` and this is non-empty, sets the http node port of the service | `nil`                       |
| `service.type`              | Service type (ClusterIP, NodePort or LoadBalancer)                                            | `ClusterIP`                 |
| `ingress.enabled`           | Enables Ingress for Drone                                                                     | `false`                     |
| `ingress.annotations`       | Ingress annotations                                                                           | `{}`                        |
| `ingress.hosts`             | Ingress accepted hostnames                                                                    | `nil`                       |
| `ingress.tls`               | Ingress TLS configuration                                                                     | `[]`                        |
| `server.host`               | Drone **server** hostname                                                                     | `(internal hostname)`       |
| `server.scheme`             | Drone **server** scheme                                                                       | `(internal scheme)`         |
| `server.letsEncrypt`        | Drone **server** `DRONE_TLS_AUTOCERT`                                                         | `false`                     |
| `server.env`                | Drone **server** environment variables                                                        | `(default values)`          |
| `server.envSecrets`         | Drone **server** secret environment variables                                                 | `(default values)`          |
| `server.annotations`        | Drone **server** annotations                                                                  | `{}`                        |
| `server.resources`          | Drone **server** pod resource requests & limits                                               | `{}`                        |
| `server.schedulerName`      | Drone **server** alternate scheduler name                                                     | `nil`                       |
| `server.affinity`           | Drone **server** scheduling preferences                                                       | `{}`                        |
| `server.nodeSelector`       | Drone **server** node labels for pod assignment                                               | `{}`                        |
| `server.extraContainers`    | Additional sidecar containers                                                                 | `""`                        |
| `server.extraVolumes`       | Additional volumes for use in extraContainers                                                 | `""`                        |
| `agent.env`                 | Drone **agent** environment variables                                                         | `(default values)`          |
| `agent.replicas`            | Drone **agent** replicas                                                                      | `1`                         |
| `agent.annotations`         | Drone **agent** annotations                                                                   | `{}`                        |
| `agent.resources`           | Drone **agent** pod resource requests & limits                                                | `{}`                        |
| `agent.schedulerName`       | Drone **agent** alternate scheduler name                                                      | `nil`                       |
| `agent.affinity`            | Drone **agent** scheduling preferences                                                        | `{}`                        |
| `agent.nodeSelector`        | Drone **agent** node labels for pod assignment                                                | `{}`                        |
| `dind.enabled`              | Enable or disable **DinD**                                                                    | `true`                      |
| `dind.driver`               | **DinD** storage driver                                                                       | `overlay2`                  |
| `dind.resources`            | **DinD** pod resource requests & limits                                                       | `{}`                        |
| `dind.env`                  | **DinD** environment variables                                                                | `nil`                       |
| `dind.command`              | **DinD** custom command instead of default entry point                                        | `nil`                       |
| `dind.args`                 | **DinD** arguments for custom command or entry point                                          | `nil`                       |
| `secrets.enabled`           | Drone **secrets**                                                                             | `false`                     |
| `secrets.env`               | Drone **server** environment variables                                                        | `(default values)`          |
| `secrets.annotations`       | Drone **secrets** annotations                                                                 | `{}`                        |
| `secrets.resources`         | Drone **secrets** pod resource requests & limits                                              | `{}`                        |
| `secrets.schedulerName`     | Drone **secrets** alternate scheduler name                                                    | `nil`                       |
| `secrets.affinity`          | Drone **secrets** scheduling preferences                                                      | `{}`                        |
| `secrets.nodeSelector`      | Drone **secrets** node labels for pod assignment                                              | `{}`                        |
| `secrets.extraContainers`   | Additional sidecar containers                                                                 | `""`                        |
| `secrets.extraVolumes`      | Additional volumes for use in extraContainers                                                 | `""`                        |
| `metrics.prometheus.enabled` | Enable Prometheus metrics endpoint                                                           | `false`                     |
| `persistence.enabled`       | Use a PVC to persist data                                                                     | `true`                      |
| `persistence.existingClaim` | Use an existing PVC to persist data                                                           | `nil`                       |
| `persistence.storageClass`  | Storage class of backing PVC                                                                  | `nil`                       |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite                                                           | `ReadWriteOnce`             |
| `persistence.size`          | Size of data volume                                                                           | `1Gi`                       |
| `sharedSecret`              | Drone server and agent shared secret (Note: The Default random value changes on every `helm upgrade` causing a rolling update of server and agents) | `(random value)`            |
| `rbac.create`               | Specifies whether RBAC resources should be created.                                           | `true`                      |
| `rbac.apiVersion`           | RBAC API version                                                                              | `v1`                        |
| `serviceAccount.create`     | Specifies whether a ServiceAccount should be created.                                         | `true`                      |
| `serviceAccount.name`       | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template. | `(fullname template)` |

# Secrets

Drone supports add-ons, for secrets. You can choose from Amazon, Kubernetes, or
Vault, as the source of drone secrets. 

## Kubernetes secrets

You will need to create a secret with a key named `config`, which defines the
kubectl config file. If you are using certificates to authenticate your users,
keys matching the ca.pem, user cert, and user private key must also be defined
in the secret. 

After the secret has been applied, the values for `secrets.extraVolumes` and
`secrets.extraVolumeMounts` must be updated. The `extraVolumes` `secretName`
must match the name of the secret applied. The `extraVolumeMounts` `mountPath`
must match the base directory of the `secrets.env.KUBERNETES_CONFIG` path.

### Kubernetes secrets yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-kubeconfig
  # https://docs.drone.io/extend/secrets/kubernetes/config-in-kubernetes/
  annotations:
    # X-Drone-Repos: ORG/*
    # X-Drone-Events: push, tag
type: Opaque
stringData:
  config: |
    apiVersion: v1
    kind: Config
    preferences: {}
    clusters:
    - cluster:
        certificate-authority: /etc/kubernetes/production-ca.pem
        server: https://k8s.production.us-east-1.adaptly.com
      name: prod
    contexts:
    - context:
        cluster: prod
        namespace: default
        user: prod-admin
      name: prod
    current-context: prod
    users:
    - name: prod-admin
      user:
        client-certificate: /etc/kubernetes/production-admin.pem
        client-key: /etc/kubernetes/production-admin-key.pem
  production-admin-key.pem: |
    BASE64_KEY
  production-admin.pem: |
    BASE64_CERT
  production-ca.pem: |
    BASE64_CA_CERT
```

### Kubernetes secrets values yaml

```yaml
secrets:
  extraVolumes: |
    - name: kubeconfig
      secret:
        secretName: my-kubeconfig

  extraVolumeMounts: |
    - name: kubeconfig
      mountPath: /etc/kubernetes
```
