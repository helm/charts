# Hydra

[Hydra](https://github.com/ory/hydra) is a hardened, certified OAuth2 and OpenID Connect server optimized for low-latency, high throughput, and low resource consumption.

## TL;DR;

```console
$ helm install stable/hydra
```

## Introduction

This chart bootstraps a [Hydra](https://github.com/ory/hydra) Deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
For more information on Hydra and its capabilities, see its [documentation](https://www.ory.sh/docs/guides/latest/hydra).

## Prerequisites Details

The chart has an optional dependency on the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart.
By default, the PostgreSQL chart requires PV support on underlying infrastructure (may be disabled).

## Installing the Chart

To install the chart with the release name `hydra`:

```console
$ helm install --name hydra stable/hydra
```

## Uninstalling the Chart

To uninstall/delete the `hydra` deployment:

```console
$ helm delete hydra
```

## Configuration

The following table lists the configurable parameters of the Hydra chart and their default values.

Parameter | Description | Default
--- | --- | ---
`hydra.replicas` | The number of Hydra replicas | `1`
`hydra.image.repository` | The Hydra image repository | `oryd/hydra`
`hydra.image.tag` | The Hydra image tag | `v1.0.0-rc.5_oryOS.10-alpine`
`hydra.image.pullPolicy` | The image pull policy | `IfNotPresent`
`hydra.image.pullSecrets` | Image pull secrets | `[]`
`hydra.initContainers` | Init containers. Passed through the `tpl` funtion and thus to be configured a string | `""`
`hydra.extraContainers` | Additional sidecar containers, e. g. for a database proxy, such as Google's cloudsql-proxy. Passed through the `tpl` funtion and thus to be configured a string | `""`
`hydra.extraEnv` | Allows the specification of additional environment variables for Hydra. Passed through the `tpl` funtion and thus to be configured a string | `""`
`hydra.extraVolumeMounts` | Add additional volumes mounts. Passed through the `tpl` funtion and thus to be configured a string | `""`
`hydra.extraVolumes` | Add additional volumes. Passed through the `tpl` funtion and thus to be configured a string | `""`
`hydra.podDisruptionBudget` | Pod disruption budget | `{}`
`hydra.resources` | Pod resource requests and limits | `{}`
`hydra.affinity` | Pod affinity. Passed through the `tpl` funtion and thus to be configured a string | `Hard node and soft zone anti-affinity`
`hydra.nodeSelector` | Node labels for pod assignment | `{}`
`hydra.tolerations` | Node taints to tolerate | `[]`
`hydra.securityContext` | Security context for the pod | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`
`hydra.extraArgs` | Additional arguments to the start command | ``
`hydra.livenessProbe.initialDelaySeconds` | Liveness Probe `initialDelaySeconds` | `60`
`hydra.livenessProbe.timeoutSeconds` | Liveness Probe `timeoutSeconds` | `2`
`hydra.readinessProbe.initialDelaySeconds` | Readiness Probe `initialDelaySeconds` | `30`
`hydra.readinessProbe.timeoutSeconds` | Readiness Probe `timeoutSeconds` | `1`
`hydra.service.public.annotations` | Annotations for the Hydra public API service | `{}`
`hydra.service.public.labels` | Additional labels for the Hydra public API service | `{}`
`hydra.service.public.type` | The Hydra public API service type | `ClusterIP`
`hydra.service.public.port` | The Hydra public API service port | `80`
`hydra.service.public.nodePort` | The node port used if the Hydra public API service is of type `NodePort` | `""`
`hydra.service.admin.annotations` | Annotations for the Hydra admin API service | `{}`
`hydra.service.admin.labels` | Additional labels for the Hydra admin API service | `{}`
`hydra.service.admin.type` | The Hydra admin API service type | `ClusterIP`
`hydra.service.admin.port` | The Hydra admin API service port | `80`
`hydra.service.admin.nodePort` | The node port used if the Hydra admin API service is of type `NodePort` | `""`
`hydra.ingress.enabled` | if `true`, an ingress is created | `false`
`hydra.ingress.annotations` | annotations for the ingress | `{}`
`hydra.ingress.path` | if `true`, an ingress is created | `/`
`hydra.ingress.hosts` | a list of ingress hosts | `[hydra.example.com]`
`hydra.ingress.tls` | a list of [IngressTLS](https://v1-9.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.9/#ingresstls-v1beta1-extensions) items | `[]`
`hydra.persistence.deployPostgres` | If true, the PostgreSQL chart is installed | `false`
`hydra.persistence.dbVendor` | One of `memory`, `postgres` or `mysql` (if `deployPostgres=false`) | `memory`
`hydra.persistence.dbName` | The name of the database to connect to (if `deployPostgres=false`) | `hydra`
`hydra.persistence.dbHost` | The database host name (if `deployPostgres=false`) | `hydra`
`hydra.persistence.dbPort` | The database host port (if `deployPostgres=false`) | `5432`
`hydra.persistence.dbUser` |The database user (if `deployPostgres=false`) | `hydra`
`hydra.persistence.dbPassword` |The database password (if `deployPostgres=false`) | `""`
`postgresql.postgresUser` | The PostgreSQL user (if `hydra.persistence.deployPostgres=true`) | `hydra`
`postgresql.postgresPassword` | The PostgreSQL password (if `hydra.persistence.deployPostgres=true`) | `""`
`postgresql.postgresDatabase` | The PostgreSQL database (if `hydra.persistence.deployPostgres=true`) | `hydra`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name hydra -f values.yaml stable/hydra
```

### Usage of the `tpl` Function

The `tpl` function allows us to pass string values from `values.yaml` through the templating engine. It is used for the following values:

* `hydra.extraInitContainers`
* `hydra.extraContainers`
* `hydra.extraEnv`
* `hydra.affinity`
* `hydra.extraVolumeMounts`
* `hydra.extraVolumes`

It is important that these values be configured as strings. Otherwise, installation will fail. See example for Google Cloud Proxy or default affinity configuration in `values.yaml`.

### Database Setup

By default, Hydra uses an in-memory database.
This is only suitable for testing purposes.
All data is lost when Hydra is shut down.
Optionally, the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) chart is deployed and used as database.
Please refer to this chart for additional PostgreSQL configuration options.

#### Using an External Database

Hydra supports PostgreSQL and MySQL. The password for the database user is read from a Kubernetes secret.

```yaml
hydra:
  persistence:

    # Disable deployment of the PostgreSQL chart
    deployPostgres: false

    # The database vendor. Can be either "postgres", "mysql", "memory"
    dbVendor: postgres

    ## The following values only apply if "deployPostgres" is set to "false"
    dbName: hydra
    dbHost: hydra
    dbPort: 5432 # 5432 is PostgreSQL's default port. For MySQL it would be 3306
    dbUser: hydra
    dbPassword: hydra
```

See also:
* https://www.ory.sh/docs/guides/latest/hydra/2-environment/#sql

### Configuring Additional Environment Variables

```yaml
hydra:
  extraEnv:
    - name: LOG_LEVEL
      value: debug
    - name: OAUTH2_SHARE_ERROR_DEBUG
      value: true
```

### Using Google Cloud SQL Proxy

Depending on your environment you may need a local proxy to connect to the database. This is, e. g., the case for Google Kubernetes Engine when using Google Cloud SQL. Create the secret for the credentials as documented [here](https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine) and configure the proxy as a sidecar.

Because `hydra.extraContainers` is a string that is passed through the `tpl` function, it is possible to create custom values and use them in the string.

```yaml

# Custom values for Google Cloud SQL
cloudsql:
  project: my-project
  region: europe-west1
  instance: my-instance

hydra:
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

### Prometheus metrics
Prometheus metric scraping may be enabled via annotations to the service object like:


```yaml
hyrda:
  service:
    admin:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "4445"
        prometheus.io/path: "/metrics/prometheus"
```
