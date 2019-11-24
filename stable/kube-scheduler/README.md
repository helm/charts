# Helm Chart for Custom Kubernetes Scheduler

This helm chart is for deploying a custom scheduler into a kubernetes cluster.
The default scheduler favors an even distribution of pods across all nodes.
In some cases that is not the best way to schedule, e.g. in build clusters
or in clusters that work primarily on batch jobs that can not be interrupted
or moved to another machine on the fly.
When you do resource autoscaling in those scenarios, the default scheduler of
Kubernetes is not optimal and the need for custom scheduling arises. With e.g.
the MostRequestedPriority a custom scheduler tries to maximize resource
utilization on one node - such that the autoscaler is able to scale
down other nodes that are not blocked by non movable deployments/pods.

## TL;DR;

```console
$ helm install myScheduler ./
```

After installation the scheduler can be used as follows in a kubernetes
deployment object, assuming that the schedulerName was set to its default
value of `my-scheduler`:

```yaml
...
spec:
  schedulerName: my-scheduler
  ...
```

## Introduction

This helm chart is for installing one or more custom schedulers to
Kubernetes. Why should you do something like that? In cases, where you do
autoscaling of compute resources there are compute jobs, that Kubernetes is
not able to evict. E.g. Build Jobs, Test Runs or Batch Jobs. The default
scheduler of Kubernetes tries to achieve an even distribution of jobs over
all compute instances. In cases where you want to save compute instances that
may not be the optimal job distribution. Here comes this custom scheduler into
play. You can distribute those deployments with other priorities given by the 
standard `kube-scheduler` that can be customized using this helm chart.

## Prerequisites Details

None. You should have the need to do something like that, of course...

## Installing the Chart

The helm chart can be installed as follows. Assuming that the name
of the chart is `my-custom-scheduler`, you just install it using:

```console
$ helm install my-custom-scheduler ./
```

## Uninstalling the Chart

The helm chart can be removed simply by the obvious way. Assuming that the
name of the chart was `my-custom-scheduler`, you may remove the custom
scheduler using:

```console
$ helm uninstall my-custom-scheduler
```

## Configuration

The following table lists the configurable parameters of the Custom
Kubernetes Scheduler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`Values.image.repository` | Mandatory: The image to use | `k8s.gcr.io/kube-scheduler`
`Values.image.pullPolicy` | Mandatory: The image pull policy | `IfNotPresent`
`Values.replicaCount` | Mandatory: Number of replicas to deploy. More than one is for high availability scenarios. Check affinity and toleration settings for such use cases. | `1`
`Values.imagePullSecrets` | Optional: Image pull secrets | `[]`
`Values.labels` | Optional: Some custom labels for the scheduler | `{}`
`Values.schedulerName` | Mandatory: The name of the scheduler. | `my-scheduler`
`Values.predicates` | Mandatory: List of filters/predicates from [here](<https://kubernetes.io/docs/concepts/scheduling/kube-scheduler/>) | e.g. `[{"name":"PodFitsPorts"},{"name":"PodFitsResources"},{"name":"NoDiskConflict"},{"name":"MatchNodeSelector"},{"name":"HostName"}]`
`Values.priorities` | Mandatory: List of scoring/priorities and weights from [here](<https://kubernetes.io/docs/concepts/scheduling/kube-scheduler/>) | e.g. `[{"name":"MostRequestedPriority","weight":1},{"name":"EqualPriority","weight":1}]`
`Values.logging` | Optional: Enable verbose logging of kube-scheduler | `{}`
`Values.logging.verbosity`| Optional: Value between 0 and 10 (most logs) | `10`
`Values.serviceAccount.create` | Mandatory: Specifies whether a service account should be created or not. If rbac is enabled in your cluster, set this to true. | `true`
`Values.serviceAccount.name` | Optional: The name of the service account to use. If non is set and create is true, a name is generated using the fullname template | `sa_custom_scheduler`
`Values.podSecurityContext` | Optional: Pod security context settings, e.g. fsGroup, ... | `{}`
`Values.securityContext` | Optional: Security context settings, e.g. runAsUser, ... | `{}`
`Values.resources.requests.cpu` | Optional: CPU Request for one pod. Default setting is recommended at least. | `100m`
`Values.resources.requests.memory` | Optional: Memory Request for one pod. Default setting is recommended at least. | `128Mi`
`Values.resources.limits.cpu` | Optional: CPU Limit for one pod | ''
`Values.resources.limits.memory` | Optional: Memory Limit for one pod | ``
`Values.nodeSelector`| Optional: Node Selector specific settings | `{}`
`Values.tolerations` | Optional: Node Toleration specific settings. Check settings when doing HA. | `[]`
`Values.affinity` | Optional: Affinity specific settings. Check settings when doing HA. | `{}`

## Example Deployment using the Custom Scheduler

Assume that there is a custom scheduler deployed with the name
'my-scheduler'. The following example shows a pod that is 
scheduled using this scheduler:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: custom-scheduled-example-pod
spec:
  schedulerName: my-scheduler
  containers:
  - name: custom-scheduled-example-pod
    image: k8s.gcr.io/pause:2.0
```

## Scheduler testing

With the following command you are able to test the chart:

```console
$ make test
```

There are two tests for the chart:

- Check, if the scheduler has started and does its job using an example pod
- Check, that an (failing) example pod configured with a non existing scheduler
  stays pending and actually does not start (but installing of course this
  custom scheduler)

Both test are implemented stupidly in Makefile as bash-script... Helm Testing
seems not to be straight forward for this use case and this custom scheduler
is kind of an edge case, I guess.

## References

- Kubernetes example of running multiple schedulers: 
  <https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/>
- Kubernetes Scheduler policies and filters: 
  <https://kubernetes.io/docs/concepts/scheduling/kube-scheduler/>
- Kubernetes Scheduler command line reference: 
  <https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/>

## Author

Contact <stefan_j@gmx.de>
