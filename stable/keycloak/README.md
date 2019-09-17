# DEPRECATED - Keycloak

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/codecentric/helm-charts
- **Charts repo:** https://codecentric.github.io/helm-charts

```bash
helm repo add codecentric https://codecentric.github.io/helm-charts
```

---

[Keycloak](http://www.keycloak.org/) is an open source identity and access management for modern applications and services.

## TL;DR;

```console
$ helm install stable/keycloak
```

## Introduction

This chart bootstraps a [Keycloak](http://www.keycloak.org/) StatefulSet on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It provisions a fully featured Keycloak installation.
For more information on Keycloak and its capabilities, see its [documentation](http://www.keycloak.org/documentation.html).

## Prerequisites Details

The chart has an optional dependency on the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart.
By default, the PostgreSQL chart requires PV support on underlying infrastructure (may be disabled).

## Installing the Chart

To install the chart with the release name `keycloak`:

```console
$ helm install --name keycloak stable/keycloak
```

## Uninstalling the Chart

To uninstall/delete the `keycloak` deployment:

```console
$ helm delete keycloak
```

## Configuration

The following table lists the configurable parameters of the Keycloak chart and their default values.

Parameter | Description | Default
--- | --- | ---
`init.image.repository` | Init image repository | `alpine`
`init.image.tag` | Init image tag | `3.8`
`init.image.pullPolicy` | Init image pull policy | `IfNotPresent`
`clusterDomain` | The internal Kubernetes cluster domain | `cluster.local`
`keycloak.replicas` | The number of Keycloak replicas | `1`
`keycloak.image.repository` | The Keycloak image repository | `jboss/keycloak`
`keycloak.image.tag` | The Keycloak image tag | `5.0.0`
`keycloak.image.pullPolicy` | The Keycloak image pull policy | `IfNotPresent`
`keycloak.image.pullSecrets` | Image pull secrets | `[]`
`keycloak.basepath` | Path keycloak is hosted at | `auth`
`keycloak.username` | Username for the initial Keycloak admin user | `keycloak`
`keycloak.password` | Password for the initial Keycloak admin user (if `keycloak.existingSecret=""`). If not set, a random 10 characters password is created | `""`
`keycloak.existingSecret` | Specifies an existing secret to be used for the admin password | `""`
`keycloak.existingSecretKey` |  The key in `keycloak.existingSecret` that stores the admin password | `password`
`keycloak.extraInitContainers` | Additional init containers, e. g. for providing themes, etc. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.extraContainers` | Additional sidecar containers, e. g. for a database proxy, such as Google's cloudsql-proxy. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.extraEnv` | Allows the specification of additional environment variables for Keycloak. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.extraVolumeMounts` | Add additional volumes mounts, e. g. for custom themes. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.extraVolumes` | Add additional volumes, e. g. for custom themes. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.extraPorts` | Add additional ports, e. g. for custom admin console port. Passed through the `tpl` function and thus to be configured a string | `""`
`keycloak.podDisruptionBudget` | Pod disruption budget | `{}`
`keycloak.priorityClassName` | Pod priority classname | `{}`
`keycloak.resources` | Pod resource requests and limits | `{}`
`keycloak.affinity` | Pod affinity. Passed through the `tpl` function and thus to be configured a string | `Hard node and soft zone anti-affinity`
`keycloak.nodeSelector` | Node labels for pod assignment | `{}`
`keycloak.tolerations` | Node taints to tolerate | `[]`
`keycloak.podLabels` | Extra labels to add to pod | `{}`
`keycloak.podAnnotations` | Extra annotations to add to pod | `{}`
`keycloak.hostAliases` | Mapping between IP and hostnames that will be injected as entries in the pod's hosts files | `[]`
`keycloak.securityContext` | Security context for the pod | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`
`keycloak.preStartScript` | Custom script to run before Keycloak starts up | ``
`keycloak.lifecycleHooks` | Container lifecycle hooks. Passed through the `tpl` function and thus to be configured a string | ``
`keycloak.extraArgs` | Additional arguments to the start command | ``
`keycloak.livenessProbe.initialDelaySeconds` | Liveness Probe `initialDelaySeconds` | `120`
`keycloak.livenessProbe.timeoutSeconds` | Liveness Probe `timeoutSeconds` | `5`
`keycloak.readinessProbe.initialDelaySeconds` | Readiness Probe `initialDelaySeconds` | `30`
`keycloak.readinessProbe.timeoutSeconds` | Readiness Probe `timeoutSeconds` | `1`
`keycloak.cli.nodeIdentifier` | WildFly CLI script for setting the node identifier | See `values.yaml`
`keycloak.cli.logging` | WildFly CLI script for logging configuration | See `values.yaml`
`keycloak.cli.reverseProxy` | WildFly CLI script for reverse proxy configuration | See `values.yaml`
`keycloak.cli.ha` | Settings for HA setups | See `values.yaml`
`keycloak.cli.custom` | Additional custom WildFly CLI script | `""`
`keycloak.service.annotations` | Annotations for the Keycloak service | `{}`
`keycloak.service.labels` | Additional labels for the Keycloak service | `{}`
`keycloak.service.type` | The service type | `ClusterIP`
`keycloak.service.port` | The service port | `80`
`keycloak.service.nodePort` | The node port used if the service is of type `NodePort` | `""`
`keycloak.ingress.enabled` | if `true`, an ingress is created | `false`
`keycloak.ingress.annotations` | annotations for the ingress | `{}`
`keycloak.ingress.path` | if `true`, an ingress is created | `/`
`keycloak.ingress.hosts` | a list of ingress hosts | `[keycloak.example.com]`
`keycloak.ingress.tls` | a list of [IngressTLS](https://v1-9.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.9/#ingresstls-v1beta1-extensions) items | `[]`
`keycloak.persistence.deployPostgres` | If true, the PostgreSQL chart is installed | `false`
`keycloak.persistence.existingSecret` | Name of an existing secret to be used for the database password (if `keycloak.persistence.deployPostgres=false`). Otherwise a new secret is created | `""`
`keycloak.persistence.existingSecretKey` | The key for the database password in the existing secret (if `keycloak.persistence.deployPostgres=false`) | `password`
`keycloak.persistence.dbVendor` | One of `h2`, `postgres`, `mysql`, or `mariadb` (if `deployPostgres=false`) | `h2`
`keycloak.persistence.dbName` | The name of the database to connect to (if `deployPostgres=false`) | `keycloak`
`keycloak.persistence.dbHost` | The database host name (if `deployPostgres=false`) | `mykeycloak`
`keycloak.persistence.dbPort` | The database host port (if `deployPostgres=false`) | `5432`
`keycloak.persistence.dbUser` |The database user (if `deployPostgres=false`) | `keycloak`
`keycloak.persistence.dbPassword` |The database password (if `deployPostgres=false`) | `""`
`postgresql.postgresUser` | The PostgreSQL user (if `keycloak.persistence.deployPostgres=true`) | `keycloak`
`postgresql.postgresPassword` | The PostgreSQL password (if `keycloak.persistence.deployPostgres=true`) | `""`
`postgresql.postgresDatabase` | The PostgreSQL database (if `keycloak.persistence.deployPostgres=true`) | `keycloak`
`test.enabled` | If `true`, test pods get scheduled | `true`
`test.image.repository` | Test image repository | `unguiculus/docker-python3-phantomjs-selenium`
`test.image.tag` | Test image tag | `v1`
`test.image.pullPolicy` | Test image pull policy | `IfNotPresent`
`test.securityContext` | Security context for the test pod | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak -f values.yaml stable/keycloak
```

### Usage of the `tpl` Function

The `tpl` function allows us to pass string values from `values.yaml` through the templating engine. It is used for the following values:

* `keycloak.extraInitContainers`
* `keycloak.extraContainers`
* `keycloak.extraEnv`
* `keycloak.affinity`
* `keycloak.extraVolumeMounts`
* `keycloak.extraVolumes`

It is important that these values be configured as strings. Otherwise, installation will fail. See example for Google Cloud Proxy or default affinity configuration in `values.yaml`.

### Database Setup

By default, Keycloak uses an embedded H2 database.
This is only suitable for testing purposes.
All data is lost when Keycloak is shut down.
Optionally, the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart is deployed and used as database.
Please refer to this chart for additional PostgreSQL configuration options.

#### Using an External Database

The Keycloak Docker image supports PostgreSQL, MySQL, MariaDB, and H2. The password for the database user is read from a Kubernetes secret. It is possible to specify an existing secret that is not managed with this chart. The key in the secret the password is read from may be specified as well (defaults to `password`).

```yaml
keycloak:
  persistence:

    # Disable deployment of the PostgreSQL chart
    deployPostgres: false

    # The database vendor. Can be either "postgres", "mysql", "mariadb", or "h2"
    dbVendor: postgres

    ## The following values only apply if "deployPostgres" is set to "false"

    # Optionally specify an existing secret
    existingSecret: "my-database-password-secret"
    existingSecretKey: "password-key in-my-database-secret"

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

### Configuring Additional Environment Variables

```yaml
keycloak:
  extraEnv: |
    - name: KEYCLOAK_LOGLEVEL
      value: DEBUG
    - name: WILDFLY_LOGLEVEL
      value: DEBUG
    - name: CACHE_OWNERS
      value: "3"
    - name: DB_QUERY_TIMEOUT
      value: "60"
    - name: DB_VALIDATE_ON_MATCH
      value: true
    - name: DB_USE_CAST_FAIL
      value: false
```

### Providing a Custom Theme

One option is certainly to provide a custom Keycloak image that includes the theme. However, if you prefer to stick with the official Keycloak image, you can use an init container as theme provider.

Create your own theme and package it up into a Docker image.

```docker
FROM busybox
COPY my_theme /my_theme
```

In combination with an `emptyDir` that is shared with the Keycloak container, configure an init container that runs your theme image and copies the theme over to the right place where Keycloak will pick it up automatically.

```yaml
keycloak:
  extraInitContainers: |
    - name: theme-provider
      image: myuser/mytheme:1
      imagePullPolicy: IfNotPresent
      command:
        - sh
      args:
        - -c
        - |
          echo "Copying theme..."
          cp -R /mytheme/* /theme
      volumeMounts:
        - name: theme
          mountPath: /theme

  extraVolumeMounts: |
    - name: theme
      mountPath: /opt/jboss/keycloak/themes/mytheme

  extraVolumes: |
    - name: theme
      emptyDir: {}
```

### Setting a Custom Realm

A realm can be added by creating a secret or configmap for the realm json file and then supplying this into the chart.
It could be mounted using `extraVolumeMounts` and then specified in `extraArgs` using `-Dkeycloak.import`.
First we could create a Secret from a json file using `kubectl create secret generic realm-secret --from-file=realm.json` which we need to reference in `values.yaml`:

```yaml
keycloak:
  extraVolumes: |
    - name: realm-secret
      secret:
        secretName: realm-secret

  extraVolumeMounts: |
    - name: realm-secret
      mountPath: "/realm/"
      readOnly: true

  extraArgs: -Dkeycloak.import=/realm/realm.json
```

Alternatively, the file could be added to a custom image (set in `keycloak.image`) and then referenced by `-Dkeycloak.import`.

After startup the web admin console for the realm should be available on the path /auth/admin/\<realm name>/console/.

### Using Google Cloud SQL Proxy

Depending on your environment you may need a local proxy to connect to the database. This is, e. g., the case for Google Kubernetes Engine when using Google Cloud SQL. Create the secret for the credentials as documented [here](https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine) and configure the proxy as a sidecar.

Because `keycloak.extraContainers` is a string that is passed through the `tpl` function, it is possible to create custom values and use them in the string.

```yaml

# Custom values for Google Cloud SQL
cloudsql:
  project: my-project
  region: europe-west1
  instance: my-instance

keycloak:
  extraContainers: |
    - name: cloudsql-proxy
      image: gcr.io/cloudsql-docker/gce-proxy:1.11
      command:
        - /cloud_sql_proxy
      args:
        - -instances={{ .Values.cloudsql.project }}:{{ .Values.cloudsql.region }}:{{ .Values.cloudsql.instance }}=tcp:5432
        - -credential_file=/secrets/cloudsql/credentials.json
      volumeMounts:
        - name: cloudsql-creds
          mountPath: /secrets/cloudsql
          readOnly: true

  extraVolumes: |
    - name: cloudsql-creds
      secret:
        secretName: cloudsql-instance-credentials

  persistence:
    deployPostgres: false
    dbVendor: postgres
    dbName: postgres
    dbHost: 127.0.0.1
    dbPort: 5432
    dbUser: myuser
    dbPassword: mypassword
```

### WildFly Configuration

WildFly can be configured via its [command line interface (CLI)](https://docs.jboss.org/author/display/WFLY/Command+Line+Interface).
This chart uses the official Keycloak Docker image and customizes the installation running CLI scripts at server startup.

In order to make further customization easier, the CLI commands are separated by their concerns into smaller scripts.
Everything is in `values.yaml` and can be overridden. Additional CLI commands may be added via `keycloak.cli.custom`, which is empty by default.

### High Availability and Clustering

For high availability, Keycloak should be run with multiple replicas (`keycloak.replicas > 1`).
WildFly uses Infinispan for caching. These caches can be replicated across all instances forming a cluster.
If `keycloak.replicas > 1`, JGroups' DNS_PING is configured for cluster discovery and Keycloak is started with `--server-config standalone-ha.xml`.

## Why StatefulSet?

The chart sets node identifiers to the system property `jboss.node.name` which is in fact the pod name.
Node identifiers must not be longer than 23 characters.
This can be problematic because pod names are quite long.
We would have to truncate the chart's fullname to six characters because pods get a 17-character suffix (e. g. `-697f8b7655-mf5ht`).
Using a StatefulSet allows us to truncate to 20 characters leaving room for up to 99 replicas, which is much better.
Additionally, we get stable values for `jboss.node.name` which can be advantageous for cluster discovery.
The headless service that governs the StatefulSet is used for DNS discovery.
