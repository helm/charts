# kubernetes-tagger

[kubernetes-tagger](https://github.com/oxyno-zeta/kubernetes-tagger) is a Kubernetes watcher that will tag external resources like EBS following rules.

## TL;DR;

```console
$ helm install incubator/kubernetes-tagger
```

## Introduction

This chart bootstraps a kubernetes-tagger deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/kubernetes-tagger --name my-release
```

The command deploys kubernetes-tagger on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kubernetes-tagger chart and their default values.

| Parameter                                          | Description                                                                                                                                                | Default                                                                                                                |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `rbac.create`                                      | If true, create & use RBAC resources                                                                                                                       | `false`                                                                                                                |
| `rbac.serviceAccountName`                          | Existing ServiceAccount to use (ignored if rbac.create=true)                                                                                               | `default`                                                                                                              |
| `secrets.aws.accessKey`                            | Will create AWS Access Key in secrets                                                                                                                      | Empty                                                                                                                  |
| `secrets.aws.secretKey`                            | Will create AWS Secret Access Key in secrets                                                                                                               | Empty                                                                                                                  |
| `config`                                           | Kubernetes-tagger configuration (You can see more about this [here](https://github.com/oxyno-zeta/kubernetes-tagger))                                      | Configuration                                                                                                          |
| `replicaCount`                                     | Desired number of pods                                                                                                                                     | `1`                                                                                                                    |
| `image.name`                                       | Container image name (Including repository name if not `hub.docker.com`).                                                                                  | `oxynozeta/kubernetes-tagger`                                                                                          |
| `image.pullPolicy`                                 | Container pull policy.                                                                                                                                     | `IfNotPresent`                                                                                                         |
| `image.tag`                                        | Container image tag.                                                                                                                                       | `1.0.1`                                                                                                                |
| `service.annotations`                              | Annotations to add to service                                                                                                                              | `{}`                                                                                                                   |
| `service.clusterIP`                                | IP address to assign to service                                                                                                                            | `""`                                                                                                                   |
| `service.externalIPs`                              | Service external IP addresses                                                                                                                              | `[]`                                                                                                                   |
| `service.loadBalancerIP`                           | IP address to assign to load balancer (if supported)                                                                                                       | `""`                                                                                                                   |
| `service.loadBalancerSourceRanges`                 | List of IP CIDRs allowed access to load balancer (if supported)                                                                                            | `[]`                                                                                                                   |
| `service.servicePort`                              | Service port to expose                                                                                                                                     | `80`                                                                                                                   |
| `service.type`                                     | Type of service to create                                                                                                                                  | `ClusterIP`                                                                                                            |
| `ingress.enabled`                                  | Enables Ingress                                                                                                                                            | `false`                                                                                                                |
| `ingress.annotations`                              | Ingress annotations                                                                                                                                        | `{}`                                                                                                                   |
| `ingress.path`                                     | Ingress path                                                                                                                                               | `/`                                                                                                                    |
| `ingress.hosts`                                    | Ingress accepted hostnames                                                                                                                                 | `[]`                                                                                                                   |
| `ingress.tls`                                      | Ingress TLS configuration                                                                                                                                  | `[]`                                                                                                                   |
| `resources`                                        | CPU/Memory resource requests/limits.                                                                                                                       | `{}`                                                                                                                   |
| `nodeSelector`                                     | Node labels for pod assignment                                                                                                                             | `{}`                                                                                                                   |
| `tolerations`                                      | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                                               | `[]`                                                                                                                   |
| `affinity`                                         | List of affinities (requires Kubernetes >=1.6)                                                                                                             | `{}`                                                                                                                   |
| `deploymentAnnotations`                            | Deployment annotations                                                                                                                                     | `{}`                                                                                                                   |
| `podAnnotations`                                   | Additional annotations to apply to the pod.                                                                                                                | `{}`                                                                                                                   |
| `podLabels`                                        | Additional labels to apply to the pod.                                                                                                                     | `{}`                                                                                                                   |
| `podDisruptionBudget.enabled`                      | If true, create a pod disruption budget for prometheus pods. The created resource cannot be modified once created - it must be deleted to perform a change | `false`                                                                                                                |
| `podDisruptionBudget.minAvailable`                 | Minimum number / percentage of pods that should remain scheduled                                                                                           | `1`                                                                                                                    |
| `podDisruptionBudget.maxUnavailable`               | Maximum number / percentage of pods that may be made unavailable                                                                                           | `""`                                                                                                                   |
| `livenessProbe`                                    | Liveness Probe settings                                                                                                                                    | `{ "initialDelaySeconds": 0, "periodSeconds": 30, "timeoutSeconds": 1, "successThreshold": 1, "failureThreshold": 3 }` |
| `readinessProbe`                                   | Readiness Probe settings                                                                                                                                   | `{ "initialDelaySeconds": 0, "periodSeconds": 30, "timeoutSeconds": 1, "successThreshold": 1, "failureThreshold": 3 }` |
| `prometheus.pod.enabled`                           | If `true`, annotate with Prometheus annotations pods                                                                                                       | `false`                                                                                                                |
| `prometheus.operator.enabled`                      | If `true`, creates a Prometheus Operator ServiceMonitor                                                                                                    | `false`                                                                                                                |
| `prometheus.operator.serviceMonitor.namespace`     | Namespace which Prometheus is running in                                                                                                                   | `monitoring`                                                                                                           |
| `prometheus.operator.serviceMonitor.interval`      | Interval that Prometheus scrapes metrics                                                                                                                   | `20s`                                                                                                                  |
| `prometheus.operator.serviceMonitor.scrapeTimeout` | Scrape timeout for Prometheus scrape metrics                                                                                                               | None                                                                                                                   |
| `prometheus.operator.serviceMonitor.selector`      | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                 | `{ prometheus: kube-prometheus }`                                                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/kubernetes-tagger --name my-release \
  --set=secrets.aws.accessKey="XXXXXXX",secrets.aws.secretKey="XXXXXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/kubernetes-tagger --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
