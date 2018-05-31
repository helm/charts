# Sysdig Falco

[Sysdig Falco](https://www.sysdig.com/opensource/falco/) is a behavioral activity monitor designed to detect anomalous activity in your applications. You can use Falco to monitor run-time security of your Kubernetes applications and internal components.

To know more about Sysdig Falco have a look at:

- [Kubernetes security logging with Falco & Fluentd
](https://sysdig.com/blog/kubernetes-security-logging-fluentd-falco/)
- [Active Kubernetes security with Sysdig Falco, NATS, and kubeless](https://sysdig.com/blog/active-kubernetes-security-falco-nats-kubeless/)
- [Detecting cryptojacking with Sysdig’s Falco
](https://sysdig.com/blog/detecting-cryptojacking-with-sysdigs-falco/)

## Introduction

This chart adds Falco to all nodes in your cluster using a DaemonSet.

Also provides a Deployment for generating Falco alerts. This is useful for testing purposes.

## Installing the Chart

To install the chart with the release name `my-release` run:

```bash
$ helm install --name my-release stable/falco
```

After a few seconds, Falco should be running.

> **Tip**: List all releases using `helm list`, a release is a name used to track an specific deployment

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
> **Tip**: Use helm delete --purge my-release to completely remove the release from Helm internal storage

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Falco chart and their default values.

| Parameter                                           | Description                                                         | Default                                                                                |
| ---                                                 | ---                                                                 | ---                                                                                    |
| `image.repository`                                  | The image repository to pull from                                   | `sysdig/falco`                                                                         |
| `image.tag`                                         | The image tag to pull                                               | `latest`                                                                               |
| `image.pullPolicy`                                  | The image pull policy                                               | `Always`                                                                               |
| `rbac.create`                                       | If true, create & use RBAC resources                                | `true`                                                                                 |
| `rbac.serviceAccountName`                           | If rbac.create is false, use this value as serviceAccountName       | `default`                                                                              |
| `deployment.enabled`                                | Run falco-event-generator for sample events                         | `false`                                                                                |
| `deployment.replicas`                               | How many replicas of falco-event-generator to run                   | `1`                                                                                    |
| `falco.rulesFile`                                   | The location of the rules files                                     | `[/etc/falco/falco_rules.yaml, /etc/falco/falco_rules.local.yaml, /etc/falco/rules.d]` |
| `falco.jsonOutput`                                  | Output events in json or text                                       | `false`                                                                                |
| `falco.jsonIncludeOutputProperty`                   | Include output property in json output                              | `true`                                                                                 |
| `falco.logStderr`                                   | Send Falco debugging information logs to stderr                     | `true`                                                                                 |
| `falco.logSyslog`                                   | Send Falco debugging information logs to syslog                     | `true`                                                                                 |
| `falco.logLevel`                                    | The minimum level of Falco debugging information to include in logs | `info`                                                                                 |
| `falco.priority`                                    | The minimum rule priority level to load an run                      | `debug`                                                                                |
| `falco.bufferedOutputs`                             | Use buffered outputs to channels                                    | `false`                                                                                |
| `falco.outputs.rate`                                | Number of tokens gained per second                                  | `1`                                                                                    |
| `falco.outputs.maxBurst`                            | Maximum number of tokens outstanding                                | `1000`                                                                                 |
| `falco.syslogOutput.enabled`                        | Enable syslog output for security notifications                     | `true`                                                                                 |
| `falco.fileOutput.enabled`                          | Enable file output for security notifications                       | `false`                                                                                |
| `falco.fileOutput.keepAlive`                        | Open file once or every time a new notification arrives             | `false`                                                                                |
| `falco.fileOutput.filename`                         | The filename for logging notifications                              | `./events.txt`                                                                         |
| `falco.stdoutOutput.enabled`                        | Enable stdout output for security notifications                     | `true`                                                                                 |
| `falco.programOutput.enabled`                       | Enable program output for security notifications                    | `false`                                                                                |
| `falco.programOutput.keepAlive`                     | Start the program once or re-spawn when a notification arrives      | `false`                                                                                |
| `falco.programOutput.program`                       | Command to execute for program output                               | `mail -s "Falco Notification" someone@example.com`                                     |
| `falco.gcsccIntegration.enabled`                    | Enable Google Cloud Security Command Center integration             | `false`                                                                                |
| `falco.gcsccIntegration.webhookUrl`                 | The URL where sysdig-gcscc-connector webhook is listening           | `http://sysdig-gcscc-connector.default.svc.cluster.local:8080/events`                  |
| `falco.gcsccIntegration.webhookAuthenticationToken` | Token used for authentication and webhook                           | `b27511f86e911f20b9e0f9c8104b4ec4`                                                     |
| `tolerations`                                       | The tolerations for scheduling                                      | `node-role.kubernetes.io/master:NoSchedule`                                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release --set falco.jsonOutput=true stable/falco
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/falco
```

> **Tip**: You can use the default [values.yaml](values.yaml)
