# Weave Scope

## About this chart

This chart contains two subcharts (weave-scope-frontend and weave-scope-agent) which deploy the corresponding components of Weave Scope, an interactive container monitoring and visualization application.

Either subchart can be deployed on its own or the two can be deployed together (the default).

## Prerequisites

* This chart is designed and tested with Weave Scope 1.6.1 and Kubernetes 1.7.
* Weave Scope 1.6.1 was actually released by WeaveWorks for Kubernetes 1.6 but seems to work fine on 1.7.
* On Kubernetes 1.6 Weave Scope versions as old as 1.3.0 will probably work.
* The service account, cluster role, cluster role binding and service specified in the rendered version of this chart must not already exist.

## Values templated in this chart

Note that most of this documentation is repeated in `values.yaml`; if you're in a hurry you can skip this part here and read it there.  Values with no default noted have no default.

### Global values

**global.image**: the image that will be used for this release (default: "weaveworks/scope")

**global.imageTag**: the version of Weave Scope desired for this release (default: "1.6.1")

**global.clusterDomain**: the domain used for the Kubernetes cluster (default: "cluster.local")

**global.service.name**: the short name desired for the frontend service -- this is a global so we can access its value easily from the weave-scope-agent subchart (default: "weave-scope-app")

**global.service.port**: the port exposed by the Scope frontend service -- this is a global so we can access its value easily from the weave-scope-agent subchart (default: 80)

**global.service.type**: the frontend service type must be ClusterIP, NodePort or LoadBalancer -- this is a global to keep it with the other values for configuring the frontend service (default: "ClusterIP")

### Weave Scope frontend

The **weave-scope-frontend** section controls how the Scope frontend is installed.

**weave-scope-frontend.imagePullPolicy**: controls when the image is pulled
* Note that the value for this in the official Weave Scope Kubernetes manifest is "IfNotPresent", but here it defaults to unset to conform to Helm conventions.

**weave-scope-frontend.containerPort**: the port opened to the Scope frontend (default: 4040)

**weave-scope-frontend.resources.***: controls requests/limits for the frontend -- these values are all optional.

* **weave-scope-frontend.resources.requests.cpu**: CPU request in MHz (m)
* **weave-scope-frontend.resources.requests.memory**: memory request in MiB (Mi)
* **weave-scope-frontend.resources.limits.cpu**: CPU limit in MHz (m)
* **weave-scope-frontend.resources.limits.memory**: memory limit in MiB (Mi)

### Weave Scope agent

The **weave-scope-agent** section controls how the Weave Scope node agent pods are installed.

**weave-scope-agent.imagePullPolicy**: controls when the image is pulled
* See note above about the frontend pull policy; the same note applies here.

**weave-scope-agent.probeToken** is the token used to connect to Weave Cloud -- this is not needed for connecting to non-cloud Scope frontends

**weave-scope-agent.serviceAccount**: the name of the service account to be created for the agent (default: "weave-scope")

**weave-scope-agent.scopeFrontendAddr**: the host:port of a Scope frontend to send data to -- this is only needed for some cases where the frontend is deployed separately from the agent (e.g. an install outside the cluster or a pre-existing install inside it)

**weave-scope-agent.dockerBridge** is the name of the Docker bridge interface (default: "docker0")

**weave-scope-agent.resources.*** controls requests/limits for the agent
* See the above documentation for the **weave-scope-frontend.resources** part of the frontend values; the same child values, notes and definitions apply here.

## Other notes

* The Deployment for the frontend specifies a single replica; multiple replicas of the frontend, although they may run, probably will not work as expected since different agents may end up talking to different replicas.
