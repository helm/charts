# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# eventrouter

[eventrouter](https://github.com/heptiolabs/eventrouter) simple introspective kubernetes service that forwards events to a specified sink.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Installation

```console
$ helm install stable/eventrouter --name my-release
NAME: k8s-eventrouter
LAST DEPLOYED: Fri Feb 28 14:57:53 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
eventrouter has been installed!
```

## Configuration

The following table lists the configurable parameters of the eventrouter chart and their default values.

|        Parameter        |                                                         Description                                                         |              Default               |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `image.repository`      | Container image name                                                                                                        | `gcr.io/heptio-images/eventrouter` |
| `image.tag`             | Container image tag                                                                                                         | `v0.3`                             |
| `rbac.create`           | If `true`, create and use RBAC resources                                                                                    | `true`                             |
| `serviceAccount.name`   | Service account to be used. If not set and serviceAccount.create is `true`, a name is generated using the fullname template | ``                                 |
| `serviceAccount.create` | If true, create a new service account                                                                                       | `true`                             |
| `tolerations`           | List of node taints to tolerate                                                                                             | `[]`                               |
| `nodeSelector`          | Node labels for pod assignment                                                                                              | `{}`                               |
| `sink`                  | Sink to send the events to                                                                                                  | `glog`                             |
| `podAnnotations`        | Annotations for pod metadata                                                                                                | `{}`                               |
| `containerPorts`        | List of ports for the container                                                                                             | `[]`                               |
| `securityContext`       | Security context for the pod                                                                                                | `{}`                               |
| `enablePrometheus`      | Enable prometheus                                                                                                           | `true                              |
