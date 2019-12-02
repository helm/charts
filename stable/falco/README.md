# Sysdig Falco

[Sysdig Falco](https://falco.org) is a behavioral activity monitor designed to detect anomalous activity in your applications. You can use Falco to monitor run-time security of your Kubernetes applications and internal components.

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

> **Tip**: List all releases using `helm list`, a release is a name used to track a specific deployment

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
> **Tip**: Use helm delete --purge my-release to completely remove the release from Helm internal storage

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Falco chart and their default values.

| Parameter                                       | Description                                                                                                        | Default                                                                                                                                   |
| ---                                             | ---                                                                                                                | ---                                                                                                                                       |
| `image.registry`                                | The image registry to pull from                                                                                    | `docker.io`                                                                                                                               |
| `image.repository`                              | The image repository to pull from                                                                                  | `falcosecurity/falco`                                                                                                                     |
| `image.tag`                                     | The image tag to pull                                                                                              | `0.17.1`                                                                                                                                  |
| `image.pullPolicy`                              | The image pull policy                                                                                              | `IfNotPresent`                                                                                                                            |
| `cri.socket`                                    | The path of the CRI socket                                                                                         | `/run/containerd/containerd.sock`                                                                                                         |
| `docker.socket`                                 | The path of the Docker daemon socket                                                                               | `/var/run/docker.sock`                                                                                                                    |
| `resources.requests.cpu`                        | CPU requested for being run in a node                                                                              | `100m`                                                                                                                                    |
| `resources.requests.memory`                     | Memory requested for being run in a node                                                                           | `512Mi`                                                                                                                                   |
| `resources.limits.cpu`                          | CPU limit                                                                                                          | `200m`                                                                                                                                    |
| `resources.limits.memory`                       | Memory limit                                                                                                       | `1024Mi`                                                                                                                                  |
| `extraArgs`                                     | Specify additional container args                                                                                  | `[]`                                                                                                                                      |
| `rbac.create`                                   | If true, create & use RBAC resources                                                                               | `true`                                                                                                                                    |
| `serviceAccount.create`                         | Create serviceAccount                                                                                              | `true`                                                                                                                                    |
| `serviceAccount.name`                           | Use this value as serviceAccountName                                                                               | ` `                                                                                                                                       |
| `fakeEventGenerator.enabled`                    | Run falco-event-generator for sample events                                                                        | `false`                                                                                                                                   |
| `fakeEventGenerator.replicas`                   | How many replicas of falco-event-generator to run                                                                  | `1`                                                                                                                                       |
| `daemonset.updateStrategy.type`                 | The updateStrategy for updating the daemonset                                                                      | `RollingUpdate`                                                                                                                           |
| `daemonset.env`                                 | Extra environment variables passed to daemonset pods                                                               | `{}`                                                                                                                                      |
| `podSecurityPolicy.create`                      | If true, create & use podSecurityPolicy                                                                            | `false`                                                                                                                                   |
| `proxy.httpProxy`                               | Set the Proxy server if is behind a firewall                                                                       | ` `                                                                                                                                       |
| `proxy.httpsProxy`                              | Set the Proxy server if is behind a firewall                                                                       | ` `                                                                                                                                       |
| `proxy.noProxy`                                 | Set the Proxy server if is behind a firewall                                                                       | ` `                                                                                                                                       |
| `timezone`                                      | Set the daemonset's timezone                                                                                       | ` `                                                                                                                                       |
| `priorityClassName`                             | Set the daemonset's priorityClassName                                                                              | ` `                                                                                                                                       |
| `ebpf.enabled`                                  | Enable eBPF support for Falco instead of `falco-probe` kernel module                                               | `false`                                                                                                                                   |
| `ebpf.settings.hostNetwork`                     | Needed to enable eBPF JIT at runtime for performance reasons                                                       | `true`                                                                                                                                    |
| `ebpf.settings.mountEtcVolume`                  | Needed to detect which kernel version are running in Google COS                                                    | `true`                                                                                                                                    |
| `falco.rulesFile`                               | The location of the rules files                                                                                    | `[/etc/falco/falco_rules.yaml, /etc/falco/falco_rules.local.yaml, /etc/falco/rules.available/application_rules.yaml, /etc/falco/rules.d]` |
| `falco.timeFormatISO8601`                       | Display times using ISO 8601 instead of local time zone                                                            | `false`                                                                                                                                   |
| `falco.jsonOutput`                              | Output events in json or text                                                                                      | `false`                                                                                                                                   |
| `falco.jsonIncludeOutputProperty`               | Include output property in json output                                                                             | `true`                                                                                                                                    |
| `falco.logStderr`                               | Send Falco debugging information logs to stderr                                                                    | `true`                                                                                                                                    |
| `falco.logSyslog`                               | Send Falco debugging information logs to syslog                                                                    | `true`                                                                                                                                    |
| `falco.logLevel`                                | The minimum level of Falco debugging information to include in logs                                                | `info`                                                                                                                                    |
| `falco.priority`                                | The minimum rule priority level to load and run                                                                    | `debug`                                                                                                                                   |
| `falco.bufferedOutputs`                         | Use buffered outputs to channels                                                                                   | `false`                                                                                                                                   |
| `falco.syscallEventDrops.actions`               | Actions to be taken when system calls were dropped from the circular buffer                                        | `[log, alert]`                                                                                                                            |
| `falco.syscallEventDrops.rate`                  | Rate at which log/alert messages are emitted                                                                       | `.03333`                                                                                                                                  |
| `falco.syscallEventDrops.maxBurst`              | Max burst of messages emitted                                                                                      | `10`                                                                                                                                      |
| `falco.outputs.rate`                            | Number of tokens gained per second                                                                                 | `1`                                                                                                                                       |
| `falco.outputs.maxBurst`                        | Maximum number of tokens outstanding                                                                               | `1000`                                                                                                                                    |
| `falco.syslogOutput.enabled`                    | Enable syslog output for security notifications                                                                    | `true`                                                                                                                                    |
| `falco.fileOutput.enabled`                      | Enable file output for security notifications                                                                      | `false`                                                                                                                                   |
| `falco.fileOutput.keepAlive`                    | Open file once or every time a new notification arrives                                                            | `false`                                                                                                                                   |
| `falco.fileOutput.filename`                     | The filename for logging notifications                                                                             | `./events.txt`                                                                                                                            |
| `falco.stdoutOutput.enabled`                    | Enable stdout output for security notifications                                                                    | `true`                                                                                                                                    |
| `falco.webserver.enabled`                       | Enable Falco embedded webserver to accept K8s audit events                                                         | `false`                                                                                                                                   |
| `falco.webserver.listenPort`                    | Port where Falco embedded webserver listen to connections                                                          | `8765`                                                                                                                                    |
| `falco.webserver.k8sAuditEndpoint`              | Endpoint where Falco embedded webserver accepts K8s audit events                                                   | `/k8s-audit`                                                                                                                              |
| `falco.webserver.clusterIP`                     | ClusterIP address where Falco will listen to K8s audit events. If you enable the webserver, this field is required | ` `                                                                                                                                       |
| `falco.programOutput.enabled`                   | Enable program output for security notifications                                                                   | `false`                                                                                                                                   |
| `falco.programOutput.keepAlive`                 | Start the program once or re-spawn when a notification arrives                                                     | `false`                                                                                                                                   |
| `falco.programOutput.program`                   | Command to execute for program output                                                                              | `mail -s "Falco Notification" someone@example.com`                                                                                        |
| `falco.httpOutput.enabled`                      | Enable http output for security notifications                                                                      | `false`                                                                                                                                   |
| `falco.httpOutput.url`                          | Url to notify using the http output when a notification arrives                                                    | `http://some.url`                                                                                                                         |
| `customRules`                                   | Third party rules enabled for Falco                                                                                | `{}`                                                                                                                                      |
| `integrations.gcscc.enabled`                    | Enable Google Cloud Security Command Center integration                                                            | `false`                                                                                                                                   |
| `integrations.gcscc.webhookUrl`                 | The URL where sysdig-gcscc-connector webhook is listening                                                          | `http://sysdig-gcscc-connector.default.svc.cluster.local:8080/events`                                                                     |
| `integrations.gcscc.webhookAuthenticationToken` | Token used for authentication and webhook                                                                          | `b27511f86e911f20b9e0f9c8104b4ec4`                                                                                                        |
| `integrations.natsOutput.enabled`               | Enable NATS Output integration                                                                                     | `false`                                                                                                                                   |
| `integrations.natsOutput.natsUrl`               | The NATS' URL where Falco is going to publish security alerts                                                      | `nats://nats.nats-io.svc.cluster.local:4222`                                                                                              |
| `integrations.pubsubOutput.credentialsData`     | Contents retrieved from `cat $HOME/.config/gcloud/legacy_credentials/<email>/adc.json                              | jq -c .`                                                                                                                                  | ` ` |
| `integrations.pubsubOutput.enabled`             | Enable GCloud PubSub Output Integration                                                                            | `false`                                                                                                                                   |
| `integrations.pubsubOutput.projectID`           | GCloud Project ID where the Pub/Sub will be created                                                                | ` `                                                                                                                                       |
| `integrations.snsOutput.enabled`                | Enable Amazon SNS Output integration                                                                               | `false`                                                                                                                                   |
| `integrations.snsOutput.topic`                  | The SNS topic where Falco is going to publish security alerts                                                      | ` `                                                                                                                                       |
| `integrations.snsOutput.aws_access_key_id`      | The AWS Access Key Id credentials for access to SNS n                                                              | ` `                                                                                                                                       |
| `integrations.snsOutput.aws_secret_access_key`  | The AWS Secret Access Key credential to access to SNS                                                              | ` `                                                                                                                                       |
| `integrations.snsOutput.aws_default_region`     | The AWS region where SNS is deployed                                                                               | ` `                                                                                                                                       |
| `nodeSelector`                                  | The node selection constraint                                                                                      | ` `                                                                                                                                       |
| `tolerations`                                   | The tolerations for scheduling                                                                                     | `node-role.kubernetes.io/master:NoSchedule`                                                                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release --set falco.jsonOutput=true stable/falco
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/falco
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Loading custom rules

Falco ships with a nice default ruleset. Is a good starting point but sooner or later we are going to need to add custom rules which fits our needs.

A few days ago [we published several rules](https://github.com/draios/falco-extras) for well known container images.

So the question is: How we can load custom rules in our Falco deployment?

We are going to create a file which contains custom rules so that we can keep it in a Git repository.

```bash
$ cat custom-rules.yaml
```

And the file looks like this one:

```yaml
customRules:
  rules-traefik.yaml: |-
    - macro: traefik_consider_syscalls
      condition: (evt.num < 0)

    - macro: app_traefik
      condition: container and container.image startswith "traefik"

    # Restricting listening ports to selected set

    - list: traefik_allowed_inbound_ports_tcp
      items: [443, 80, 8080]

    - rule: Unexpected inbound tcp connection traefik
      desc: Detect inbound traffic to traefik using tcp on a port outside of expected set
      condition: inbound and evt.rawres >= 0 and not fd.sport in (traefik_allowed_inbound_ports_tcp) and app_traefik
      output: Inbound network connection to traefik on unexpected port (command=%proc.cmdline pid=%proc.pid connection=%fd.name sport=%fd.sport user=%user.name %container.info image=%container.image)
      priority: NOTICE

    # Restricting spawned processes to selected set

    - list: traefik_allowed_processes
      items: ["traefik"]

    - rule: Unexpected spawned process traefik
      desc: Detect a process started in a traefik container outside of an expected set
      condition: spawned_process and not proc.name in (traefik_allowed_processes) and app_traefik
      output: Unexpected process spawned in traefik container (command=%proc.cmdline pid=%proc.pid user=%user.name %container.info image=%container.image)
      priority: NOTICE
```

So next step is to use the custom-rules.yaml file for installing the Falco Helm chart.

```bash
$ helm install --name falco -f custom-rules.yaml stable/falco
```

And we will see in our logs something like:

```bash
Tue Jun  5 15:08:57 2018: Loading rules from file /etc/falco/rules.d/rules-traefik.yaml:
```

And this means that our Falco installation has loaded the rules and is ready to help us.

### Automating the generation of custom-rules.yaml file

Sometimes edit YAML files with multistrings is a bit error prone, so we added a script for automating this step and make your life easier.

This script lives in [falco-extras repository](https://github.com/draios/falco-extras) in the scripts directory.

Imagine that you would like to add rules for your Redis, MongoDB and Traefik containers, you have to:

```bash
$ git clone https://github.com/draios/falco-extras.git
$ cd falco-extras
$ ./scripts/rules2helm rules/rules-mongo.yaml rules/rules-redis.yaml rules/rules-traefik.yaml > custom-rules.yaml
$ helm install --name falco -f custom-rules.yaml stable/falco
```

And that's all, in a few seconds you will see your pods up and running with MongoDB, Redis and Traefik rules enabled.


## Enabling K8s audit event support

This has been tested with Kops and Minikube. You will need the following components:

* A Kubernetes cluster greater than v1.13
* The apiserver must be configured with Dynamic Auditing feature, do it with the following flags:
  * `--audit-dynamic-configuration`
  * `--feature-gates=DynamicAuditing=true`
  * `--runtime-config=auditregistration.k8s.io/v1alpha1=true`

You can do it with the [scripts provided by Falco engineers](https://github.com/falcosecurity/falco/tree/dev/examples/k8s_audit_config)
just running:

```
$ cd examples/k8s_audit_config
$ bash enable-k8s-audit.sh minikube dynamic
```

Or in the case of Kops:

```
$ cd examples/k8s_audit_config
$ APISERVER_HOST=api.my-kops-cluster.com bash ./enable-k8s-audit.sh kops dynamic
```

You also will need to [provide an internal clusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#choosing-your-own-ip-address)
where the service is going to be deployed. You need to choose an IPv4 or IPv6
address from within the `service-cluster-ip-range` CIDR range that is configured
for the apiserver.

Then you can install Falco chart enabling the enabling the `falco.webserver`
flag:

`helm install --name falco --set falco.webserver.enabled=true  --set falco.webserver.clusterIP=10.96.0.40 stable/falco`

And that's it, you will start to see the K8s audit log related alerts.

### Known validation failed error

Perhaps you may find the case where you receive an error like the following one:

```
$ helm install --name falco --set falco.webserver.enabled=true  --set falco.webserver.clusterIP=10.96.0.40 .
Error: validation failed: unable to recognize "": no matches for kind "AuditSink" in version "auditregistration.k8s.io/v1alpha1"
```

This means that the apiserver cannot recognize the `auditregistration.k8s.io`
resource, which means that the dynamic auditing feature hasn't been enabled
properly. You need to enable it or ensure that your using a Kubernetes version
greater than v1.13.
