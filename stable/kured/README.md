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
| `serviceAccount.create` | Create service account roles                                                | `true`                     |
| `serviceAccount.name`   | Service account name to create (or use if `serviceAccount.create` is false) | (chart fullname)           |
| `updateStrategy`        | Daemonset update strategy                                                   | `OnDelete`                 |
| `tolerations`           | Tolerations to apply to the daemonset (eg to allow running on master)       | `[{"key": "node-role.kubernetes.io/master", "effect": "NoSchedule"}]`|
| `nodeSelector`          | Node Selector for the daemonset (ie, restrict which nodes kured runs on)    | `{}`                       |
| `podAnnotations`        | Annotations to apply to pods (eg to add Prometheus annotations)             | `{}`                       |

See https://github.com/weaveworks/kured#configuration for values for `extraArgs`. Note that
```yaml
extraArgs:
  foo: 1
  bar-baz: 2
```
becomes `/usr/bin/kured ... --foo=1 --bar-baz=2`.
