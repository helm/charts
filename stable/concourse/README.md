# Concourse Helm Chart

[Concourse](https://concourse.ci/) is a simple and scalable CI system.

## TL;DR;

```console
$ helm install stable/concourse
```

## Introduction

This chart bootstraps a [Concourse](https://concourse.ci/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites Details

* Kubernetes 1.6 (for `pod affinity` support)
* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/concourse
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

### Cleanup orphaned Persistent Volumes

This chart uses `StatefulSets` for Concourse Workers. Deleting a `StatefulSet` will not delete associated Persistent Volumes.

Do the following after deleting the chart release to clean up orphaned Persistent Volumes.

```console
$ kubectl delete pvc -l app=${RELEASE-NAME}-worker
```

## Scaling the Chart

Scaling should typically be managed via the `helm upgrade` command, but `StatefulSets` don't yet work with `helm upgrade`. In the meantime, until `helm upgrade` works, if you want to change the number of replicas, you can use the kubectl scale as shown below:

```console
$ kubectl scale statefulset my-release-worker --replicas=3
```

### Restarting workers

If a worker isn't taking on work, you can restart the worker with `kubectl delete pod`. This will initiate a graceful shutdown by "retiring" the worker, to ensure Concourse doesn't try looking for old volumes on the new worker. The value`worker.terminationGracePeriodSeconds` can be used to provide an upper limit on graceful shutdown time before forcefully terminating the container. Check the output of `fly workers`, and if a worker is `stalled`, you'll also need to run `fly prune-worker` to allow the new incarnation of the worker can start.

### Worker Liveness Probe

The worker's Liveness Probe will trigger a restart of the worker if it detects unrecoverable errors, by looking at the worker's logs. The set of strings used to identify such errors could change in the future, but can be tuned with `worker.fatalErrors`. See [values.yaml](values.yaml) for the defaults.

## Configuration

The following tables lists the configurable parameters of the Concourse chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `image` | Concourse image | `concourse/concourse` |
| `imageTag` | Concourse image version | `3.8.0` |
| `imagePullPolicy` |Concourse image pull policy |  `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `concourse.username` | Concourse Basic Authentication Username | `concourse` |
| `concourse.password` | Concourse Basic Authentication Password | `concourse` |
| `concourse.hostKey` | Concourse Host Private Key | *See [#ssh-keys](#ssh-keys)* |
| `concourse.hostKeyPub` | Concourse Host Public Key | *See [#ssh-keys](#ssh-keys)* |
| `concourse.sessionSigningKey` | Concourse Session Signing Private Key | *See [#ssh-keys](#ssh-keys)* |
| `concourse.workerKey` | Concourse Worker Private Key | *See [#ssh-keys](#ssh-keys)* |
| `concourse.workerKeyPub` | Concourse Worker Public Key | *See [#ssh-keys](#ssh-keys)* |
| `concourse.atcPort` | Concourse ATC listen port | `8080` |
| `concourse.tsaPort` | Concourse TSA listen port | `2222` |
| `concourse.allowSelfSignedCertificates` | Allow self signed certificates | `true` |
| `concourse.authDuration` | Length of time for which tokens are valid | `24h` |
| `concourse.resourceCheckingInterval` | Interval on which to check for new versions of resources | `1m` |
| `concourse.oldResourceGracePeriod` | How long to cache the result of a get step after a newer version of the resource is found | `5m` |
| `concourse.resourceCacheCleanupInterval` | The interval on which to check for and release old caches of resource versions | `30s` |
| `concourse.baggageclaimDriver` | The filesystem driver used by baggageclaim | `naive` |
| `concourse.containerPlacementStrategy` | The selection strategy for placing containers onto workers | `random` |
| `concourse.externalURL` | URL used to reach any ATC from the outside world | `nil` |
| `concourse.dockerRegistry` | An URL pointing to the Docker registry to use to fetch Docker images | `nil` |
| `concourse.insecureDockerRegistry` | Docker registry(ies) (comma separated) to allow connecting to even if not secure | `nil` |
| `concourse.githubAuthClientId` | Application client ID for enabling GitHub OAuth | `nil` |
| `concourse.githubAuthClientSecret` | Application client secret for enabling GitHub OAuth | `nil` |
| `concourse.githubAuthOrganization` | GitHub organizations (comma separated) whose members will have access | `nil` |
| `concourse.githubAuthTeam` | GitHub teams (comma separated) whose members will have access | `nil` |
| `concourse.githubAuthUser` | GitHub users (comma separated) to permit access | `nil` |
| `concourse.githubAuthAuthUrl` | Override default endpoint AuthURL for Github Enterprise | `nil` |
| `concourse.githubAuthTokenUrl` | Override default endpoint TokenURL for Github Enterprise | `nil` |
| `concourse.githubAuthApiUrl` | Override default API endpoint URL for Github Enterprise | `nil` |
| `concourse.gitlabAuthClientId` | Application client ID for enabling GitLab OAuth | `nil` |
| `concourse.gitlabAuthClientSecret` | Application client secret for enabling GitLab OAuth | `nil` |
| `concourse.gitlabAuthGroup` | GitLab groups (comma separated) whose members will have access | `nil` |
| `concourse.gitlabAuthAuthUrl` | Endpoint AuthURL for GitLab server | `nil` |
| `concourse.gitlabAuthTokenUrl` | Endpoint TokenURL for GitLab server | `nil` |
| `concourse.gitlabAuthApiUrl` | API endpoint URL for GitLab server | `nil` |
| `concourse.genericOauthDisplayName` | Name for this auth method on the web UI | `nil` |
| `concourse.genericOauthClientId` | Application client ID for enabling generic OAuth | `nil` |
| `concourse.genericOauthClientSecret` | Application client secret for enabling generic OAuth | `nil` |
| `concourse.genericOauthAuthUrl` | Generic OAuth provider AuthURL endpoint | `nil` |
| `concourse.genericOauthAuthUrlParam` | Parameters (comma separated) to pass to the authentication server AuthURL | `nil` |
| `concourse.genericOauthScope` | Optional scope required to authorize user | `nil` |
| `concourse.genericOauthTokenUrl` | Generic OAuth provider TokenURL endpoint | `nil` |
| `web.nameOverride` | Override the Concourse Web components name | `web` |
| `web.replicas` | Number of Concourse Web replicas | `1` |
| `web.resources` | Concourse Web resource requests and limits | `{requests: {cpu: "100m", memory: "128Mi"}}` |
| `web.service.type` | Concourse Web service type | `NodePort` |
| `web.service.annotations` | Concourse Web Service annotations | `{}` |
| `web.ingress.enabled` | Enable Concourse Web Ingress | `false` |
| `web.ingress.annotations` | Concourse Web Ingress annotations | `{}` |
| `web.ingress.hosts` | Concourse Web Ingress Hostnames | `[]` |
| `web.ingress.tls` | Concourse Web Ingress TLS configuration | `[]` |
| `web.additionalAffinities` | Additional affinities to apply to web pods. E.g: node affinity | `nil` |
| `web.metrics.prometheus.enabled` | Enable Prometheus metrics exporter | `false` |
| `web.metrics.prometheus.port` | Port for exporting Prometeus metrics | `9391` |
| `worker.nameOverride` | Override the Concourse Worker components name| `worker` |
| `worker.replicas` | Number of Concourse Worker replicas | `2` |
| `worker.minAvailable` | Minimum number of workers available after an eviction | `1` |
| `worker.resources` | Concourse Worker resource requests and limits | `{requests: {cpu: "100m", memory: "512Mi"}}` |
| `worker.additionalAffinities` | Additional affinities to apply to worker pods. E.g: node affinity | `nil` |
| `worker.terminationGracePeriodSeconds` | Upper bound for graceful shutdown to allow the worker to drain its tasks | `60` |
| `worker.fatalErrors` | Newline delimited strings which, when logged, should trigger a restart of the worker | *See [values.yaml](values.yaml)* |
| `worker.updateStrategy` | `OnDelete` or `RollingUpdate` (requires Kubernetes >= 1.7) | `RollingUpdate` |
| `worker.podManagementPolicy` | `OrderedReady` or `Parallel` (requires Kubernetes >= 1.7) | `Parallel` |
| `persistence.enabled` | Enable Concourse persistence using Persistent Volume Claims | `true` |
| `persistence.worker.class` | Concourse Worker Persistent Volume Storage Class | `generic` |
| `persistence.worker.accessMode` | Concourse Worker Persistent Volume Access Mode | `ReadWriteOnce` |
| `persistence.worker.size` | Concourse Worker Persistent Volume Storage Size | `20Gi` |
| `postgresql.enabled` | Enable PostgreSQL as a chart dependency | `true` |
| `postgresql.uri` | PostgreSQL connection URI | `nil` |
| `postgresql.postgresUser` | PostgreSQL User to create | `concourse` |
| `postgresql.postgresPassword` | PostgreSQL Password for the new user | `concourse` |
| `postgresql.postgresDatabase` | PostgreSQL Database to create | `concourse` |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence using Persistent Volume Claims | `true` |
| `credentialManager.enabled` | Enable Credential Manager | `false` |
| `credentialManager.vault.url` | Vault Server URL | `nil` |
| `credentialManager.vault.pathPrefix` | Vault path to namespace secrets | `/concourse` |
| `credentialManager.vault.caCert` | CA public certificate when using self-signed TLS with Vault | `nil` |
| `credentialManager.vault.authBackend` | Vault Authentication Backend to use, leave blank when using clientToken | `nil` |
| `credentialManager.vault.clientToken` | Vault periodic client token | `nil` |
| `credentialManager.vault.appRoleId` | Vault AppRole RoleID | `nil` |
| `credentialManager.vault.appRoleSecretId` | Vault AppRole SecretID | `nil` |
| `credentialManager.vault.clientCert` | Vault Client Certificate | `nil` |
| `credentialManager.vault.clientKey` | Vault Client Key | `nil` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/concourse
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Secrets

For your convenience, this chart provides some default values for secrets, but it is recommended that you generate and manage these secrets outside the Helm chart. To do this, set `secrets.create` to `false`, create files for each secret value, and turn it all into a k8s secret. Be careful with introducing trailing newline characters; following the steps below ensures none will end up in your secrets. First, perform the following to create the manditory secret values:

```console
mkdir concourse-secrets
cd concourse-secrets
ssh-keygen -t rsa -f host-key  -N ''
mv host-key.pub host-key-pub
ssh-keygen -t rsa -f worker-key  -N ''
mv worker-key.pub worker-key-pub
ssh-keygen -t rsa -f session-signing-key  -N ''
rm session-signing-key.pub
printf "%s" "concourse" > basic-auth-username
printf "%s" "$(openssl rand -base64 24)" > basic-auth-password
```

You'll also need to create/copy secret values for postgres, and any other optional values. See [templates/secrets.yaml](templates/secrets.yaml) for possible values. E.g.

```console
# copy a posgres URI to clipboard and paste it to file
printf "%s" "$(pbpaste)" > postgresql-uri
# copy Github client id and secrets to clipboard and paste to files
printf "%s" "$(pbpaste)" > github-auth-client-id
printf "%s" "$(pbpaste)" > github-auth-client-secret
# set an encryption key for DB encryption at rest
printf "%s" "$(openssl rand -base64 24)" > encryption-key
```

Then create a secret called [release-name]-concourse from all the secret value files in the current folder:

```console
kubectl create secret generic my-release-concourse --from-file=.
```

Make sure you clean up after yourself.

### Persistence

This chart mounts a Persistent Volume volume for each Concourse Worker. The volume is created using dynamic volume provisioning. If you want to disable it or change the persistence properties, update the `persistence` section of your custom `values.yaml` file:

```yaml
## Persistent Volume Storage configuration.
## ref: https://kubernetes.io/docs/user-guide/persistent-volumes
##
persistence:
  ## Enable persistence using Persistent Volume Claims.
  ##
  enabled: true

  ## Worker Persistence configuration.
  ##
  worker:
    ## Persistent Volume Storage Class.
    ##
    class: generic

    ## Persistent Volume Access Mode.
    ##
    accessMode: ReadWriteOnce

    ## Persistent Volume Storage Size.
    ##
    size: "20Gi"
```

It is highly recommended to use Persistent Volumes for Concourse Workers; otherwise the container images managed by the Worker are stored in an `emptyDir` volume on the node's disk. This will interfere with k8s ImageGC and the node's disk will fill up as a result. This will be fixed in a future release of k8s: https://github.com/kubernetes/kubernetes/pull/57020

### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls concourse-web-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the `web.ingress.tls` section of your custom `values.yaml` file:

```yaml
## Configuration values for Concourse Web components.
##
web:
  ## Ingress configuration.
  ## ref: https://kubernetes.io/docs/user-guide/ingress/
  ##
  ingress:
    ## Enable ingress.
    ##
    enabled: true

    ## Hostnames.
    ## Must be provided if Ingress is enabled.
    ##
    hosts:
      - concourse.domain.com

    ## TLS configuration.
    ## Secrets must be manually created in the namespace.
    ##
    tls:
      - secretName: concourse-web-tls
        hosts:
          - concourse.domain.com
```


### PostgreSQL

By default, this chart will use a PostgreSQL database deployed as a chart dependency. You can also bring your own PostgreSQL. To do so, set the following in your custom `values.yaml` file:

```yaml
## Configuration values for the postgresql dependency.
## ref: https://github.com/kubernetes/charts/blob/master/stable/postgresql/README.md
##
postgresql:

  ## Use the PostgreSQL chart dependency.
  ## Set to false if bringing your own PostgreSQL.
  ##
  enabled: false

  ## If bringing your own PostgreSQL, the full uri to use
  ## e.g. postgres://concourse:changeme@my-postgres.com:5432/concourse?sslmode=require
  ##
  uri: postgres://concourse:changeme@my-postgres.com:5432/concourse?sslmode=require

```

### Credential Management

By default, this chart will not use a [Credential Manager](https://concourse.ci/creds.html).

```yaml
## Configuration values for the Credential Manager.
## ref: https://concourse.ci/creds.html
##
credentialManager:

  vault:
    ## Use Hashicorp Vault for the Credential Manager.
    ##
    enabled: false

    ## URL pointing to vault addr (i.e. http://vault:8200).
    ##
    # url:

    ## vault path under which to namespace credential lookup, defaults to /concourse.
    ##
    # pathPrefix:

```
