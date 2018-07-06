# Kured (KUbernetes REboot Daemon)

See https://github.com/weaveworks/kured

| Config                    | Description                                                       | Default                    |
| ------                    | -----------                                                       | -------                    |
| `image.repository`        | Image repository                                                  | `quay.io/weaveworks/kured` |
| `image.tag`               | Image tag                                                         | `master-c42fff3`           |
| `image.pullPolicy`        | Image pull policy                                                 | `IfNotPresent`             |
| `extraArgs`               | Extra arguments to pass to `/usr/bin/kured`. See below.           | `{}`                       |
| `rbac.create`             | Create RBAC roles                                                 | `true`                     |
| `rbac.serviceAccountName` | Service account name to create (or use if `rbac.create` is false) | `kured`                    |
| `updateStrategy`          | Daemonset update strategy                                         | `OnDelete`                 |

See https://github.com/weaveworks/kured#configuration for values for `extraArgs`. Note that
```yaml
extraArgs:
  foo: 1
  bar-baz: 2
```
becomes `/usr/bin/kured ... --foo=1 --bar-baz=2`.
