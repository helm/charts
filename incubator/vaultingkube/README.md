# vaultingkube

[vaultingkube](https://github.com/sunshinekitty/vaultingkube) takes config maps
and secrets stored inside Hashicorp Vault and syncs them to your Kubernetes
cluster.

## TL;DR;

```console
$ helm install incubator/vaultingkube
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/vaultingkube
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the vaultingkube chart and their default values.

| Parameter               | Description                                                                                                                   | Default                                                 |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `replicaCount`          | Number of replicas of the vaultingkube pod                                                                                    | `1`                                                     |
| `images.repository`     | vaultingkube image repository                                                                                                 | `sunshinekitty/vaultingkube`                            |
| `images.tag`            | vaultingkube image tag                                                                                                        | `v0.1.0`                                                |
| `images.pullPolicy`     | vaultingkube image pull policy                                                                                                | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `vaultAddress`          | Address of the Vault that vaultingkube will query                                                                             | None. You *must* supply one.                            |
| `vaultToken`            | Token used by vaultingkube to query Vault                                                                                     | None. You *must* supply one.                            |
| `deleteOld`             | Enable deletion of K8s managed secrets that were deleted from Vault                                                           | `"true"`                                                |
| `syncPeriod`            | Frequency at which vaultingkube will check Vault new or removed secrets                                                       | `"60"`                                                  |
| `vaultRootMountPath`    | Secret path in Vault that vaultingkube will sync from                                                                         | None. You *must* supply one                             |
| `nodeSelector`          | Node labels for pod assignment                                                                                                | `{}`                                                    |
| `tolerations`           | List of node taints to tolerate                                                                                               | `[]`                                                    |
| `affinity`              | Affinity settings for pod assignment                                                                                          | `{}`                                                    |
| `rbac.create`           | If `true`, create and use RBAC resources                                                                                      | `true`                                                  |
| `serviceAccount.create` | If `true`, create a new service account                                                                                       | `true`                                                  |
| `serviceAccount.name`   | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | ``                                                      |
