# Keycloak

[Keycloak](http://www.keycloak.org/) is an open source identity and access management for modern applications and services.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak
```

## Introduction

This chart bootstraps a [Keycloak](http://www.keycloak.org/) StatefulSet on a [Kubernetes](https://kubernetes.io) cluster 
using the [Helm](https://helm.sh) package manager. It provisions a fully featured Keycloak installation.
For more information on Keycloak and its capabilities, see it's [documentation](http://www.keycloak.org/documentation.html).

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

## Configuration

The following tables lists the configurable parameters of the Keycloak chart and their default values.

Parameter | Description | Default
--- | --- | ---
`hyperkube.image.repository` | Hyperkube image repository | `quay.io/coreos/hyperkube`
`hyperkube.image.tag` | Hyperkube image tag | `v1.8.1_coreos.0`
`hyperkube.image.pullPolicy` | Hyperkube image pull policy | `IfNotPresent`
`keycloak.replicas` | The number of Keycloak replicas | `1`
`keycloak.image.repository` | The Keycloak image repository | `jboss/keycloak`
`keycloak.image.tag` | The Keycloak image tag | `3.4.0.Final`
`keycloak.image.pullPolicy` | The Keycloak image pull policy | `IfNotPresent`
`keycloak.username` | Username for the initial Keycloak admin user | `keycloak`
`keycloak.password` | Password for the initial Keycloak admin user. If not set, a random 10 characters password is created | `""`
`keycloak.additionalEnv` | Allows the specification of additional environment variables for Keycloak | `[]`
`keycloak.resources` | Pod resource requests and limits | `{}`
`keycloak.podAntiAffinity` | Pod anti-affinity (`soft` or `hard`) | `soft`
`keycloak.nodeSelector` | Node labels for pod assignment | `{}`
`keycloak.tolerations` | Node taints to tolerate | `[]`
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
`keycloak.persistence.deployPostgres` | If true, the PostgreSQL chart is installed | `true`
`keycloak.persistence.existingSecret` | Name of an existing secret to be used for the database password (if `keycloak.persistence.deployPostgres=false`). Otherwise a new secret is created | `""`
`keycloak.persistence.existingSecretKey` | The key for the database password in the existing secret (if `keycloak.persistence.deployPostgres=false`) | `password`
`keycloak.persistence.dbVendor` | One of `H2`, `POSTGRES`, or `MYSQL` (if `deployPostgres=false`) | `H2`
`keycloak.persistence.dbName` | The name of the database to connect to (if `deployPostgres=false`) | `keycloak`
`keycloak.persistence.dbHost` | The database host name (if `deployPostgres=false`) | `mykeycloak`
`keycloak.persistence.dbPort` | The database host port (if `deployPostgres=false`) | `5432`
`keycloak.persistence.dbUser` |The database user (if `deployPostgres=false`) | `keycloak`
`keycloak.persistence.dbPassword` |The database password (if `deployPostgres=false`) | `keycloak`
`postgresql.postgresUser` | The PostgreSQL user (if `keycloak.persistence.deployPostgres=true`) | `keycloak`
`postgresql.postgresPassword` | The PostgreSQL password (if `keycloak.persistence.deployPostgres=true`) | `""`
`postgresql.postgresDatabase` | The PostgreSQL database (if `keycloak.persistence.deployPostgres=true`) | `keycloak`
`rbac.create` | Specifies whether RBAC resources should be created | `true`
`serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true`
`serviceAccount.name` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `""`
`test.image.repository` | Test image repository | `unguiculus/docker-python3-phantomjs-selenium`
`test.image.tag` | Test image tag | `v1`
`test.image.pullPolicy` | Test image pull policy | `IfNotPresent`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak -f values.yaml incubator/keycloak
```

### Database Setup

By default, the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart is deployed and used as database.
Please refer to this chart for additional PostgreSQL configuration options. If PostgreSQL is disabled, Keycloak uses an embedded H2 
database which is only suitable for testing with a single replica.

#### Using an External Database

The Keycloak Docker image supports PostgreSQL and MySQL. The password for the database user is read from a Kubernetes secret. It
is possible to specify an existing secret that is not managed with this chart. The key in the secret the password is read
from may be specified as well (defaults to `password`).

```yaml
keycloak:
  persistence:

    # Disable deployment of the PostgreSQL chart
    deployPostgres: false

    # Optionally specify an existing secret
    existingSecret: "my-database-password-secret"
    existingSecretKey: "password-key in-my-database-secret"

    dbVendor: POSTGRES # for MySQL use "MYSQL"

    dbName: keycloak
    dbHost: mykeycloak
    dbPort: 5432 # 5432 is PostgreSQL's default port. For MySQL it would be 3306
    dbUser: keycloak

    # Only used if no existing secret is specified. In this case a new secret is created
    dbPassword: keycloak
```

See also:
* https://github.com/jboss-dockerfiles/keycloak/blob/master/server/cli/databases/postgres/change-database.cli
* https://github.com/jboss-dockerfiles/keycloak/blob/master/server/cli/databases/mysql/change-database.cli

### Configuring additional environment variables:

```yaml
keycloak:
  additionalEnv:
    - name: KEYCLOAK_LOGLEVEL
      value: : DEBUG
    - name: WILDFLY_LOGLEVEL
      value: DEBUG
    - name: CACHE_OWNERS:
      value"3"
```

### WildFly Configuration

WildFly can be configured via its [command line interface (CLI)](https://docs.jboss.org/author/display/WFLY/Command+Line+Interface).
This chart uses the official Keycloak Docker image and customizes the installation running CLI scripts at server startup.

In order to make further customization easier, the CLI commands are separated by their concerns into smaller scripts.
Everything is in `values.yaml` and can be overridden. Additional CLI commands may be added via `keycloak.cli.custom`, 
which is empty by default.

### High Availability and Clustering

For high availability, Keycloak should be run with multiple replicas (`keycloak.replicas > 1`). WildFly uses Infinispan
for caching. These caches can be replicated across all instances forming a cluster. If `keycloak.replicas > 1`, the
WildFly CLI script `keycloak.cli.discovery` adds JGroups' [JDBC_PING](http://www.jgroups.org/javadoc/org/jgroups/protocols/JDBC_PING.html)
for cluster discovery and Keycloak is started with `--server-config standalone-ha.xml`.

## Why StatefulSet?

The chart sets node identifiers to the system property `jboss.node.name` which is in fact the pod name. Node identifiers
must not be longer than 23 characters. This can be problematic because pod names are quite long. We would have to truncate
the chart's fullname to six characters because pods get a 17-character suffix (e. g. `-697f8b7655-mf5ht`). Using a
StatefulSet allows us to truncate to 20 characters leaving room for up to 99 replicas, which is much better.
Additionally, we get stable values for `jboss.node.name` which can be advantageous for cluster discovery.
