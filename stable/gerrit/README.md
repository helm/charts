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
| `ingress.hosts`                             | List of host configs for ingress                                   | []     |
| `ingress.tls`                             | List of ingress host tls configs                                  | []     |
| `persistence.enabled`                  | Boolean indicating whether Gerrit pod should have persistent volumes                                  | true     |
| `persistence.volumes`                  | Volumes for various gerrit dirs and their sizes. Size is configurable; name is not. Only relevant if `persistence.enabled` is true.                                  | [{ name: git, size: 4Gi }, { name: etc, size: 4Gi }, { name: index, size: 4Gi }, { name: cache, size: 4Gi }]     |
| `postgres.postgresDatabase`                             | Name of postgres database used by Gerrit                                   | reviewdb     |
| `postgres.postgresUser`                             | User for connecting to postgres                                  | gerrit     |
| `postgres.postgresPassword`                             | Default asssword for connecting to postgres                                   | secret     |
| `config.auth.type`                             | Gerrit config auth type                                   | OpenID     |
| `config.index.type`                             | Gerrit config index type                                   | LUCENE     |
| `nodeSelector`                             | Node labels for pod assignment.                                   | {}     |
