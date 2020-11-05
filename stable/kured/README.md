# Kured (KUbernetes REboot Daemon)

See https://github.com/weaveworks/kured

## Deprecation

This chart is deprecated! It has been moved to the kured repository.
See https://github.com/weaveworks/kured/tree/master/charts/kured for details.


## Autolock feature

This feature is not natively supported by kured but is added using Kubernetes Cronjob to annotate daemonset when to allow kured to run using the lock configuration annotation https://github.com/weaveworks/kured#overriding-lock-configuration


| Config                  | Description                                                                 | Default                    |
| ------                  | -----------                                                                 | -------                    |
| `image.repository`      | Image repository                                                            | `weaveworks/kured` |
| `image.tag`             | Image tag                                                                   | `1.4.0`                    |
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
| `autolock.image.repository`      | Image repository for kubectl command                                                         | `docker.io/bitnami/kubectl` |
| `autolock.image.tag`             | Image tag                                                                   | `1.17.5`                    |
| `autolock.scheduleUnlock`      | CronJob schedule to unlock kured                                                      | `0 4 * * *` |
| `autolock.schedulelock`      | CronJob schedule to lock kured                                                      | `0 6 * * *` |

See https://github.com/weaveworks/kured#configuration for values for `extraArgs`. Note that
```yaml
extraArgs:
  foo: 1
  bar-baz: 2
```
becomes `/usr/bin/kured ... --foo=1 --bar-baz=2`.

## Prometheus Metrics

Kured exposes a single prometheus metric indicating whether a reboot is required or not (see [kured docs](https://github.com/weaveworks/kured#prometheus-metrics)) for details. It can be scraped with the following set of annotations:

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: "/metrics"
  prometheus.io/port: "8080"
```
