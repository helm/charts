# Concourse Helm Chart

[Concourse](https://concourse-ci.org/) is a simple and scalable CI system.

## TL;DR;

```console
$ helm install stable/concourse
```

## Introduction

This chart bootstraps a [Concourse](https://concourse-ci.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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

Scaling should typically be managed via the `helm upgrade` command, but `StatefulSets` don't yet work with `helm upgrade`. In the meantime, until `helm upgrade` works, if you want to change the number of replicas, you can use the `kubectl scale` command as shown below:

```console
$ kubectl scale statefulset my-release-worker --replicas=3
```

### Restarting workers

If a worker isn't taking on work, you can restart the worker with `kubectl delete pod`. This will initiate a graceful shutdown by "retiring" the worker, to ensure Concourse doesn't try looking for old volumes on the new worker. The value`worker.terminationGracePeriodSeconds` can be used to provide an upper limit on graceful shutdown time before forcefully terminating the container. Check the output of `fly workers`, and if a worker is `stalled`, you'll also need to run `fly prune-worker` to allow the new incarnation of the worker to start.

### Worker Liveness Probe

The worker's Liveness Probe will trigger a restart of the worker if it detects unrecoverable errors, by looking at the worker's logs. The set of strings used to identify such errors could change in the future, but can be tuned with `worker.fatalErrors`. See [values.yaml](values.yaml) for the defaults.

## Configuration

The following table lists the configurable parameters of the Concourse chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `image` | Concourse image | `concourse/concourse` |
| `imageTag` | Concourse image version | `4.2.1` |
| `imagePullPolicy` | Concourse image pull policy | `IfNotPresent` |
| `web.nameOverride` | Override the Concourse Web components name | `nil` |
| `web.replicas` | Number of Concourse Web replicas | `1` |
| `web.resources` | Concourse Web resource requests and limits | `{requests: {cpu: "100m", memory: "128Mi"}}` |
| `web.additionalAffinities` | Additional affinities to apply to web pods. E.g: node affinity | `{}` |
| `web.env` | Configure additional environment variables for the web containers | `[]` |
| `web.annotations`| Concourse Web deployment annotations | `nil` |
| `web.tolerations` | Tolerations for the web nodes | `[]` |
| `web.nodeSelector` | Node selector for web nodes | `{}` |
| `web.service.type` | Concourse Web service type | `ClusterIP` |
| `web.service.annotations` | Concourse Web Service annotations | `nil` |
| `web.service.loadBalancerIP` | The IP to use when web.service.type is LoadBalancer | `nil` |
| `web.service.loadBalancerSourceRanges` | Concourse Web Service Load Balancer Source IP ranges | `nil` |
| `web.service.atcNodePort` | Sets the nodePort for atc when using `NodePort` | `nil` |
| `web.service.tsaNodePort` | Sets the nodePort for tsa when using `NodePort` | `nil` |
| `web.ingress.enabled` | Enable Concourse Web Ingress | `false` |
| `web.ingress.annotations` | Concourse Web Ingress annotations | `{}` |
| `web.ingress.hosts` | Concourse Web Ingress Hostnames | `[]` |
| `web.ingress.tls` | Concourse Web Ingress TLS configuration | `[]` |
| `worker.nameOverride` | Override the Concourse Worker components name | `nil` |
| `worker.replicas` | Number of Concourse Worker replicas | `2` |
| `worker.minAvailable` | Minimum number of workers available after an eviction | `1` |
| `worker.resources` | Concourse Worker resource requests and limits | `{requests: {cpu: "100m", memory: "512Mi"}}` |
| `worker.env` | Configure additional environment variables for the worker container(s) | `[]` |
| `worker.annotations` | Annotations to be added to the worker pods | `{}` |
| `worker.additionalVolumeMounts` | VolumeMounts to be added to the worker pods | `nil` |
| `worker.additionalVolumes` | Volumes to be added to the worker pods | `nil` |
| `worker.additionalAffinities` | Additional affinities to apply to worker pods. E.g: node affinity | `{}` |
| `worker.tolerations` | Tolerations for the worker nodes | `[]` |
| `worker.terminationGracePeriodSeconds` | Upper bound for graceful shutdown to allow the worker to drain its tasks | `60` |
| `worker.fatalErrors` | Newline delimited strings which, when logged, should trigger a restart of the worker | *See [values.yaml](values.yaml)* |
| `worker.updateStrategy` | `OnDelete` or `RollingUpdate` (requires Kubernetes >= 1.7) | `RollingUpdate` |
| `worker.podManagementPolicy` | `OrderedReady` or `Parallel` (requires Kubernetes >= 1.7) | `Parallel` |
| `worker.hardAntiAffinity` | Should the workers be forced (as opposed to preferred) to be on different nodes? | `false` |
| `persistence.enabled` | Enable Concourse persistence using Persistent Volume Claims | `true` |
| `persistence.worker.storageClass` | Concourse Worker Persistent Volume Storage Class | `generic` |
| `persistence.worker.accessMode` | Concourse Worker Persistent Volume Access Mode | `ReadWriteOnce` |
| `persistence.worker.size` | Concourse Worker Persistent Volume Storage Size | `20Gi` |
| `postgresql.enabled` | Enable PostgreSQL as a chart dependency | `true` |
| `postgresql.postgresUser` | PostgreSQL User to create | `concourse` |
| `postgresql.postgresPassword` | PostgreSQL Password for the new user | `concourse` |
| `postgresql.postgresDatabase` | PostgreSQL Database to create | `concourse` |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence using Persistent Volume Claims | `true` |
| `rbac.create` | Enables creation of RBAC resources | `true` |
| `rbac.apiVersion` | RBAC version | `v1beta1` |
| `rbac.webServiceAccountName` | Name of the service account to use for web pods if `rbac.create` is `false` | `default` |
| `rbac.workerServiceAccountName` | Name of the service account to use for workers if `rbac.create` is `false` | `default` |
| `secrets.localUsers` | Create concourse local users. Default username and password are test:test *See [values.yaml](values.yaml)* |
| `secrets.create` | Create the secret resource from the following values. *See [Secrets](#secrets)* | `true` |
| `secrets.hostKey` | Concourse Host Private Key | *See [values.yaml](values.yaml)* |
| `secrets.hostKeyPub` | Concourse Host Public Key | *See [values.yaml](values.yaml)* |
| `secrets.sessionSigningKey` | Concourse Session Signing Private Key | *See [values.yaml](values.yaml)* |
| `secrets.workerKey` | Concourse Worker Private Key | *See [values.yaml](values.yaml)* |
| `secrets.workerKeyPub` | Concourse Worker Public Key | *See [values.yaml](values.yaml)* |
| `secrets.postgresqlUser` | PostgreSQL User Name | `nil` |
| `secrets.postgresqlPassword` | PostgreSQL User Password | `nil` |
| `secrets.postgresqlCaCert` | PostgreSQL CA certificate | `nil` |
| `secrets.postgresqlClientCert` | PostgreSQL Client certificate | `nil` |
| `secrets.postgresqlClientKey` | PostgreSQL Client key | `nil` |
| `secrets.encryptionKey` | current encryption key | `nil` |
| `secrets.oldEncryptionKey` | old encryption key, used for key rotation | `nil` |
| `secrets.awsSsmAccessKey` | AWS Access Key ID for SSM access | `nil` |
| `secrets.awsSsmSecretKey` | AWS Secret Access Key ID for SSM access | `nil` |
| `secrets.awsSsmSessionToken` | AWS Session Token for SSM access | `nil` |
| `secrets.cfClientId` | Client ID for cf auth provider | `nil` |
| `secrets.cfClientSecret` | Client secret for cf auth provider | `nil` |
| `secrets.cfCaCert` | CA certificate for cf auth provider | `nil` |
| `secrets.githubClientId` | Application client ID for GitHub OAuth | `nil` |
| `secrets.githubClientSecret` | Application client secret for GitHub OAuth | `nil` |
| `secrets.githubCaCert` | CA certificate for Enterprise Github OAuth | `nil` |
| `secrets.gitlabClientId` | Application client ID for GitLab OAuth | `nil` |
| `secrets.gitlabClientSecret` | Application client secret for GitLab OAuth | `nil` |
| `secrets.oauthClientId` | Application client ID for Generic OAuth | `nil` |
| `secrets.oauthClientSecret` | Application client secret for Generic OAuth | `nil` |
| `secrets.oauthCaCert` | CA certificate for Generic OAuth | `nil` |
| `secrets.oidcClientId` | Application client ID for OIDI OAuth | `nil` |
| `secrets.oidcClientSecret` | Application client secret for OIDC OAuth | `nil` |
| `secrets.oidcCaCert` | CA certificate for OIDC Oauth | `nil` |
| `secrets.vaultCaCert` | CA certificate use to verify the vault server SSL cert | `nil` |
| `secrets.vaultClientCert` | Vault Client Certificate | `nil` |
| `secrets.vaultClientKey` | Vault Client Key | `nil` |
| `secrets.vaultClientToken` | Vault periodic client token | `nil` |
| `secrets.influxdbPassword` | Password used to authenticate with influxdb | `nil` |
| `secrets.syslogCaCert` | SSL certificate to verify Syslog server | `nil` |

For configurable concourse parameters, refer to [values.yaml](values.yaml) `concourse` section. All parameters under this section are strictly mapped from concourse binary commands. For example if one needs to configure the concourse external URL, the param `concourse` -> `web` -> `externalUrl` should be set, which is equivalent to running concourse binary as `concourse web --external-url`. For those sub-sections have `enabled`, one will need to set `enabled` to be `true` to use the following params within the section.

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

You'll also need to create/copy secret values for optional features. See [templates/secrets.yaml](templates/secrets.yaml) for possible values. In the example below, we are not using the [PostgreSQL](#postgresql) chart dependency, and so we must set a `postgresql-uri` secret.

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

This chart mounts a Persistent Volume for each Concourse Worker. The volume is created using dynamic volume provisioning. If you want to disable it or change the persistence properties, update the `persistence` section of your custom `values.yaml` file:

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

By default, this chart will use a PostgreSQL database deployed as a chart dependency, with default values for username, password, and database name. These can be modified by setting the `postgresql.*` values.

You can also bring your own PostgreSQL. To do so, set `postgresql.enabled` to false. You'll then need to specify the full uri to the database, including the username and password, e.g. `postgres://concourse:changeme@my-postgres.com:5432/concourse?sslmode=require`. You can do this one of two ways:

1. Set `secrets.postgresqlUri` in your values

2. Set `postgresql-uri` in your release's secrets as described in [Secrets](#secrets).

The only way to completely avoid putting secrets in Helm is to bring your own PostgreSQL, and use option 2 above.

### Credential Management

Pipelines usually need credentials to do things. Concourse supports the use of a [Credential Manager](https://concourse-ci.org/creds.html) so your pipelines can contain references to secrets instead of the actual secret values. You can't use more than one credential manager at a time.

#### Kubernetes Secrets

By default, this chart will use Kubernetes Secrets as a credential manager. For a given Concourse *team*, a pipeline will look for secrets in a namespace named `[namespacePrefix][teamName]`. The namespace prefix is the release name hyphen by default, and can be overridden with the value `credentialManager.kubernetes.namespacePrefix`. Each team listed under `credentialManager.kubernetes.teams` will have a namespace created for it, and the namespace will remain after deletion of the release unless you set `credentialManager.kubernetes.keepNamespace` to `false`. By default, a namespace will be created for the `main` team.

The service account used by Concourse must have `get` access to secrets in that namespace. When `rbac.create` is true, this access is granted for each team listed under `credentialManager.kubernetes.teams`.

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

To use Vault, set `credentialManager.kubernetes.enabled` to false, and set the following values:


```yaml
## Configuration values for the Credential Manager.
## ref: https://concourse-ci.org/creds.html
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

#### AWS Systems Manager Parameter Store (SSM)

To use SSM, set `credentialManager.kubernetes.enabled` to false, and set `credentialManager.ssm.enabled` to true.

For a given Concourse *team*, a pipeline will look for secrets in SSM using either `/concourse/{team}/{secret}` or `/concourse/{team}/{pipeline}/{secret}`; the patterns can be overridden using the `credentialManager.ssm.teamSecretTemplate` and `credentialManager.ssm.pipelineSecretTemplate` settings.

Concourse requires AWS credentials which are able to read from SSM for this feature to function. Credentials can be set in the `secrets.awsSsm*` settings; if your cluster is running in a different AWS region, you may also need to set `credentialManager.ssm.region`.

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

Where `<kms-key-arn>` is the ARN of the KMS key used to encrypt the secrets in Paraemter Store, and the `<...arn...>` should be replaced with a correct ARN for your account and region's Parameter Store.

#### AWS Secrets Manager

To use Secrets Manager, set `credentialManager.kubernetes.enabled` to false, and set `credentialManager.awsSecretsManager.enabled` to true.

For a given Concourse *team*, a pipeline will look for secrets in Secrets Manager using either `/concourse/{team}/{secret}` or `/concourse/{team}/{pipeline}/{secret}`; the patterns can be overridden using the `credentialManager.awsSecretsManager.teamSecretTemplate` and `credentialManager.awsSecretsManager.pipelineSecretTemplate` settings.

Concourse requires AWS credentials which are able to read from Secrets Manager for this feature to function. Credentials can be set in the `secrets.awsSecretsmanager*` settings; if your cluster is running in a different AWS region, you may also need to set `credentialManager.awsSecretsManager.region`.

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
