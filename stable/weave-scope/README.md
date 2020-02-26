# Weave Scope

## About this chart

This chart contains two subcharts (*weave-scope-frontend* and *weave-scope-agent*) which deploy the corresponding components of Weave Scope, an interactive container monitoring and visualization application.

Either subchart can be deployed on its own (set the "enabled" value to "false" for the chart you want to suppress) or the two can be deployed together (the default).

## Compatibility notes

* This chart is designed and tested with Weave Scope 1.6.2 and 1.6.5 and Kubernetes 1.7.
* Weave Scope 1.6.2 was originally released by WeaveWorks for Kubernetes 1.6 but seems to work fine on 1.7.
* On Kubernetes 1.6 Weave Scope versions as old as 1.3.0 will probably work.

## Prerequisites

* The service account, cluster role, cluster role binding and service specified in the rendered version of this chart must not already exist.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/weave-scope
```

The command deploys Weave Scope on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

Note that most of this documentation is repeated in `values.yaml`; if you're in a hurry you can skip this part here and read it there.  Values with no default noted have no default.

### Global values

| Parameter | Description | Default |
|----------:|:------------|:--------|
| **image.*** | the parameters of the image pulls for this release | |
| **image.repository** | the image that will be used for this release (required) | `weaveworks/scope` |
| **image.tag** | the version of Weave Scope desired for this release (required) | `1.11.3`
| **image.pullPolicy** | the imagePullPolicy for the container (required): IfNotPresent, Always, or Never | `IfNotPresent`
| **service.*** | the configuration of the service used to access the frontend | |
| **service.name** | the short name desired for the frontend service (optional, but if not specified by the user a value will be calculated) -- this is a global so we can access its value easily from the agent subchart | `weave-scope-app` |
| **service.port** | the port exposed by the Scope frontend service (required if weave-scope-frontend is enabled) -- this is a global so we can access its value easily from the agent subchart | `80` |
| **service.type** | the type of the frontend service (required if weave-scope-frontend is enabled): ClusterIP, NodePort or LoadBalancer -- this is a global to keep it with the other values for configuring the frontend service | `ClusterIP` |


### Weave Scope frontend values

The **weave-scope-frontend** section controls how the Scope frontend is installed.

| Parameter | Description | Default |
|----------:|:------------|:--------|
| **enabled** | controls whether the frontend is deployed | `true` |
| **flags** | adds extra flag options for container | [] |
| **resources.*** | controls requests/limits for the frontend (these values are all optional) | |
| **resources.requests.cpu** | CPU request in MHz (m) | |
| **resources.requests.memory** | memory request in MiB (Mi) | |
| **resources.limits.cpu** | CPU limit in MHz (m) | |
| **resources.limits.memory** | memory limit in MiB (Mi) | |
| **ingress.enabled** | Enables Ingress for weave-scope-frontend | false |
| **ingress.annotations** |	Ingress annotations | {} |
| **ingress.paths** |	Ingress paths | [] |
| **ingress.hosts** | Ingress accepted hostnames | nil |
| **ingress.tls** |	Ingress TLS configuration |	[] |

### Weave Scope agent

The **agent** section controls how the Weave Scope node agent pods are installed.

| Parameter | Description | Default |
|----------:|:------------|:--------|
| **enabled** | controls whether the agent is deployed | `true` |
| **flags** | adds extra flag options for container | [] |
| **dockerBridge** | the name of the Docker bridge interface | `docker0` |
| **scopeFrontendAddr** | the host:port of a Scope frontend to send data to -- this is only needed in cases where the frontend is deployed separately from the agent (e.g. an install outside the cluster or a pre-existing install inside it) | |
| **probeToken** | the token used to connect to Weave Cloud -- this is not needed for connecting to non-cloud Scope frontends | |
| **priorityClassName** | The priorityClassName used for the Daemonset | |
| **readOnly** | disables all controls (e.g. start/stop, terminal, logs, etc.) | `false` |
| **resources.*** | controls requests/limits for the agent (these values are all optional) | |
| **resources.requests.cpu** | CPU request in MHz (m) | |
| **resources.requests.memory** | memory request in MiB (Mi)| |
| **resources.limits.cpu** | CPU limit in MHz (m) | |
| **resources.limits.memory** | memory limit in MiB (Mi) | |

### Weave Scope cluster agent

The **agent** section controls how the Weave Scope node agent pods are installed.

| Parameter | Description | Default |
|----------:|:------------|:--------|
| **enabled** | controls whether the agent is deployed | `true` |
| **flags** | adds extra flag options for container | [] |
| **scopeFrontendAddr** | the host:port of a Scope frontend to send data to -- this is only needed in cases where the frontend is deployed separately from the agent (e.g. an install outside the cluster or a pre-existing install inside it) | |
| **probeToken** | the token used to connect to Weave Cloud -- this is not needed for connecting to non-cloud Scope frontends | |
| **rbac.*** | controls RBAC resource creation/use | |
| **rbac.create** | whether RBAC resources should be created (required) -- this **must** be set to false if RBAC is not enabled in the cluster; it *may* be set to false in an RBAC-enabled cluster to allow for external management of RBAC | `true` |
| **readOnly** | disables all controls (e.g. start/stop, terminal, logs, etc.) | `false` |
| **serviceAccount.create** | whether a new service account name that the agent will use should be created. | `true` |
| **serviceAccount.name** | service account to be used.  If not set and serviceAccount.create is `true` a name is generated using the fullname template. |  |
| **resources.*** | controls requests/limits for the agent (these values are all optional) | |
| **resources.requests.cpu** | CPU request in MHz (m) | |
| **resources.requests.memory** | memory request in MiB (Mi)| |
| **resources.limits.cpu** | CPU limit in MHz (m) | |
| **resources.limits.memory** | memory limit in MiB (Mi) | |

## Other notes

* The Deployment for the frontend specifies a single replica; multiple replicas of the frontend, although they may run, probably will not work as expected since different agents may end up talking to different replicas.
