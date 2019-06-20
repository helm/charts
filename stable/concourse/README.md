# Concourse Helm Chart

[Concourse](https://concourse-ci.org/) is a simple and scalable CI system.


## TL;DR;

```console
$ helm install stable/concourse
```


## Introduction

This chart bootstraps a [Concourse](https://concourse-ci.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites Details

* Kubernetes 1.6 (for [`pod affinity`](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) support)
* [`PersistentVolume`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) support on underlying infrastructure (if persistence is required)


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

> ps: By default, a [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) is created for the `main` team named after `${RELEASE}-main` and is kept untouched after a `helm delete`.
> See the [Configuration section](#configuration) for how to control the behavior.


### Cleanup orphaned Persistent Volumes

This chart uses [`StatefulSets`](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) for Concourse Workers. Deleting a `StatefulSet` does not delete associated `PersistentVolume`s.

Do the following after deleting the chart release to clean up orphaned Persistent Volumes.

```console
$ kubectl delete pvc -l app=${RELEASE-NAME}-worker
```


### Restarting workers

If a [Worker](https://concourse-ci.org/architecture.html#architecture-worker) isn't taking on work, you can recreate it with `kubectl delete pod`. This initiates a graceful shutdown by ["retiring"](https://concourse-ci.org/worker-internals.html#RETIRING-table) the worker, to ensure Concourse doesn't try looking for old volumes on the new worker.

The value`worker.terminationGracePeriodSeconds` can be used to provide an upper limit on graceful shutdown time before forcefully terminating the container.

Check the output of `fly workers`, and if a worker is [`stalled`](https://concourse-ci.org/worker-internals.html#STALLED-table), you'll also need to run [`fly prune-worker`](https://concourse-ci.org/administration.html#fly-prune-worker) to allow the new incarnation of the worker to start.

> **TIP**: you can download `fly` either from https://concourse-ci.org/download.html or the home page of your Concourse installation.


### Worker Liveness Probe

By default, the worker's [`LivenessProbe`](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes) will trigger a restart of the worker container if it detects errors when trying to reach the worker's healthcheck endpoint which takes care of making sure that the [workers' components](https://concourse-ci.org/architecture.html#architecture) can properly serve their purpose.

See [Configuration](#configuration) and [`values.yaml`](./values.yaml) for the configuration of both the `livenessProbe` (`worker.livenessProbe`) and the default healthchecking timeout (`concourse.worker.healthcheckTimeout`).


## Configuration

The following table lists the configurable parameters of the Concourse chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `fullnameOverride` | Provide a name to substitute for the full names of resources | `nil` |
| `imageDigest` | Specific image digest to use in place of a tag. | `nil` |
| `imagePullPolicy` | Concourse image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Array of imagePullSecrets in the namespace for pulling images | `[]` |
| `imageTag` | Concourse image version | `5.3.0` |
| `image` | Concourse image | `concourse/concourse` |
| `nameOverride` | Provide a name in place of `concourse` for `app:` labels | `nil` |
| `persistence.enabled` | Enable Concourse persistence using Persistent Volume Claims | `true` |
| `persistence.worker.accessMode` | Concourse Worker Persistent Volume Access Mode | `ReadWriteOnce` |
| `persistence.worker.size` | Concourse Worker Persistent Volume Storage Size | `20Gi` |
| `persistence.worker.storageClass` | Concourse Worker Persistent Volume Storage Class | `generic` |
| `postgresql.enabled` | Enable PostgreSQL as a chart dependency | `true` |
| `postgresql.persistence.accessMode` | Persistent Volume Access Mode | `ReadWriteOnce` |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence using Persistent Volume Claims | `true` |
| `postgresql.persistence.size` | Persistent Volume Storage Size | `8Gi` |
| `postgresql.persistence.storageClass` | Concourse data Persistent Volume Storage Class | `nil` |
| `postgresql.postgresDatabase` | PostgreSQL Database to create | `concourse` |
| `postgresql.postgresPassword` | PostgreSQL Password for the new user | `concourse` |
| `postgresql.postgresUser` | PostgreSQL User to create | `concourse` |
| `rbac.apiVersion` | RBAC version | `v1beta1` |
| `rbac.create` | Enables creation of RBAC resources | `true` |
| `rbac.webServiceAccountName` | Name of the service account to use for web pods if `rbac.create` is `false` | `default` |
| `rbac.workerServiceAccountName` | Name of the service account to use for workers if `rbac.create` is `false` | `default` |
| `secrets.awsSecretsmanagerAccessKey` | AWS Access Key ID for Secrets Manager access | `nil` |
| `secrets.awsSecretsmanagerSecretKey` | AWS Secret Access Key ID for Secrets Manager access | `nil` |
| `secrets.awsSecretsmanagerSessionToken` | AWS Session Token for Secrets Manager access | `nil` |
| `secrets.awsSsmAccessKey` | AWS Access Key ID for SSM access | `nil` |
| `secrets.awsSsmSecretKey` | AWS Secret Access Key ID for SSM access | `nil` |
| `secrets.awsSsmSessionToken` | AWS Session Token for SSM access | `nil` |
| `secrets.bitbucketCloudClientId` | Client ID for the BitbucketCloud OAuth | `nil` |
| `secrets.bitbucketCloudClientSecret` | Client Secret for the BitbucketCloud OAuth | `nil` |
| `secrets.cfCaCert` | CA certificate for cf auth provider | `nil` |
| `secrets.cfClientId` | Client ID for cf auth provider | `nil` |
| `secrets.cfClientSecret` | Client secret for cf auth provider | `nil` |
| `secrets.create` | Create the secret resource from the following values. *See [Secrets](#secrets)* | `true` |
| `secrets.credhubCaCert` | Value of PEM-encoded CA cert file to use to verify the CredHub server SSL cert. | `nil` |
| `secrets.credhubClientId` | Client ID for CredHub authorization. | `nil` |
| `secrets.credhubClientSecret` | Client secret for CredHub authorization. | `nil` |
| `secrets.encryptionKey` | current encryption key | `nil` |
| `secrets.githubCaCert` | CA certificate for Enterprise Github OAuth | `nil` |
| `secrets.githubClientId` | Application client ID for GitHub OAuth | `nil` |
| `secrets.githubClientSecret` | Application client secret for GitHub OAuth | `nil` |
| `secrets.gitlabClientId` | Application client ID for GitLab OAuth | `nil` |
| `secrets.gitlabClientSecret` | Application client secret for GitLab OAuth | `nil` |
| `secrets.hostKeyPub` | Concourse Host Public Key | *See [values.yaml](values.yaml)* |
| `secrets.hostKey` | Concourse Host Private Key | *See [values.yaml](values.yaml)* |
| `secrets.influxdbPassword` | Password used to authenticate with influxdb | `nil` |
| `secrets.ldapCaCert` | CA Certificate for LDAP | `nil` |
| `secrets.localUsers` | Create concourse local users. Default username and password are `test:test` *See [values.yaml](values.yaml)* |
| `secrets.oauthCaCert` | CA certificate for Generic OAuth | `nil` |
| `secrets.oauthClientId` | Application client ID for Generic OAuth | `nil` |
| `secrets.oauthClientSecret` | Application client secret for Generic OAuth | `nil` |
| `secrets.oidcCaCert` | CA certificate for OIDC Oauth | `nil` |
| `secrets.oidcClientId` | Application client ID for OIDI OAuth | `nil` |
| `secrets.oidcClientSecret` | Application client secret for OIDC OAuth | `nil` |
| `secrets.oldEncryptionKey` | old encryption key, used for key rotation | `nil` |
| `secrets.postgresCaCert` | PostgreSQL CA certificate | `nil` |
| `secrets.postgresClientCert` | PostgreSQL Client certificate | `nil` |
| `secrets.postgresClientKey` | PostgreSQL Client key | `nil` |
| `secrets.postgresPassword` | PostgreSQL User Password | `nil` |
| `secrets.postgresUser` | PostgreSQL User Name | `nil` |
| `secrets.sessionSigningKey` | Concourse Session Signing Private Key | *See [values.yaml](values.yaml)* |
| `secrets.syslogCaCert` | SSL certificate to verify Syslog server | `nil` |
| `secrets.teamAuthorizedKeys` | Array of team names and worker public keys for external workers | `nil` |
| `secrets.vaultAuthParam` | Paramter to pass when logging in via the backend | `nil` |
| `secrets.vaultCaCert` | CA certificate use to verify the vault server SSL cert | `nil` |
| `secrets.vaultClientCert` | Vault Client Certificate | `nil` |
| `secrets.vaultClientKey` | Vault Client Key | `nil` |
| `secrets.vaultClientToken` | Vault periodic client token | `nil` |
| `secrets.webTlsCert` | TLS certificate for the web component to terminate TLS connections | `nil` |
| `secrets.webTlsKey` | An RSA private key, used to encrypt HTTPS traffic  | `nil` |
| `secrets.workerKeyPub` | Concourse Worker Public Key | *See [values.yaml](values.yaml)* |
| `secrets.workerKey` | Concourse Worker Private Key | *See [values.yaml](values.yaml)* |
| `web.additionalAffinities` | Additional affinities to apply to web pods. E.g: node affinity | `{}` |
| `web.additionalVolumeMounts` | VolumeMounts to be added to the web pods | `nil` |
| `web.additionalVolumes` | Volumes to be added to the web pods | `nil` |
| `web.labels`| Additional labels to be added to the web pods | `{}` |
| `web.annotations`| Annotations to be added to the web pods | `{}` |
| `web.authSecretsPath` | Specify the mount directory of the web auth secrets | `/concourse-auth` |
| `web.credhubSecretsPath` | Specify the mount directory of the web credhub secrets | `/concourse-credhub` |
| `web.enabled` | Enable or disable the web component | `true` |
| `web.env` | Configure additional environment variables for the web containers | `[]` |
| `web.ingress.annotations` | Concourse Web Ingress annotations | `{}` |
| `web.ingress.enabled` | Enable Concourse Web Ingress | `false` |
| `web.ingress.hosts` | Concourse Web Ingress Hostnames | `[]` |
| `web.ingress.tls` | Concourse Web Ingress TLS configuration | `[]` |
| `web.keySecretsPath` | Specify the mount directory of the web keys secrets | `/concourse-keys` |
| `web.livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded | `5` |
| `web.livenessProbe.httpGet.path` | Path to access on the HTTP server when performing the healthcheck | `/api/v1/info` |
| `web.livenessProbe.httpGet.port` | Name or number of the port to access on the container | `atc` |
| `web.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probes are initiated | `10` |
| `web.livenessProbe.periodSeconds` | How often (in seconds) to perform the probe | `15` |
| `web.livenessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `3` |
| `web.nameOverride` | Override the Concourse Web components name | `nil` |
| `web.nodeSelector` | Node selector for web nodes | `{}` |
| `web.postgresqlSecretsPath` | Specify the mount directory of the web postgresql secrets | `/concourse-postgresql` |
| `web.readinessProbe.httpGet.path` | Path to access on the HTTP server when performing the healthcheck | `/api/v1/info` |
| `web.readinessProbe.httpGet.port` | Name or number of the port to access on the container | `atc` |
| `web.replicas` | Number of Concourse Web replicas | `1` |
| `web.strategy` | Strategy for updates to deployment. | `{}` |
| `web.resources.requests.cpu` | Minimum amount of cpu resources requested | `100m` |
| `web.resources.requests.memory` | Minimum amount of memory resources requested | `128Mi` |
| `web.service.annotations` | Concourse Web Service annotations | `nil` |
| `web.service.atcNodePort` | Sets the nodePort for atc when using `NodePort` | `nil` |
| `web.service.atcTlsNodePort` | Sets the nodePort for atc tls when using `NodePort` | `nil` |
| `web.service.labels` | Additional concourse web service labels | `nil` |
| `web.service.loadBalancerIP` | The IP to use when web.service.type is LoadBalancer | `nil` |
| `web.service.loadBalancerSourceRanges` | Concourse Web Service Load Balancer Source IP ranges | `nil` |
| `web.service.tsaNodePort` | Sets the nodePort for tsa when using `NodePort` | `nil` |
| `web.service.type` | Concourse Web service type | `ClusterIP` |
| `web.sidecarContainers` | Array of extra containers to run alongside the Concourse web container | `nil` |
| `web.syslogSecretsPath` | Specify the mount directory of the web syslog secrets | `/concourse-syslog` |
| `web.tlsSecretsPath` | Where in the container the web TLS secrets should be mounted | `/concourse-web-tls` |
| `web.tolerations` | Tolerations for the web nodes | `[]` |
| `web.vaultSecretsPath` | Specify the mount directory of the web vault secrets | `/concourse-vault` |
| `worker.additionalAffinities` | Additional affinities to apply to worker pods. E.g: node affinity | `{}` |
| `worker.additionalVolumeMounts` | VolumeMounts to be added to the worker pods | `nil` |
| `worker.additionalVolumes` | Volumes to be added to the worker pods | `nil` |
| `web.labels`| Additional labels to be added to the worker pods | `{}` |
| `worker.annotations` | Annotations to be added to the worker pods | `{}` |
| `worker.cleanUpWorkDirOnStart` | Removes any previous state created in `concourse.worker.workDir` | `true` |
| `worker.emptyDirSize` | When persistance is disabled this value will be used to limit the emptyDir volume size | `nil` |
| `worker.enabled` | Enable or disable the worker component. You should set postgres.enabled=false in order not to get an unnecessary Postgres chart deployed | `true` |
| `worker.env` | Configure additional environment variables for the worker container(s) | `[]` |
| `worker.hardAntiAffinity` | Should the workers be forced (as opposed to preferred) to be on different nodes? | `false` |
| `worker.keySecretsPath` | Specify the mount directory of the worker keys secrets | `/concourse-keys` |
| `worker.livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded | `5` |
| `worker.livenessProbe.httpGet.path` | Path to access on the HTTP server when performing the healthcheck | `/` |
| `worker.livenessProbe.httpGet.port` | Name or number of the port to access on the container | `worker-hc` |
| `worker.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probes are initiated | `10` |
| `worker.livenessProbe.periodSeconds` | How often (in seconds) to perform the probe | `15` |
| `worker.livenessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `3` |
| `worker.minAvailable` | Minimum number of workers available after an eviction | `1` |
| `worker.nameOverride` | Override the Concourse Worker components name | `nil` |
| `worker.nodeSelector` | Node selector for worker nodes | `{}` |
| `worker.podManagementPolicy` | `OrderedReady` or `Parallel` (requires Kubernetes >= 1.7) | `Parallel` |
| `worker.readinessProbe` | Periodic probe of container service readiness | `{}` |
| `worker.replicas` | Number of Concourse Worker replicas | `2` |
| `worker.resources.requests.cpu` | Minimum amount of cpu resources requested | `100m` |
| `worker.resources.requests.memory` | Minimum amount of memory resources requested | `512Mi` |
| `worker.sidecarContainers` | Array of extra containers to run alongside the Concourse worker container | `nil` |
| `worker.terminationGracePeriodSeconds` | Upper bound for graceful shutdown to allow the worker to drain its tasks | `60` |
| `worker.tolerations` | Tolerations for the worker nodes | `[]` |
| `worker.updateStrategy` | `OnDelete` or `RollingUpdate` (requires Kubernetes >= 1.7) | `RollingUpdate` |

For configurable Concourse parameters, refer to [`values.yaml`](values.yaml)' `concourse` section. All parameters under this section are strictly mapped from the `concourse` binary commands.

For example if one needs to configure the Concourse external URL, the param `concourse` -> `web` -> `externalUrl` should be set, which is equivalent to running the `concourse` binary as `concourse web --external-url`.

For those sub-sections that have `enabled`, one needs to set `enabled` to be `true` to use the following params within the section.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/concourse
```

> **Tip**: You can use the default [values.yaml](values.yaml)


### Secrets

For your convenience, this chart provides some default values for secrets, but it is recommended that you generate and manage these secrets outside the Helm chart.

To do that, set `secrets.create` to `false`, create files for each secret value, and turn it all into a Kubernetes [Secret](https://kubernetes.io/docs/concepts/configuration/secret/).

Be careful with introducing trailing newline characters; following the steps below ensures none end up in your secrets. First, perform the following to create the mandatory secret values:

```sh
# Create a directory to host the set of secrets that are
# required for a working Concourse installation and get
# into it.
#
mkdir concourse-secrets
cd concourse-secrets

# Generate the files for the secrets that are required:
# - web key pair,
# - worker key pair, and
# - the session signing token.
#
ssh-keygen -t rsa -f host-key  -N ''
mv host-key.pub host-key-pub
ssh-keygen -t rsa -f worker-key  -N ''
mv worker-key.pub worker-key-pub
ssh-keygen -t rsa -f session-signing-key  -N ''
rm session-signing-key.pub
printf "%s:%s" "concourse" "$(openssl rand -base64 24)" > local-users
```

All the worker-specific secrets, namely, `workerKey`, `workerKeyPub`, `hostKeyPub` are to be added to a separate Kubernetes secrets object with the name [release name]-worker.

All other secrets are to be added to a secrets object with the name `[release name]-web`.

For the time being, the secret `workerKeyPub` is to be added to both the worker and the web secret objects, until investigated within issue #13019.

You'll also need to create/copy secret values for optional features. See [templates/web-secrets.yaml](templates/web-secrets.yaml) and [templates/web-secrets.yaml](templates/web-secrets.yaml)  for possible values.

In the example below, we are not using the [PostgreSQL](#postgresql) chart dependency, and so we must set `postgresql-user` and `postgresql-password` secrets.

```sh
# Still within the directory where our secrets exist,
# copy a postgres user to clipboard and paste it to file.
#
printf "%s" "$(pbpaste)" > postgresql-user

# Copy a postgres password to clipboard and paste it to file
#
printf "%s" "$(pbpaste)" > postgresql-password

# Copy Github client id and secrets to clipboard and paste to files
#
printf "%s" "$(pbpaste)" > github-client-id
printf "%s" "$(pbpaste)" > github-client-secret

# Set an encryption key for DB encryption at rest
#
printf "%s" "$(openssl rand -base64 24)" > encryption-key
```

Then create a secret called `[release-name]-concourse` from all the secret value files in the current folder:

```console
kubectl create secret generic my-release-concourse --from-file=.
```

Make sure you clean up after yourself.


### Persistence

This chart mounts a Persistent Volume for each Concourse Worker.

The volume is created using dynamic volume provisioning.

If you want to disable it or change the persistence properties, update the `persistence` section of your custom `values.yaml` file:

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

It is highly recommended to use Persistent Volumes for Concourse Workers; otherwise, the Concourse volumes managed by the Worker are stored in an [`emptyDir`](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) volume on the Kubernetes node's disk. This will interfere with Kubernete's [ImageGC](https://kubernetes.io/docs/concepts/cluster-administration/kubelet-garbage-collection/#image-collection) and the node's disk will fill up as a result.


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

By default, this chart uses a PostgreSQL database deployed as a chart dependency, with default values for username, password, and database name. These can be modified by setting the `postgresql.*` values.

You can also bring your own PostgreSQL. To do so, set `postgresql.enabled` to false, and then configure Concourse's `postgres` values (`concourse.web.postgres.*`).

Note that some values get set in the form of secrets, like `postgresql-user`, `postgresql-password`, and others (see [templates/secrets.yaml](templates/secrets.yaml) for possible values and the [secrets section](#secrets) on this README for guidance on how to set those secrets).


### Credential Management

Pipelines usually need credentials to do things. Concourse supports the use of a [Credential Manager](https://concourse-ci.org/creds.html) so your pipelines can contain references to secrets instead of the actual secret values. You can't use more than one credential manager at a time.

#### Kubernetes Secrets

By default, this chart uses Kubernetes Secrets as a credential manager.

For a given Concourse *team*, a pipeline looks for secrets in a namespace named `[namespacePrefix][teamName]`. The namespace prefix is the release name followed by a hyphen by default, and can be overridden with the value `concourse.web.kubernetes.namespacePrefix`. Each team listed under `concourse.web.kubernetes.teams` will have a namespace created for it, and the namespace remains after deletion of the release unless you set `concourse.web.kubernetes.keepNamespace` to `false`. By default, a namespace will be created for the `main` team.

The service account used by Concourse must have `get` access to secrets in that namespace. When `rbac.create` is true, this access is granted for each team listed under `concourse.web.kubernetes.teams`.

Here are some examples of the lookup heuristics, given release name `concourse`:

In team `accounting-dev`, pipeline `my-app`; the expression `((api-key))` resolves to:

1. the secret value in namespace: `concourse-accounting-dev` secret: `my-app.api-key`, key: `value`
2. and if not found, is the value in namespace: `concourse-accounting-dev` secret: `api-key`, key: `value`

In team accounting-dev, pipeline `my-app`, the expression `((common-secrets.api-key))` resolves to:

1. the secret value in namespace: `concourse-accounting-dev` secret: `my-app.common-secrets`, key: `api-key`
2. and if not found, is the value in namespace: `concourse-accounting-dev` secret: `common-secrets`, key: `api-key`

Be mindful of your team and pipeline names, to ensure they can be used in namespace and secret names, e.g. no underscores.

To test, create a secret in namespace `concourse-main`:

```console
kubectl create secret generic hello --from-literal 'value=Hello world!'
```

Then `fly set-pipeline` with the following pipeline, and trigger it:

```yaml
jobs:
- name: hello-world
  plan:
  - task: say-hello
    config:
      platform: linux
      image_resource:
        type: docker-image
        source: {repository: alpine}
      params:
        HELLO: ((hello))
      run:
        path: /bin/sh
        args: ["-c", "echo $HELLO"]
```

#### Hashicorp Vault

To use Vault, set `concourse.web.kubernetes.enabled` to false, and set the following values:


```yaml
## Configuration values for the Credential Manager.
## ref: https://concourse-ci.org/creds.html
##
concourse:
  web:
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

#### Credhub

To use Credhub, set `concourse.web.kubernetes.enabled` to false, and consider the following values:

```yaml
## Configuration for using Credhub as a credential manager.
## Ref: https://concourse-ci.org/credhub-credential-manager.html
##
concourse:
  web:
    credhub:
      ## Enable the use of Credhub as a credential manager.
      ##
      enabled: true

      ## CredHub server address used to access secrets
      ## Example: https://credhub.example.com
      ##
      url:

      ## Path under which to namespace credential lookup. (default: /concourse)
      ##
      pathPrefix:

      ## Enables using a CA Certificate
      ##
      useCaCert: false

      ## Enables insecure SSL verification.
      ##
      insecureSkipVerify: false
```

#### AWS Systems Manager Parameter Store (SSM)

To use SSM, set `concourse.web.kubernetes.enabled` to false, and set `concourse.web.awsSsm.enabled` to true.

Authentication can be configured to use an access key and secret key as well as a session token. This is done by setting `concourse.web.awsSsm.keyAuth.enabled` to `true`. Alternatively, if it set to `false`, AWS IAM role based authentication (instance or pod credentials) is assumed. To use a session token, `concourse.web.awsSsm.useSessionToken` should be set to `true`. The secret values can be managed using the values specified in this helm chart or separately. For more details, see https://concourse-ci.org/creds.html#ssm.

For a given Concourse *team*, a pipeline looks for secrets in SSM using either `/concourse/{team}/{secret}` or `/concourse/{team}/{pipeline}/{secret}`; the patterns can be overridden using the `concourse.web.awsSsm.teamSecretTemplate` and `concourse.web.awsSsm.pipelineSecretTemplate` settings.

Concourse requires AWS credentials which are able to read from SSM for this feature to function. Credentials can be set in the `secrets.awsSsm*` settings; if your cluster is running in a different AWS region, you may also need to set `concourse.web.awsSsm.region`.

The minimum IAM policy you need to use SSM with Concourse is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "kms:Decrypt",
      "Resource": "<kms-key-arn>",
      "Effect": "Allow"
    },
    {
      "Action": "ssm:GetParameter*",
      "Resource": "<...arn...>:parameter/concourse/*",
      "Effect": "Allow"
    }
  ]
}
```

Where `<kms-key-arn>` is the ARN of the KMS key used to encrypt the secrets in Parameter Store, and the `<...arn...>` should be replaced with a correct ARN for your account and region's Parameter Store.

#### AWS Secrets Manager

To use Secrets Manager, set `concourse.web.kubernetes.enabled` to false, and set `concourse.web.awsSecretsManager.enabled` to true.

Authentication can be configured to use an access key and secret key as well as a session token. This is done by setting `concourse.web.awsSecretsManager.keyAuth.enabled` to `true`. Alternatively, if it set to `false`, AWS IAM role based authentication (instance or pod credentials) is assumed. To use a session token, `concourse.web.awsSecretsManger.useSessionToken` should be set to `true`. The secret values can be managed using the values specified in this helm chart or separately. For more details, see https://concourse-ci.org/creds.html#asm.

For a given Concourse *team*, a pipeline looks for secrets in Secrets Manager using either `/concourse/{team}/{secret}` or `/concourse/{team}/{pipeline}/{secret}`; the patterns can be overridden using the `concourse.web.awsSecretsManager.teamSecretTemplate` and `concourse.web.awsSecretsManager.pipelineSecretTemplate` settings.

Concourse requires AWS credentials which are able to read from Secrets Manager for this feature to function. Credentials can be set in the `secrets.awsSecretsmanager*` settings; if your cluster is running in a different AWS region, you may also need to set `concourse.web.awsSecretsManager.region`.

The minimum IAM policy you need to use Secrets Manager with Concourse is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAccessToSecretManagerParameters",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowAccessGetSecret",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": [
        "arn:aws:secretsmanager:::secret:/concourse/*"
      ]
    }
  ]
}
```
