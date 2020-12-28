# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# AWS IAM Authenticator

See https://github.com/kubernetes-sigs/aws-iam-authenticator

In particular, make sure that have configured your API server as in
https://github.com/kubernetes-sigs/aws-iam-authenticator#how-do-i-use-it. (This
chart only installs the DaemonSet and a ConfigMap.)

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Values

| Config                  | Description               | Default                                  |
| ------                  | -----------               | -------                                  |
| `image.repository`      | Image repo                | `gcr.io/heptio-images/authenticator`     |
| `image.tag`             | Image tag                 | `v0.1.0`                                 |
| `image.pullPolicy`      | Image pull policy         | `IfNotPresent`                           |
| `config`                | All the config, see below | `{}`                                     |
| `resources`             | Pod resources             | `{}`                                     |
| `hostPathConfig.output` | HostPath output           | `/srv/kubernetes/aws-iam-authenticator/` |
| `hostPathConfig.state`  | HostPath state            | `/srv/kubernetes/aws-iam-authenticator/` |

### Config

The value set for `config` is where all the action happens - this is
how you map AWS IAM roles to groups in the cluster. See the
aws-iam-authenticator docs for all of the possible options for this.

A simple example values file might look like:
```
config:
  clusterID: mycluster.io
  server:
    mapRoles:
    - groups:
      - developers  # the name of a group within Kubernetes
      roleARN: arn:aws:iam::000000000000:role/developer  # the ARN of a role in AWS
      username: developer
```
