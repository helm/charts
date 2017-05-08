# Hydra
[Hydra](https://github/ory/hdya) offers OAuth 2.0 and OpenID Connect Core 1.0 capabilities as a service. Hydra is different, because it works with any existing authentication infrastructure, not just LDAP or SAML. By implementing a consent app (works with any programming language) you build a bridge between Hydra and your authentication infrastructure.

Hydra is able to securely manage JSON Web Keys, and has a sophisticated policy-based access control you can use if you want to.

This chart comes bundled with an installation of Postgres.



# Prerequesites

* Kubernetes 1.4+ with Beta APIs enabled
* PV provisioner to support in the underlying infrastructure

# Install

To install the chart:

```
helm install --name=my-release-name stable/hydra
```

This will create a deployment, a secret, a service, and optionally a PersistentVolumeClaim, prefixed with `my-release-name`.

# Uninstall

```
helm delete my-release-name [--purge]
```

Adding the `--purge` flag will completely remove any trace of your release. (No values will be remembered.)

# Configuring


| Parameter                   | Description                                                                                                                | Default                        |
|-----------------------------|----------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| image                       | The path for pulling the docker image (without tag)                                                                        | `"oryd/hydra"`                 |
| imageTag                    | The version of the docker image to pull                                                                                    | `"0.7.10"`                     |
| imagePullPolicy             | When to pull the docker image                                                                                              | `"Always"`                     |
| replicas                    | How many replicas of Hydra to create                                                                                       | `2`                            |
| mountPath                   | Where in the container to mount the storage volume                                                                         | `"/root"`                      |
| persistence.enabled         | If false, then use `emptyDir: {}`, otherwise, issue a PVC                                                                  | `true`                         |
| persistence.accessMode      | [ReadWriteOnce/ReadOnlyMany/ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes-1) | `ReadWriteOnce`                |
| persistence.size            | How much storage to allocate to the volume                                                                                 | `1Gi`                          |
| postgresql.postgresPassword | The password of the Postgres User managing Hydra                                                                           | `hydra`                        |
| postgresql.persistence.size | How much storage to allocate to the postgres server behind Hydra                                                           | `1Gi`                          |
| config.system.secret        | The secret password for encrypting authorization tokens.  You should change this.                                          | `"changeme_changeme_changeme"` |
| config.consentUrl           | The URL for the consent app                                                                                                | `"https://consent.example.com"`|
| config.logLevel             | How detailed should the log output be                                                                                      | `"debug"`                      |
| accessTokenLifespan         | How long should an access token be valid for                                                                               | `"1h"`                         |
| idTokenLifespan             | How long should an id token be valid for                                                                                   | `"1h"`                         |
| authorizeCodeLifespan       | How long should an authorize code be valid for                                                                             | `"1h"`                         |

