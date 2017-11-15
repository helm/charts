# Keycloak

[Keycloak](http://www.keycloak.org/) is an open source identity and access management for modern applications and services.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak
```

## Introduction

This chart bootstraps a [Keycloak](http://www.keycloak.org/) StatefulSet on a [Kubernetes](https://kubernetes.io) cluster 
using the [Helm](https://helm.sh) package manager.

## Prerequisites Details

The chart has an optional dependency on the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart.
By default, the PostgreSQL chart requires PV support on underlying infrastructure (may be disabled).

## Installing the Chart

To install the chart with the release name `keycloak`:

```console
$ helm install --name keycloak incubator/keycloak
```

## Uninstalling the Chart

To uninstall/delete the `keycloak` deployment:

```console
$ helm delete keycloak
```

## Chart Details
This chart will provision a fully functional and fully featured Keycloak installation.
For more information on Keycloak and its capabilities, see it's [documentation](http://www.keycloak.org/documentation.html).

## Why StatefulSet?

The chart sets node identifiers to the system property `jboss.node.name` which is in fact the pod name. Node identifiers
must not be longer than 23 characters. This can be problematic because pod names are quite long. We would have to truncate
the chart's fullname to six characters because pods get a 17-character suffix (e. g. `-697f8b7655-mf5ht`). Using a 
StatefulSet allows us to truncate to 20 characters leaving room for up to 99 replicas, which is much better. 
Additionally, we get stable values for `jboss.node.name` which may be advantages for cluster discovery.

## Configuration

The following tables lists the configurable parameters of the Keycloak chart and their default values.

Parameter | Description | Default
--- | --- | ---
`hyperkube.image.repository` | Hyperkube image repository | `quay.io/coreos/hyperkube`
`hyperkube.image.tag` | Hyperkube image tasg | `v1.8.1_coreos.0`
`hyperkube.image.pullPolicy` | Hyperkube image pull policy | `IfNotPresent`
`keycloak.replicas` | The number of Keycloak replicas | `1`
`keycloak.image.repository` | The Keycloak image repository | `jboss/keycloak`
`keycloak.image.tag` | The Keycloak imagfe tag | `3.4.0.Final`
`keycloak.image.pullPolicy` | The Keycloak image pull policy | `IfNotPresent`
`keycloak.username` | Username for the initial Keycloak admin user | `keycloak`
`keycloak.password` | Password for the initial Keycloak admin user. If not set, a random 10 characters password is created | `""`
`keycloak.additionalEnv` | Allows the specification of additional environment variables for Keycloak | `{}`
`keycloak.resources` | Pod resource requests and limits | `{}`
`keycloak.podAntiAffinity` | Pod anti-affinity (`soft` or `hard`) | `soft`
`keycloak.nodeSelector` | Node labels for pod assignment | `{}`
`keycloak.tolerations` | Node taints to tolerate | `[]`
`keycloak.discovery` | Set to true for high availability. This enables cluster discovery using [JGroups JDBC_PING](http://www.jgroups.org/javadoc/org/jgroups/protocols/JDBC_PING.html). | `false`
`keycloak.cli.nodeIdentifier` | WildFly CLI script for setting the node identifier | See `values.yaml`
`keycloak.cli.logging` | WildFly CLI script for logging configuration | See `values.yaml`
`keycloak.cli.reverseProxy` | WildFly CLI script for reverse proxy configuration | See `values.yaml`
`keycloak.cli.discovery` | WildFly CLI script for cluster discovery | See `values.yaml`
`keycloak.cli.custom` | Additional custom WildFly CLI script | `""`
`keycloak.service.annotations` | Annotations for the Keycloak service | `{}`
`keycloak.service.labels` | Additional labels for ther Keycloak service | `{}`
`keycloak.service.type` | The service type | `ClusterIP`
`keycloak.service.port` | The service port | `80`
`keycloak.service.nodePort` | The node port used if the service is of type `NodePort` | `""`
`keycloak.ingress.enabled` | If true, an ingress is be created | `false`
`keycloak.ingress.path` | The ingress path | `/`
`keycloak.ingress.annotations` | Annotations for the ingress | `{}`
`keycloak.ingress.hosts` | A list of hosts for the ingress | `[keycloak.example.com]`
`keycloak.ingress.tls.enabled` | If true, tls is enabled for the ingress | `false`
`keycloak.ingress.tls.existingSecret` | If tls is enabled, uses an existing secret with this name; otherwise a secret is created | `false`
`keycloak.ingress.tls.secretContents` | Contents for the tls secret | `{}`
`keycloak.ingress.tls.secretAnnotations` | Annotations for the newly created tls secret | `{}`
`postgresql.enabled` | If true, the PostgreSQL chart is installed | `true`
`postgresql.postgresUser` | The PostgreSQL user | `keycloak`
`postgresql.postgresPassword` | The PostgreSQL password | `""`
`postgresql.postgresDatabase` | The PostgreSQL database | `keycloak` 

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak -f values.yaml incubator/keycloak
```

## Database Setup

By default, the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart is deployed and used as database.
Please refer to this chart for additional PostgreSQL configuration options. If PostgreSQL is disabled, Keycloak uses an embedded H2 
database which is, which is only suitable for testing with a single replica.

If the PostgreSQL dependency is not used, a different PostgreSQL installation may be configured using environment variables
via `keycloak.additionalEnv`. The Keycloak Docker image supports the following environment variables:

```
POSTGRES_PORT_5432_TCP_ADDR
POSTGRES_PORT_5432_TCP_PORT
POSTGRES_DATABASE
POSTGRES_USER
POSTGRES_PASSWORD
```

See also: https://github.com/jboss-dockerfiles/keycloak/blob/master/server/cli/databases/postgres/change-database.cli

**Configuring environment variables in a custom values file:**

```yaml
keycloak:
  additionalEnv:
    POSTGRES_PORT_5432_TCP_ADDR: mydbhost
    POSTGRES_PORT_5432_TCP_PORT: 5432
    POSTGRES_DATABASE: keycloak
    POSTGRES_USER: keycloak
```

**Configuring environment variables via `--set` flag**

`--set keycloak.additionalEnv.POSTGRES_PASSWORD=secret`

## WildFly Configuration

WildFly can be configured via its [command line interface (CLI)](https://docs.jboss.org/author/display/WFLY/Command+Line+Interface).
This chart uses the official Keycloak Docker image and customizes the installation running CLI scripts at server startup.

In order to make further customization easier, the CLI commands are separated by their concerns into smaller scripts.
Everything is in `values.yaml` and can be overridden. Additional CLI commands may be added via `keycloak.cli.custom`, 
which is empty by default.

## High Availability and Clustering

For high availability, Keycloak should be run with multiple replicas (`keycloak.replicas > 1`). WildFly uses Infinispan
for caching. These caches can be replicated across all instances forming a cluster. This can be enabled with `keycloak.discovery=true`).
The CLI script `keycloak.cli.discovery` adds JGroups' [JDBC_PING](http://www.jgroups.org/javadoc/org/jgroups/protocols/JDBC_PING.html)
for cluster discovery.

If `keycloak.discovery=true`, Keycloak is started with `--server-config standalone-ha.xml`.
