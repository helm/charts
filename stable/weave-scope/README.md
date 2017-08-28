# Weave Scope

## About this chart

This chart contains two subcharts (*weave-scope-frontend* and *weave-scope-agent*, aliased as *frontend* and *agent* respectively) which deploy the corresponding components of Weave Scope, an interactive container monitoring and visualization application.

Either subchart can be deployed on its own or the two can be deployed together (the default).

## Prerequisites

* This chart is designed and tested with Weave Scope 1.6.2 and Kubernetes 1.7.
* Weave Scope 1.6.2 was actually released by WeaveWorks for Kubernetes 1.6 but seems to work fine on 1.7.
* On Kubernetes 1.6 Weave Scope versions as old as 1.3.0 will probably work.
* RBAC authorization must be enabled in the cluster (this is mostly an issue with kops-created clusters) and the service account, cluster role, cluster role binding and service specified in the rendered version of this chart must not already exist.

## Values templated in this chart

Note that most of this documentation is repeated in `values.yaml`; if you're in a hurry you can skip this part here and read it there.  Values with no default noted have no default.

### Global values

| Value | Default | Explanation |
|------:|:--------|:------------|
| **image** | "weaveworks/scope" | the image that will be used for this release |
| **imageTag** | 1.6.2 | the version of Weave Scope desired for this release |
| **service.name** | "weave-scope-app" | the short name desired for the frontend service -- this is a global so we can access its value easily from the agent subchart |
| **service.port** | 80 | the port exposed by the Scope frontend service -- this is a global so we can access its value easily from the agent subchart |
| **service.type** | "ClusterIP" | the frontend service type must be ClusterIP, NodePort or LoadBalancer -- this is a global to keep it with the other values for configuring the frontend service |

### Weave Scope frontend values

The **frontend** section controls how the Scope frontend is installed.

| Value | Default | Explanation |
|------:|:--------|:------------|
| **imagePullPolicy** | | controls when the image is pulled (**note** that the value for this in the official Weave Scope Kubernetes manifest is "IfNotPresent", but here it defaults to unset to conform to Helm conventions) |
| **containerPort** | 4040 | the port opened to the Scope frontend |
| **resources.*** | | controls requests/limits for the frontend (these values are all optional) |
| **resources.requests.cpu** | | CPU request in MHz (m) |
| **resources.requests.memory** | | memory request in MiB (Mi)| 
| **resources.limits.cpu** | | CPU limit in MHz (m) |
| **resources.limits.memory** | | memory limit in MiB (Mi) |

### Weave Scope agent

The **agent** section controls how the Weave Scope node agent pods are installed.

| Value | Default | Explanation |
|------:|:--------|:------------|
| **imagePullPolicy** | | controls when the image is pulled (**see note above** about the frontend pull policy; the same note applies here) |
| **probeToken** | | the token used to connect to Weave Cloud -- this is not needed for connecting to non-cloud Scope frontends |
| **serviceAccount** | "weave-scope" | the name of the service account to be created for the agent |
| **scopeFrontendAddr** | | the host:port of a Scope frontend to send data to -- this is only needed in cases where the frontend is deployed separately from the agent (e.g. an install outside the cluster or a pre-existing install inside it) |
| **dockerBridge** | "docker0" | the name of the Docker bridge interface |
| **resources.*** | | controls requests/limits for the agent (these values are all optional) |
| **resources.requests.cpu** | | CPU request in MHz (m) |
| **resources.requests.memory** | | memory request in MiB (Mi)|
| **resources.limits.cpu** | | CPU limit in MHz (m) |
| **resources.limits.memory** | | memory limit in MiB (Mi) |

## Other notes

* The Deployment for the frontend specifies a single replica; multiple replicas of the frontend, although they may run, probably will not work as expected since different agents may end up talking to different replicas.
