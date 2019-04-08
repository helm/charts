<center><img src="https://github.com/Comcast/kuberhealthy/blob/master/images/kuberhealthy.png?raw=true"></center><br />

Easy synthetic testing for [Kubernetes](https://kubernetes.io) clusters.  Supplements other solutions like [Prometheus](https://prometheus.io/) nicely.

## What is Kuberhealthy?

Kuberhealthy performs stynthetic tests from within Kubernetes clusters in order to catch issues that would otherwise go unnoticed.  Instead of trying to identify all the things that could potentially go wrong, Kuberhealthy replicates real workflow and watches carefully for the expected Kubernetes behavior to occur.  Kuberhealthy serves both a JSON status page and a [Prometheus](https://prometheus.io/) metrics endpoint for integration into your choice of alerting solution.  More checks will be added in future versions to better cover [service provisioning](https://github.com/Comcast/kuberhealthy/issues/11), [DNS resolution](https://github.com/Comcast/kuberhealthy/issues/16), [disk provisioning](https://github.com/Comcast/kuberhealthy/issues/9), and more.

Some examples of errors Kuberhealthy has detected in production:

- Nodes where new pods get stuck in `Terminating` due to CNI communication failures
- Nodes where new pods get stuck in `ContainerCreating` due to disk scheduler errors
- Nodes where new pods get stuck in `Pending` due to Docker daemon errors
- Nodes where Docker or Kubelet crashes or has restarted
- A node that can not provision or terminate pods quickly enough due to high IO wait
- A pod in the `kube-system` namespace that is restarting too quickly
- A [Kubernetes component](https://kubernetes.io/docs/concepts/overview/components/) that is in a non-ready state
- Intermittent failures to access or create custom resources
- Kubernetes system services remaining technically "healthy" while their underlying pods are crashing too much
  - kube-scheduler
  - kube-apiserver
  - kube-dns


### Helm Variables

It is possible to configure Kuberhealthy's Prometheus integration with Helm variables.  Variable breakdown is below:

```
prometheus:
  enabled: true # do we deploy a ServiceMonitor spec?
  name: "prometheus" # the name of the Prometheus deployment in your environment.
  enableScraping: true # add the Prometheus scrape annotation to Kuberhealthy pods
  serviceMonitor: false # use a ServiceMonitor configuration, for if using Prometheus Operator
  enableAlerting: true # enable default Kuberhealthy alerts configuration
app:
  name: "kuberhealthy" # what to name the kuberhealthy deployment
image:
  repository: quay.io/comcast/kuberhealthy
  tag: v1.0.2
resources:
  requests:
    cpu: 100m
    memory: 80Mi
  limits:
    cpu: 400m
    memory: 200Mi
# Disable certain kuberhealthy checks by setting enabled to false
componentStatusCheck:
  enabled: true
daemonSetCheck:
  enabled: true
dnsStatusCheck:
  enabled: true
podRestartsCheck:
  enabled: true
podStatusCheck:
  enabled: true
tolerations:
  # change to true to tolerate and deploy to masters annotated with node-role.kubernetes.io/master
  master: true
deployment:
  replicas: 2 # any number of replicas are supported, but only act in a failover capacity
  maxSurge: 0
  maxUnavailable: 1
  imagePullPolicy: IfNotPresent
  namespace: kuberhealthy
  podAnnotations: {} # Annotations to be added to pods created by the deployment
  command:
  - /app/kuberhealthy
  # use this to override location of the test-image, see: https://github.com/Comcast/kuberhealthy/blob/master/docs/FLAGS.md
  # args:
  # - -dsPauseContainerImageOverride
  # - your-repo/google_containers/pause:0.8.0
securityContext: # default container security context
  runAsNonRoot: true
  runAsUser: 999
  fsGroup: 999
  allowPrivilegeEscalation: false
```

The following table lists the configurable parameters of the kuberhealthy chart and their default values.

| Config                        | Description                                                                 | Default                    |
| ------                        | -----------                                                                 | -------                    |
| `image.repository`            | Image repository                                                            | `quay.io/comcast/kuberhealthy` |
| `image.tag`                   | Image tag                                                                   | `v1.0.2`                   |
| `prometheus.enabled`          | Do we deploy a ServiceMonitor spec?                                         | `true`                     |
| `prometheus.name`             | The name of the Prometheus deployment in your environment.                  | `prometheus`               |
| `prometheus.enableScraping`   | Add the Prometheus scrape annotation to Kuberhealthy pods                   | `true`                     |
| `prometheus.serviceMonitor`   | Use a ServiceMonitor configuration, for if using Prometheus Operator        | `false`                    |
| `prometheus.enableAlerting`   | Enable default Kuberhealthy alerts configuration                            | `true`                     |
| `app.name`                    | What to name the kuberhealthy deployment                                    | `kuberhealthy`             |
| `resources.requests.cpu`      | Resource requests cpu                                                       | `100m`                     |
| `resources.requests.memory`   | Resource requests memory                                                    | `80Mi`                     |
| `resources.limits.cpu`        | Resource limits cpu                                                         | `400m`                     |
| `resources.limits.memory`     | Resource limits memeory                                                     | `200Mi`                    |
| `tolerations.master`          | Change to true to tolerate and deploy to masters annotated with node-role.kubernetes.io/master  | `true` |
| `deployment.replicas`         | Any number of replicas are supported, but only act in a failover capacity   | `2`                        |
| `deployment.maxSurge`         | Deployment max surge                                                        | `0`                        |
| `deployment.maxUnavailable`   | Deployment max unavailable                                                  | `1`                        |
| `deployment.imagePullPolicy`  | Deployment image pull policy                                                | `IfNotPresent`             |
| `deployment.namespace`        | Deployment namespace                                                        | `kuberhealthy`             |
| `deployment.podAnnotations`   | Annotations to be added to pods created by the deployment                   | `{}`                       |
| `deployment.command`          | Node Selector for the daemonset (ie, restrict which nodes kured runs on)    | `/app/kuberhealthy`        |
| `deployment.args`             | Use this to override location of the test-image, see: https://github.com/Comcast/kuberhealthy/blob/master/docs/FLAGS.md  | `-dsPauseContainerImageOverride, your-repo/google_containers/pause:0.8.0` |
| `securityContext.runAsNonRoot`| Default container security context: Run as non root?                        | `true`                     |
| `securityContext.runAsUser`   | Default container security context: Run as user                             | `999`                      |
| `securityContext.fsGroup`     | Default container security context: fs group                                | `999`                      |
| `securityContext.allowPrivilegeEscalation`  | Default container security context: Allow privilege escalation  | `false`                  |
| `componentStatusCheck.enabled`  | Enable component status check                                             | `true`                     |
| `daemonSetCheck.enabled`      | Enable daemon set check                                                     | `true`                     |
| `dnsStatusCheck.enabled`      | Enable DNS status check                                                     | `true`                     |
| `podRestartsCheck.enabled`    | Enable pod restarts check                                                   | `true`                     |
| `podStatusCheck.enabled`      | Enable pod status check                                                     | `true`                     |


For more details, see the [Kuberhealthy web site](https://comcast.github.io/kuberhealthy/).

To report a bug, see the [Kuberhealthy project issues](https://github.com/Comcast/kuberhealthy/issues).
