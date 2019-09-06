# Atlantis
[Atlantis](https://www.runatlantis.io/) is a tool for safe collaboration on [Terraform](https://www.terraform.io/) repositories.

## Introduction
This chart creates a single pod in a StatefulSet running Atlantis.  Atlantis persists Terraform [plan files](https://www.terraform.io/docs/commands/plan.html) and [lock files](https://www.terraform.io/docs/state/locking.html) to disk for the duration of a Pull/Merge Request.  These files are stored in a PersistentVolumeClaim to survive Pod failures.

## Prerequisites
-   Kubernetes 1.9+
-   PersistentVolume support

## Required Configuration
In order for Atlantis to start and run successfully:
1. At least one of the following sets of credentials must be defined:
    -  `github`
    -  `gitlab`
    -  `bitbucket`

    Refer to [values.yaml](values.yaml) for detailed examples.
    They can also be provided directly through a Kubernetes `Secret`, use the variable `vcsSecretName` to reference it.

1. Supply a value for `orgWhitelist`, e.g. `github.org/myorg/*`.

## Customization
The following options are supported.  See [values.yaml](values.yaml) for more detailed documentation and examples:

| Parameter                                   | Description                                                                                                                                                                                                                                                                                               | Default |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `dataStorage`                               | Amount of storage available for Atlantis' data directory (mostly used to check out git repositories).                                                                                                                                                                                                     | `5Gi`   |
| `aws.config`                                | Contents of a file to be mounted to `~/.aws/config`.                                                                                                                                                                                                                                                      | n/a     |
| `aws.credentials`                           | Contents of a file to be mounted to `~/.aws/credentials`.                                                                                                                                                                                                                                                 | n/a     |
| `awsSecretName`                           | Secret name containing AWS credentials - will override aws.credentials and aws.config. Will be used a volume mount on `$HOME/.aws`, so it needs a `credentials` key. The key `config` is optional. See the file `templates/secret-aws.yml` for more info on the Secret contents.                                                                                                                                     | n/a     |
| `bitbucket.user`                            | Name of the Atlantis Bitbucket user.                                                                                                                                                                                                                                                                      | n/a     |
| `bitbucket.token`                           | Personal access token for the Atlantis Bitbucket user.                                                                                                                                                                                                                                                    | n/a     |
| `bitbucket.secret`                          | Webhook secret for Bitbucket repositories (Bitbucket Server only).                                                                                                                                                                                                                                        | n/a     |
| `bitbucket.baseURL`                         | Base URL of Bitbucket Server installation.                                                                                                                                                                                                                                                                | n/a     |
| `environment`                               | Map of environment variables for the container.                                                                                                                                                                                                                                                           | `{}`    |
| `environmentSecrets`                         | Array of Kubernetes secrets that can be used to set environment variables. See `values.yaml` for example.                                                                                                                                                                                                                                                          | `{}`    |
| `imagePullSecrets`                          | List of secrets for pulling images from private registries.                                                                                                                                                                                                                                               | `[]`    |
| `gitconfig`                                 | Contents of a file to be mounted to `~/.gitconfig`.  Use to allow redirection for Terraform modules in private git repositories.                                                                                                                                                                          | n/a     |
| `command`                                   | Optionally override the [`command` field](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#container-v1-core) of the Atlantis Docker container. If not set, the default Atlantis `ENTRYPOINT` is used. Must be an array.                                                                                                                                  | n/a     |
| `github.user`                               | Name of the Atlantis GitHub user.                                                                                                                                                                                                                                                                         | n/a     |
| `github.token`                              | Personal access token for the Atlantis GitHub user.                                                                                                                                                                                                                                                       | n/a     |
| `github.secret`                             | Repository or organization-wide webhook secret for the Atlantis GitHub integration. All repositories in GitHub that are to be integrated with Atlantis must share the same value.                                                                                                                         | n/a     |
| `github.hostname`                           | Hostname of your GitHub Enterprise installation.                                                                                                                                                                                                                                                          | n/a     |
| `gitlab.user`                               | Repository or organization-wide secret for the Atlantis GitLab,integration. All repositories in GitLab that are to be integrated with Atlantis must share the same value.                                                                                                                                 | n/a     |
| `gitlab.token`                              | Personal access token for the Atlantis GitLab user.                                                                                                                                                                                                                                                       | n/a     |
| `gitlab.secret`                             | Webhook secret for the Atlantis GitLab integration. All repositories in GitLab that are to be integrated with Atlantis must share the same value.                                                                                                                                                         | n/a     |
| `gitlab.hostname`                           | Hostname of your GitLab Enterprise installation.                                                                                                                                                                                                                                                          | n/a     |
| `vcsSecretName` | Name of a pre-existing Kubernetes `Secret` containing `token` and `secret` keys set to your VCS provider's API token and webhook secret, respectively. Use this instead of `github.token`/`github.secret`, etc. (optional) | n/a |
| `podTemplate.annotations`                   | Additional annotations to use for the StatefulSet.                                                                                                                                                                                                                                                        | n/a     |
| `podTemplate.annotations`                   | Additional annotations to use for pods. | `{}` |
| `podTemplate.labels`                        | Additional labels to use for pods. | `{}` |
| `statefulSet.annotations`                   | Additional annotations to use for StatefulSet. | `{}` |
| `statefulSet.labels`                        | Additional labels to use for StatefulSet. | `{}` |
| `logLevel`                                  | Level to use for logging. Either debug, info, warn, or error.                                                                                                                                                                                                                                             | n/a     |
| `orgWhiteList`                              | Whitelist of repositories from which Atlantis will accept webhooks. **This value must be set for Atlantis to function correctly.** Accepts wildcard characters (`*`). Multiple values may be comma-separated.                                                                                             | none    |
| `config`                                | Override atlantis main configuration by config map. It's allow some additional functionality like slack notifications.                                                                                                                                                                                | n/a     |
| `repoConfig`                                | [Server Side Repo Configuration](https://www.runatlantis.io/docs/server-side-repo-config.html) as a raw YAML string. Configuration is stored in ConfigMap.                                                                                                                                                | n/a     |
| `defaultTFVersion`                          | Default Terraform version to be used by atlantis server                                                                                                                                                                                                                                                   | n/a     |
| `allowForkPRs`                              | Allow atlantis to run on fork Pull Requests                                                                                                                                                                                                                                                               | `false` |
| `disableApplyAll`                           | Disables running `atlantis apply` without any flags                                                                                                                                                                                                                                                       | `false` |
| `serviceAccount.create`                     | Whether to create a Kubernetes ServiceAccount if no account matching `serviceAccount.name` exists.                                                                                                                                                                                                        | `true`  |
| `serviceAccount.name`                       | Name of the Kubernetes ServiceAccount under which Atlantis should run. If no value is specified and `serviceAccount.create` is `true`, Atlantis will be run under a ServiceAccount whose name is the FullName of the Helm chart's instance, else Atlantis will be run under the `default` ServiceAccount. | n/a     |
| `serviceAccountSecrets.credentials`         | Deprecated (see googleServiceAccountSecrets) JSON string representing secrets for a Google Cloud Platform production service account. Only applicable if hosting Atlantis on GKE.                                                                                                                                                                      | n/a     |
| `serviceAccountSecrets.credentials-staging` | Deprecated (see googleServiceAccountSecrets) JSON string representing secrets for a Google Cloud Platform staging service account. Only applicable if hosting Atlantis on GKE.                                                                                                                                                                         | n/a     |
| `googleServiceAccountSecrets`               | An array of Kubernetes secrets containing Google Service Account credentials. See `values.yaml` for examples and additional documentation.                                                                                                                                                                | n/a     |
| `service.port`                              | Port of the `Service`.                                                                                                                                                                                                                                                                                    | `80`    |
| `service.loadBalancerSourceRanges`          | Array of whitelisted IP addresses for the Atlantis Service. If no value is specified, the Service will allow incoming traffic from all IP addresses (0.0.0.0/0).                                                                                                                                          | n/a     |
| `storageClassName`                          | Storage class of the volume mounted for the Atlantis data directory.                                                                                                                                                                                                                                      | n/a     |
| `tlsSecretName`                             | Name of a Secret for Atlantis' HTTPS certificate containing the following data items `tls.crt` with the public certificate and `tls.key` with the private key.                                                                                                                                            | n/a     |
| `ingress.enabled`                           | Whether to create a Kubernetes Ingress.                                                                                                                                                                                                                                                                   | `true`     |
| `ingress.annotations`                       | Additional annotations to use for the Ingress. | `{}` |
| `ingress.labels`                            | Additional labels to use for the Ingress. | `{}` |
| `ingress.path`                              | Path to use in the `Ingress`. Should be set to `/*` if using gce-ingress in Google Cloud.                                                                                                                                                                                                                 | `/`     |
| `ingress.host`                              | Domain name Kubernetes Ingress rule looks for. Set it to the domain Atlantis will be hosted on.                                                                                                                                                                                                           | `chart-example.local`     |
| `ingress.tls`                               | Kubernetes tls block. See [Kubernetes docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) for details.                                                                                                                                                                            | `[]`     |
| `test.enabled`                              | Whether to enable the test. | `true` |

**NOTE**: All the [Server Configurations](https://www.runatlantis.io/docs/server-configuration.html) are passed as [Environment Variables](https://www.runatlantis.io/docs/server-configuration.html#environment-variables).


## Upgrading
### From 2.* to 3.*
* The following value names have been removed. They are replaced by [Server Side Repo Configuration](https://www.runatlantis.io/docs/server-side-repo-config.html)
  * `requireApproval`
  * `requireMergeable`
  * `allowRepoConfig`

To replicate your previous configuration, run Atlantis locally with your previous flags and Atlantis will print out the equivalent repo-config, for example:

```
$ atlantis server --allow-repo-config --require-approval --require-mergeable --gh-user=foo --gh-token=bar --repo-whitelist='*'
WARNING: Flags --require-approval, --require-mergeable and --allow-repo-config have been deprecated.
Create a --repo-config file with the following config instead:

---
repos:
- id: /.*/
  apply_requirements: [approved, mergeable]
  allowed_overrides: [apply_requirements, workflow]
  allow_custom_workflows: true

or use --repo-config-json='{"repos":[{"id":"/.*/", "apply_requirements":["approved", "mergeable"], "allowed_overrides":["apply_requirements","workflow"], "allow_custom_workflows":true}]}'
```

Then use this YAML in the new repoConfig value:

```
repoConfig: |
  ---
  repos:
  - id: /.*/
    apply_requirements: [approved, mergeable]
    allowed_overrides: [apply_requirements, workflow]
    allow_custom_workflows: true
```

### From 1.* to 2.*
* The following value names have changed:
  * `allow_repo_config` => `allowRepoConfig`
  * `atlantis_data_storage` => `dataStorage` **NOTE: more than just a snake_case change**
  * `atlantis_data_storageClass` => `storageClassName` **NOTE: more than just a snake_case change**
  * `bitbucket.base_url` => `bitbucket.baseURL`

## Testing the Deployment
To perform a smoke test of the deployment (i.e. ensure that the Atlantis UI is up and running):

1. Install the chart.  Supply your own values file or use `test-values.yaml`, which has a minimal set of values required in order for Atlantis to start.

    ```bash
    helm install -f test-values.yaml --name my-atlantis stable/atlantis --debug
    ```

1. Run the tests:
    ```bash
    helm test my-atlantis
    ```
