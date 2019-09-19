# Kured (KUbernetes REboot Daemon)

See https://github.com/weaveworks/kured

| Config                  | Description                                                                 | Default                    |
| ------                  | -----------                                                                 | -------                    |
| `image.repository`      | Image repository                                                            | `weaveworks/kured` |
| `image.tag`             | Image tag                                                                   | `1.2.0`                    |
| `image.pullPolicy`      | Image pull policy                                                           | `IfNotPresent`             |
| `image.pullSecrets`     | Image pull secrets                                                          | `[]`                       |
| `extraArgs`             | Extra arguments to pass to `/usr/bin/kured`. See below.                     | `{}`                       |
| `rbac.create`           | Create RBAC roles                                                           | `true`                     |
| `podSecurityPolicy.create` | Create podSecurityPolicy                                                 | `false`                     |
| `serviceAccount.create` | Create service account roles                                                | `true`                     |
| `serviceAccount.name`   | Service account name to create (or use if `serviceAccount.create` is false) | (chart fullname)           |
| `updateStrategy`        | Daemonset update strategy                                                   | `OnDelete`                 |
| `tolerations`           | Tolerations to apply to the daemonset (eg to allow running on master)       | `[{"key": "node-role.kubernetes.io/master", "effect": "NoSchedule"}]`|
| `nodeSelector`          | Node Selector for the daemonset (ie, restrict which nodes kured runs on)    | `{}`                       |
| `priorityClassName`     | Priority Class to be used by the pods                                       | `""`                       |
| `podAnnotations`        | Annotations to apply to pods (eg to add Prometheus annotations)             | `{}`                       |
| `autolock.enabled`      | Activate autolock to define when to allow kured to be executed                                                        | `false` |
| `autolock.image.repository`      | Image repository for kubectl command                                                         | `honestica/k8s-tools` |
| `autolock.image.tag`             | Image tag                                                                   | `1c80a6579bdb73059d72101c9f82f26291954d68`                    |
| `autolock.scheduleUnlock`      | Cron schedule to unlock kured                                                      | `0 4 * * *` |
| `autolock.schedulelock`      | Cron schedule to lock kured                                                      | `0 6 * * *` |

See https://github.com/weaveworks/kured#configuration for values for `extraArgs`. Note that
```yaml
extraArgs:
  foo: 1
  bar-baz: 2
```
becomes `/usr/bin/kured ... --foo=1 --bar-baz=2`.
