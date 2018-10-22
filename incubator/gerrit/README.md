# Gerrit

[Gerrit Code Review](https://www.gerritcodereview.com/) Gerrit is a web-based code review tool built on top of the Git 
version control system. Gerrit makes code review easy by providing a lightweight framework for reviewing commits before they are accepted by the codebase. Gerrit works equally well for projects where approving changes is restricted to selected users, as is typical for Open Source software development, as well as projects where all contributors are trusted.

## QuickStart

```bash
$ helm install stable/gerrit
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/gerrit
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The default configuration values for this chart are listed in `values.yaml`.

| Parameter                             | Description                                                  | Default                                           |
|---------------------------------------|-------------------------------------                         |---------------------------------------------------|
| `image.repository`                    | Repository for container image                               | docker.io/gerritcodereview/gerrit                               |
| `image.tag`                           | Container image tag                                          | 2.15.3                                           |
| `image.pullPolicy`                    | Image pull policy                                            | IfNotPresent                                      |
| `service.type`                        | Type for the service                                         | ClusterIP                                         |
| `service.ports.http.port`             | Service port for web interface                                       | 8080                                              |
| `service.ports.http.targetPort`       | Taret port for web interface service port                                      | 8080                                              |
| `service.ports.ssh.port`              | Service port for ssh connections                      | 29418                                              |
| `service.ports.ssh.targetPort`              | Target port for ssh service port                     | 29418                                              |
| `ingress.hosts`                             | List of host configs for ingress (required; see example below)             | []    |
| `ingress.tls`                             | List of ingress host tls configs (required; see example below)                                 | []     |
| `persistence.enabled`                  | Boolean indicating whether Gerrit pod should have persistent volumes                                  | true     |
| `persistence.volumes`                  | Volumes for various gerrit dirs and their sizes. Size is configurable; name is not. Only relevant if `persistence.enabled` is true.                                  | [{ name: git, size: 4Gi }, { name: etc, size: 4Gi }, { name: index, size: 4Gi }, { name: cache, size: 4Gi }]     |
| `postgres.postgresDatabase`                             | Name of postgres database used by Gerrit                                   | reviewdb     |
| `postgres.postgresUser`                             | User for connecting to postgres                                  | gerrit     |
| `postgres.postgresPassword`                             | Default asssword for connecting to postgres                                   | secret     |
| `config.auth.type`                             | Gerrit config auth type                                   | OpenID     |
| `config.index.type`                             | Gerrit config index type                                   | LUCENE     |
| `nodeSelector`                             | Node labels for pod assignment.                                   | {}     |

## Example Ingress & TLS configurations

In order to use the Gerrit web interface, you must have a domain name and TLS certificate configured. If you do not have a TLS cert for your domain name, you can get one for free through Let's Encrypt. The easiest way to do this on Kubernetes is to set up [cert-manager](https://github.com/jetstack/cert-manager), which will provision a certificate from Let's Encrypt and store it in a Kubernetes Secret that you can reference in your Gerrit chart's TLS config, which you should put in a YAML file that you pass to helm when you install the chart. For example, you could create a file called `myValues.yaml` with the following contents (substituting your own domain for example.com):

```yaml
ingress:
- path: /
  hosts:
  - gerrit.example.com
tls:
- hosts:
  - gerrit.example.com
  secretName: gerrit.example.com
```

This assumes that you have a domain that resolves to the cluster (for instance, to an ELB that forwards to your Ingress controller), as well as a valid TLS certificate for that domain stored in a secret called `gerrit.example.com`. You could then pass it to helm when you install the chart: `helm install -f myValues.yaml stable/gerrit`.
