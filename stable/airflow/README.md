# Airflow Helm Chart

[Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## Installation

To install the Airflow Helm Chart:
```bash
helm install stable/airflow \
  --version "X.X.X" \
  --name "airflow" \
  --namespace "airflow" \
  --values ./custom-values.yaml
```

To get the status of the Airflow Helm Chart:
```bash
helm status "airflow"
```

To uninstall the Airflow Helm Chart:
```bash
helm delete "airflow"
```

To run bash commands in the Airflow Scheduler Pod:
```bash
# use this to run commands like: `airflow create_user`
kubectl exec \
  -it \
  --namespace airflow \
  --container airflow-scheduler \
  Deployment/airflow-scheduler \
  /bin/bash
```

### Upgrade Steps:

> NOTE: for chart version numbers, see [Chart.yaml](Chart.yaml) or [helm hub](https://hub.helm.sh/charts/stable/airflow).

For steps you must take when upgrading this chart, please review:
* [v7.4.X → v7.5.0](UPGRADE.md#v74x--v750)
* [v7.3.X → v7.4.0](UPGRADE.md#v73x--v740)
* [v7.2.X → v7.3.0](UPGRADE.md#v72x--v730)
* [v7.1.X → v7.2.0](UPGRADE.md#v71x--v720)
* [v7.0.X → v7.1.0](UPGRADE.md#v70x--v710)
* [v6.X.X → v7.0.0](UPGRADE.md#v6xx--v700)
* [v5.X.X → v6.0.0](UPGRADE.md#v5xx--v600)
* [v4.X.X → v5.0.0](UPGRADE.md#v4xx--v500)
* [v3.X.X → v4.0.0](UPGRADE.md#v3xx--v400)

### Examples:

There are many ways to deploy this chart, but here are some starting points for your `custom-values.yaml`:

| Name | File | Description |
| --- | --- | --- |
| (CeleryExecutor) Minimal | [examples/minikube/custom-values.yaml](examples/minikube/custom-values.yaml) | a __non-production__ starting point |
| (CeleryExecutor) Google Cloud | [examples/google-gke/custom-values.yaml](examples/google-gke/custom-values.yaml) | a __production__ starting point for GKE on Google Cloud |

## Airflow-Configs

### Airflow-Configs/General

While we don't expose the `airflow.cfg` directly, you can use [environment variables](https://airflow.apache.org/docs/stable/howto/set-config.html) to set Airflow configs.

We expose the `airflow.config` value to make this easier:
```yaml
airflow:
  config:
    ## Security
    AIRFLOW__CORE__SECURE_MODE: "True"
    AIRFLOW__API__AUTH_BACKEND: "airflow.api.auth.backend.deny_all"
    AIRFLOW__WEBSERVER__EXPOSE_CONFIG: "False"
    AIRFLOW__WEBSERVER__RBAC: "False"

    ## DAGS
    AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL: "30"
    AIRFLOW__CORE__LOAD_EXAMPLES: "False"

    ## Email (SMTP)
    AIRFLOW__EMAIL__EMAIL_BACKEND: "airflow.utils.email.send_email_smtp"
    AIRFLOW__SMTP__SMTP_HOST: "smtpmail.example.com"
    AIRFLOW__SMTP__SMTP_STARTTLS: "False"
    AIRFLOW__SMTP__SMTP_SSL: "False"
    AIRFLOW__SMTP__SMTP_PORT: "25"
    AIRFLOW__SMTP__SMTP_MAIL_FROM: "admin@example.com"

    ## Disable noisy "Handling signal: ttou" Gunicorn log messages
    GUNICORN_CMD_ARGS: "--log-level WARNING"
```

### Airflow-Configs/Connections

We expose the `scheduler.connections` value to allow specifying [Airflow Connections](https://airflow.apache.org/docs/stable/concepts.html#connections) at deployment time, these connections will be automatically imported by the Airflow scheduler when it starts up.

For example, to add a connection called `my_aws`:
```yaml
scheduler:
  connections:
    - id: my_aws
      type: aws
      extra: |
        {
          "aws_access_key_id": "XXXXXXXXXXXXXXXXXXX",
          "aws_secret_access_key": "XXXXXXXXXXXXXXX",
          "region_name":"eu-central-1"
        }
```

We expose the `scheduler.refreshConnections` value to refresh connections by
removing them before adding them when they are automatically being imported. The
default value is true, so if a user wants to add a password after the initial
deployment, they should set `scheduler.refreshConnections` to false.

__NOTE:__ As connections may include sensitive data, we store the bash script which generates the connections in a Kubernetes Secret, and mount this to the pods.

__WARNING:__ Because some values are sensitive, you should take care to store your custom `values.yaml` securely before passing it to helm with: `helm -f <my-secret-values.yaml>`

### Airflow-Configs/Variables

We expose the `scheduler.variables` value to allow specifying [Airflow Variables](https://airflow.apache.org/docs/stable/concepts.html#variables) at deployment time, variables will be automatically imported by the Airflow scheduler when it starts up.

For example, to specify a variable called `environment`:
```yaml
scheduler:
  variables: |
    { "environment": "dev" }
```

### Airflow-Configs/Pools

We expose the `scheduler.pools` value to allow specifying [Airflow Pools](https://airflow.apache.org/docs/stable/concepts.html#pools) at deployment time, these pools will be automatically imported by the Airflow scheduler when it starts up.

For example, to create a pool called `example`:
```yaml
scheduler:
  pools: |
    {
      "example": {
        "description": "This is an example pool with 2 slots.",
        "slots": 2
      }
    }
```

### Airflow-Configs/Secret-Environment-Variables

It is possible to specify additional environment variables using the same format as in a pod's `.spec.containers.env` definition.
These environment variables will be mounted in the web, scheduler, and worker pods.
You can use this feature to pass additional secret environment variables to Airflow.

Here is a simple example showing how to pass in a Fernet key and LDAP password:
```yaml
extraEnv:
  - name: AIRFLOW__CORE__FERNET_KEY
    valueFrom:
      secretKeyRef:
        name: airflow
        key: fernet-key
  - name: AIRFLOW__LDAP__BIND_PASSWORD
    valueFrom:
      secretKeyRef:
        name: ldap
        key: password
```

__NOTE:__ For this example to work, both the `airflow` and `ldap` Kubernetes secrets must already exist in the proper namespace.

## Kubernetes-Configs

In this chart we expose many Kubernetes-specific configs not usually found in Airflow.

### Kubernetes-Configs/Ingress

#### Overview:

This chart provides an optional Ingress resource, which can be enabled and configured by passing a custom `values.yaml` to helm.

This chart exposes 2 endpoints on the Ingress:
* Airflow WebUI
* Flower (A debug UI for Celery)

#### Custom Paths:

This chart enables you to add various paths to the ingress.
It includes two values for you to customize these paths, `precedingPaths` and `succeedingPaths`, which are before and after the default path to `Service/airflow-web`.
A common use case is enabling https with the `aws-alb-ingress-controller` [ssl-redirect](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/tasks/ssl_redirect/), which needs a redirect path to be hit before the airflow-web one.

You would set the values of `precedingPaths` as the following:
```yaml
precedingPaths:
  - path: "/*"
    serviceName: "ssl-redirect"
    servicePort: "use-annotation"
```

#### URL Prefix:

If you already have something hosted at the root of your domain, you might want to place airflow/flower under a url-prefix.
For example, with a url-prefix of `/airflow/`:
* http://example.com/airflow/
* http://example.com/airflow/flower


When customizing this, please note:
- Airflow WebUI behaves transparently, to configure it one just needs to specify the `web.baseUrl` value.
- Flower requires a URL rewrite mechanism in front of it.
  For specifics on this, see the comments of `flower.urlPrefix` inside `values.yaml`.

### Kubernetes-Configs/Worker-Autoscaling

We use a Kubernetes StatefulSet for the Celery workers, this allows the webserver to requests logs from each workers individually, with a fixed DNS name.

Celery workers can be scaled using the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).
To enable autoscaling, you must set `workers.autoscaling.enabled=true`, then provide `workers.autoscaling.maxReplicas`, and `workers.replicas` for the minimum amount.
Make sure to set a resource request in `workers.resources`, and `dags.git.gitSync.resources`, otherwise worker pods will not scale.
(For git-sync, `64Mi` should be enough.)

Assume every task a worker executes consumes approximately `200Mi` memory, that means memory is a good metric for utilisation monitoring.
For a worker pod you can calculate it: `WORKER_CONCURRENCY * 200Mi`, so for `10 tasks` a worker will consume `~2Gi` of memory.

Here is the `values.yaml` config for that example:
```yaml
workers:
  replicas: 1

  resources:
    requests:
      memory: "2Gi"

  autoscaling:
    enabled: true
    maxReplicas: 16
    metrics:
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80

  celery:
    instances: 10

    ## wait at most 10min for running tasks to complete
    gracefullTermination: true
    gracefullTerminationPeriod: 600

  ## how many seconds (after the 10min) to wait before SIGKILL
  terminationPeriod: 60

dags:
  git:
    gitSync:
      resources:
        requests:
          memory: "64Mi"
```

__NOTE:__ With this config if a worker consumes `80%` of `2Gi` (which will happen if it runs 9-10 tasks at the same time), an autoscale event will be triggered, and a new worker will be added.
If you have many tasks in a queue, Kubernetes will keep adding workers until maxReplicas reached, in this case `16`.

### Kubernetes-Configs/Worker-Secrets

You can add Kubernetes Secrets which will be mounted as volumes on the worker nodes at `{workers.secretsDir}/<secret-name>`:
```yaml
workers:
  secretsDir: /var/airflow/secrets
  secrets:
    - redshift-user
    - redshift-password
    - elasticsearch-user
    - elasticsearch-password
```

With the above configuration, you could read the `redshift-user` password from within a dag or other function using:
```python
import os
from pathlib import Path

def get_secret(secret_name):
    secrets_dir = Path('/var/airflow/secrets')
    secret_path = secrets_dir / secret_name
    assert secret_path.exists(), f'could not find {secret_name} at {secret_path}'
    secret_data = secret_path.read_text().strip()
    return secret_data

redshift_user = get_secret('redshift-user')
```

To create a secret, you can use:
```bash
# where `~/secrets/redshift-user.txt` contains the user secret as a single text string
kubectl create secret generic redshift-user --from-file=redshift-user=~/secrets/redshift-user.txt
```

### Kubernetes-Configs/Extra-Python-Packages

Sometimes you may need to install extra pip packages for things to work, we provide `airflow.extraPipPackages` and `web.extraPipPackages` for this purpose.

For example, enabling the airflow `airflow-exporter` package:
```yaml
airflow:
  extraPipPackages:
    - "airflow-exporter==1.3.1"
```

For example, you may be using `flask_oauthlib` to integrate with Okta/Google/etc for authorizing WebUI users:
```yaml
web:
  extraPipPackages:
    - "apache-airflow[google_auth]==1.10.10"
```

__NOTE:__ these work with any pip package that you can install with the `pip install XXXX` cli

### Kubernetes-Configs/Additional-Manifests

It is possible to add additional manifests into a deployment, to extend the chart.
One of the reason is to deploy a manifest specific to a cloud provider.

For example, adding a `BackendConfig` on GKE:
```yaml
extraManifests:
- apiVersion: cloud.google.com/v1beta1
  kind: BackendConfig
  metadata:
    name: "{{ .Release.Name }}-test"
  spec:
    securityPolicy:
      name: "gcp-cloud-armor-policy-test"
```

## Database-Configs

### Database-Configs/Initialization

If the value `scheduler.initdb` is set to `true`, the airflow-scheduler container will run `airflow initdb` before starting the scheduler as part of its startup script.

If the value `scheduler.preinitdb` is set to `true`, the airflow-scheduler pod will run `airflow initdb` as an initContainer, before the git-clone initContainer (if that is enabled).
This is rarely necessary but can be so under certain conditions if your synced DAGs include custom database hooks that prevent `initdb` from running successfully.
For example, if they have dependencies on variables that won't be present yet.
The initdb initcontainer will retry up to 5 times before giving up.


### Database-Configs/Passwords

Postgres is used as the default database backing Airflow in this chart, we use insecure username/password combinations by default.

For a real production deployment, it's a good idea to create secure credentials before installing the Helm chart.
For example, from the command line, run:
```bash
kubectl create secret generic airflow-postgresql --from-literal=postgresql-password=$(openssl rand -base64 13)
kubectl create secret generic airflow-redis --from-literal=redis-password=$(openssl rand -base64 13)
```

Next, you can use those secrets with your `values.yaml`:
```yaml
postgresql:
  existingSecret: airflow-postgresql

redis:
  existingSecret: airflow-redis
```

### Database-Configs/External-Database

While this chart comes with an embedded [stable/postgresql](https://github.com/helm/charts/tree/master/stable/postgresql), this is NOT SUITABLE for production.
You should make use of an external `mysql` or `postgres` database, for example, one that is managed by your cloud provider.

__Postgres:__

Values for an external Postgres database, with an existing `airflow_cluster1` database:
```yaml
externalDatabase:
  type: postgres
  host: postgres.example.org
  port: 5432
  database: airflow_cluster1
  user: airflow_cluster1
  passwordSecret: "airflow-cluster1-postgres-password"
  passwordSecretKey: "postgresql-password"
```

__MySQL:__

Values for an external MySQL database, with an existing `airflow_cluster1` database:
```yaml
externalDatabase:
  type: mysql
  host: mysql.example.org
  port: 3306
  database: airflow_cluster1
  user: airflow_cluster1
  passwordSecret: "airflow-cluster1-mysql-password"
  passwordSecretKey: "mysql-password"
```

__WARNING:__ Airflow requires that `explicit_defaults_for_timestamp=1` in your MySQL instance, [see here](https://airflow.apache.org/docs/stable/howto/initialize-database.html)

## Other-Configs

### Other-Configs/Local-Binaries

Please note a folder `~/.local/bin` will be automatically created and added to the PATH so that bash operators can use command line tools installed by `pip install --user`.

### Other-Configs/Logging

By default logs from the web server, scheduler, and Celery workers are written within the Docker container's filesystem, therefore any restart of the pod will wipe the logs.
For production purposes, you will likely want to persist the logs externally (e.g. S3), which you have to set up yourself through configuration.

For example, to use a GCS Bucket:
```yaml
airflow:
  config:
    AIRFLOW__CORE__REMOTE_LOGGING: "True"
    AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "gs://<<MY-BUCKET-NAME>>/airflow/logs"
    AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "google_cloud_airflow"
```

__NOTE:__ a connection called `google_cloud_airflow` must exist in airflow, which could be created using the `scheduler.connections` value.

For example, to use a persistent volume:
```yaml
logs:
  persistence:
    enabled: true
```

__NOTE:__ it is also possible to persist logs by mounting a `PersistentVolume` to the log directory (`/opt/airflow/logs` by default) using `airflow.extraVolumes` and `airflow.extraVolumeMounts`.

### Other/Service-Monitor

The service monitor is something introduced by the [CoresOS Prometheus Operator](https://github.com/coreos/prometheus-operator).
To be able to expose metrics to prometheus you need install a plugin, this can be added to the docker image.
A good one is [epoch8/airflow-exporter](https://github.com/epoch8/airflow-exporter), which exposes dag and task based metrics from Airflow.
For more information: see the `serviceMonitor` section of `values.yaml`.

## DAGs

### DAGs/Storage

There are several options for options synchronizing your Airflow DAGs between pods

#### Option 1 - Git-Sync Sidecar (Recommended)

This method places a git sidecar in each worker/scheduler/web Kubernetes Pod, that perpetually syncs your git repo into the dag folder every `dags.git.gitSync.refreshTime` seconds.

For example:
```yaml
dags:
  git:
    url: ssh://git@repo.example.com/example.git
    repoHost: repo.example.com
    secret: airflow-git-keys
    privateKeyName: id_rsa

    gitSync:
      enabled: true
      refreshTime: 60
```

You can create the `dags.git.secret` from your local `~/.ssh` folder using:
```bash
kubectl create secret generic airflow-git-keys \
  --from-file=id_rsa=~/.ssh/id_rsa \
  --from-file=id_rsa.pub=~/.ssh/id_rsa.pub \
  --from-file=known_hosts=~/.ssh/known_hosts
```

__NOTE:__  In the `dags.git.secret` the `known_hosts` file is present to reduce the possibility of a man-in-the-middle attack.
However, if you want to implicitly trust all repo host signatures set `dags.git.sshKeyscan` to `true`.


#### Option 2 - Mount a Shared Persistent Volume

In this method you store your DAGs in a Kubernetes Persistent Volume Claim (PVC), and use some external system to ensure this volume has your latest DAGs.
For example, you could use your CI/CD pipeline system to preform a sync as changes are pushed to a git repo.

Since ALL Pods MUST HAVE the same collection of DAG files, it is recommended to create just one PVC that is shared.
To share a PVC with multiple Pods, the PVC needs to have `accessMode` set to `ReadOnlyMany` or `ReadWriteMany` (Note: different StorageClass support different [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)).
If you are using Kubernetes on a public cloud, a persistent volume controller is likely built in:
[Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/storage-classes.html),
[Azure AKS](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv),
[Google GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes).

For example, to use the storage class called `default`:
```yaml
dags:
  persistence:
    enabled: true
    storageClass: default
    accessMode: ReadOnlyMany
    size: 1Gi
```

#### Option 2a -- Single PVC for DAGs & Logs

You may want to store DAGs and logs on the same volume and configure Airflow to use subdirectories for them.
One reason is that mounting the same volume multiple times with different subPaths can cause problems in Kubernetes, e.g. one of the mounts gets stuck during container initialisation.

Here's an approach that achieves this:
* Configure `airflow.extraVolume` and `airflow.extraVolumeMount` to put a volume at `/opt/airflow/efs`
* Configure `dags.persistence.enabled` and `logs.persistence.enabled` to be `false`
* Configure `dags.path` to be `/opt/airflow/efs/dags`
* Configure `logs.path` to be `/opt/airflow/efs/logs`

__WARNING:__ you must use a PVC which supports `accessMode: ReadWriteMany`

### DAGs/Python requirements.txt

If you need to install Python packages to run your DAGs, you can place a `requirements.txt` file at the root of your `dags.path` folder and set:
```yaml
dags:
  installRequirements: true
```

## Helm Chart Values

Full documentation can be found in the comments of the `values.yaml` file, but a high level overview is provided here.

__Global Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `airflow.image.*` | configs for the docker image of the web/scheduler/worker | `<see values.yaml>` |
| `airflow.executor` | the airflow executor type to use | `CeleryExecutor` |
| `airflow.fernetKey` | the fernet key used to encrypt the connections/variables in the database | `7T512UXSSmBOkpWimFHIVb8jK6lfmSAvx4mO6Arehnc=` |
| `airflow.config` | environment variables for the web/scheduler/worker pods (for airflow configs) | `{}` |
| `airflow.podAnnotations` | extra annotations for the web/scheduler/worker/flower Pods | `{}` |
| `airflow.extraEnv` | extra environment variables for the web/scheduler/worker/flower Pods | `[]` |
| `airflow.extraConfigmapMounts` | extra configMap volumeMounts for the web/scheduler/worker/flower Pods | `[]` |
| `airflow.extraContainers` | extra containers for the web/scheduler/worker Pods | `[]` |
| `airflow.extraPipPackages` | extra pip packages to install in the web/scheduler/worker Pods | `[]` |
| `airflow.extraVolumeMounts` | extra volumeMounts for the web/scheduler/worker Pods | `[]` |
| `airflow.extraVolumes` | extra volumes for the web/scheduler/worker Pods | `[]` |

__Airflow Scheduler values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `scheduler.resources` | resource requests/limits for the scheduler pod | `{}` |
| `scheduler.nodeSelector` | the nodeSelector configs for the scheduler pods | `{}` |
| `scheduler.affinity` | the affinity configs for the scheduler pods | `{}` |
| `scheduler.tolerations` | the toleration configs for the scheduler pods | `[]` |
| `scheduler.labels` | labels for the scheduler Deployment | `{}` |
| `scheduler.podLabels` | Pod labels for the scheduler Deployment | `{}` |
| `scheduler.annotations` | annotations for the scheduler Deployment | `{}` |
| `scheduler.podAnnotations` | Pod Annotations for the scheduler Deployment | `{}` |
| `scheduler.podDisruptionBudget.*` | configs for the PodDisruptionBudget of the scheduler | `<see values.yaml>` |
| `scheduler.connections` | custom airflow connections for the airflow scheduler | `[]` |
| `scheduler.refreshConnections` | if we remove before adding a connection resulting in a refresh | `true` |
| `scheduler.variables` | custom airflow variables for the airflow scheduler | `"{}"` |
| `scheduler.pools` | custom airflow pools for the airflow scheduler | `"{}"` |
| `scheduler.numRuns` | the value of the `airflow --num_runs` parameter used to run the airflow scheduler | `-1` |
| `scheduler.initdb` | if we run `airflow initdb` when the scheduler starts | `true` |
| `scheduler.preinitdb` | if we run `airflow initdb` inside a special initContainer | `false` |
| `scheduler.initialStartupDelay` | the number of seconds to wait (in bash) before starting the scheduler container | `0` |
| `scheduler.extraInitContainers` | extra init containers to run before the scheduler pod | `[]` |

__Airflow WebUI Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `web.resources` | resource requests/limits for the airflow web pods | `{}` |
| `web.replicas` | the number of web Pods to run | `1` |
| `web.nodeSelector` | the number of web Pods to run | `{}` |
| `web.affinity` | the affinity configs for the web Pods | `{}` |
| `web.tolerations` | the toleration configs for the web Pods | `[]` |
| `web.labels` | labels for the web Deployment | `{}` |
| `web.podLabels` | Pod labels for the web Deployment | `{}` |
| `web.annotations` | annotations for the web Deployment | `{}` |
| `web.podAnnotations` | Pod annotations for the web Deployment | `{}` |
| `web.service.*` | configs for the Service of the web pods | `<see values.yaml>` |
| `web.baseUrl` | sets `AIRFLOW__WEBSERVER__BASE_URL` | `http://localhost:8080` |
| `web.serializeDAGs` | sets `AIRFLOW__CORE__STORE_SERIALIZED_DAGS` | `false` |
| `web.extraPipPackages` | extra pip packages to install in the web container | `[]` |
| `web.initialStartupDelay` | the number of seconds to wait (in bash) before starting the web container | `0` |
| `web.minReadySeconds` | the number of seconds to wait before declaring a new Pod available | `5` |
| `web.readinessProbe.*` | configs for the web Service readiness probe | `<see values.yaml>` |
| `web.livenessProbe.*` | configs for the web Service liveness probe | `<see values.yaml>` |
| `web.secretsDir` | the directory in which to mount secrets on web containers | `/var/airflow/secrets` |
| `web.secrets` | secret names which will be mounted as a file at `{web.secretsDir}/<secret_name>` | `[]` |
| `web.secretsMap` | you can use secretsMap to specify a map and all the secrets will be stored within it secrets will be mounted as files at `{web.secretsDir}/<secrets_in_map>`. If you use web.secretsMap, then it overrides `web.secrets`.| `""` |

__Airflow Worker Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `workers.enabled` | if the airflow workers StatefulSet should be deployed | `true` |
| `workers.resources` | resource requests/limits for the airflow worker Pods | `{}` |
| `workers.replicas` | the number of workers Pods to run | `1` |
| `workers.nodeSelector` | the nodeSelector configs for the worker Pods | `{}` |
| `workers.affinity` | the affinity configs for the worker Pods | `{}` |
| `workers.tolerations` | the toleration configs for the worker Pods | `[]` |
| `workers.labels` | labels for the worker StatefulSet | `{}` |
| `workers.podLabels` | Pod labels for the worker StatefulSet | `{}` |
| `workers.annotations` | annotations for the worker StatefulSet | `{}` |
| `workers.podAnnotations` | Pod annotations for the worker StatefulSet | `{}` |
| `workers.autoscaling.*` | configs for the HorizontalPodAutoscaler of the worker Pods | `<see values.yaml>` |
| `workers.initialStartupDelay` | the number of seconds to wait (in bash) before starting each worker container | `0` |
| `workers.celery.*` | configs for the celery worker Pods | `<see values.yaml>` |
| `workers.terminationPeriod` | how many seconds to wait after SIGTERM before SIGKILL of the celery worker | `60` |
| `workers.secretsDir` | directory in which to mount secrets on worker containers | `/var/airflow/secrets` |
| `workers.secrets` | secret names which will be mounted as a file at `{workers.secretsDir}/<secret_name>` | `[]` |
| `workers.secretsMap` | you can use secretsMap to specify a map and all the secrets will be stored within it secrets will be mounted as files at `{workers.secretsDir}/<secrets_in_map>`. If you use workers.secretsMap, then it overrides `workers.secrets`.| `""` |

__Airflow Flower Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `flower.enabled` | if the Flower UI should be deployed | `true` |
| `flower.resources` | resource requests/limits for the flower Pods | `{}` |
| `flower.affinity` | the affinity configs for the flower Pods | `{}` |
| `flower.tolerations` | the toleration configs for the flower Pods | `[]` |
| `flower.labels` | labels for the flower Deployment | `{}` |
| `flower.podLabels` | Pod labels for the flower Deployment | `{}` |
| `flower.annotations` | annotations for the flower Deployment | `{}` |
| `flower.podAnnotations` | Pod annotations for the flower Deployment | `{}` |
| `flower.basicAuthSecret` | the name of a pre-created secret containing the basic authentication value for flower | `""` |
| `flower.basicAuthSecretKey` | the key within `flower.basicAuthSecret` containing the basic authentication string | `""` |
| `flower.urlPrefix` | sets `AIRFLOW__CELERY__FLOWER_URL_PREFIX` | `""` |
| `flower.service.*` | configs for the Service of the flower Pods | `<see values.yaml>` |
| `flower.initialStartupDelay` | the number of seconds to wait (in bash) before starting the flower container | `0` |
| `flower.extraConfigmapMounts` | extra ConfigMaps to mount on the flower Pods | `[]` |

__Airflow Logs Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `logs.path` | the airflow logs folder | `/opt/airflow/logs` |
| `logs.persistence.*` | configs for the logs PVC | `<see values.yaml>` |

__Airflow DAGs Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `dags.path` | the airflow dags folder | `/opt/airflow/dags` |
| `dags.doNotPickle` | whether to disable pickling dags from the scheduler to workers | `false` |
| `dags.installRequirements` | install any Python `requirements.txt` at the root of `dags.path` automatically | `false` |
| `dags.persistence.*` | configs for the dags PVC | `<see values.yaml>` |
| `dags.git.*` | configs for the DAG git repository & sync container | `<see values.yaml>` |
| `dags.initContainer.*` | configs for the git-clone container | `<see values.yaml>` |

__Airflow Ingress Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `ingress.enabled` | if we should deploy Ingress resources | `false` |
| `ingress.web.*` | configs for the Ingress of the web Service | `<see values.yaml>` |
| `ingress.flower.*` | configs for the Ingress of the flower Service | `<see values.yaml>` |

__Airflow Kubernetes Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `rbac.create` | if Kubernetes RBAC resources are created | `true` |
| `serviceAccount.create` | if a Kubernetes ServiceAccount is created | `true` |
| `serviceAccount.name` | the name of the ServiceAccount | `""` |
| `serviceAccount.annotations` | annotations for the ServiceAccount | `{}` |
| `extraManifests` | additional Kubernetes manifests to include with this chart | `[]` |

__Airflow Database (Internal PostgreSQL) Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `postgresql.enabled` | if the `stable/postgresql` chart is used | `true` |
| `postgresql.postgresqlDatabase` | the postgres database to use | `airflow` |
| `postgresql.postgresqlUsername` | the postgres user to create | `postgres` |
| `postgresql.postgresqlPassword` | the postgres user's password | `airflow` |
| `postgresql.existingSecret` | the name of a pre-created secret containing the postgres password | `""` |
| `postgresql.existingSecretKey` | the key within `postgresql.passwordSecret` containing the password string | `postgresql-password` |
| `postgresql.persistence.*` | configs for the PVC of postgresql | `<see values.yaml>` |

__Airflow Database (External) Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `externalDatabase.type` | the type of external database: {mysql,postgres} | `postgres` |
| `externalDatabase.host` | the host of the external database | `localhost` |
| `externalDatabase.port` | the port of the external database | `5432` |
| `externalDatabase.database` | the database/scheme to use within the the external database | `airflow` |
| `externalDatabase.user` | the user of the external database | `airflow` |
| `externalDatabase.passwordSecret` | the name of a pre-created secret containing the external database password | `""` |
| `externalDatabase.passwordSecretKey` | the key within `externalDatabase.passwordSecret` containing the password string | `postgresql-password` |
| `externalDatabase.properties` | the connection properties e.g. "?sslmode=require" | `""` |

__Airflow Redis (Internal) Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `redis.enabled` | if the `stable/redis` chart is used | `true` |
| `redis.password` | the redis password | `airflow` |
| `redis.existingSecret` | the name of a pre-created secret containing the redis password | `""` |
| `redis.existingSecretKey` | the key within `redis.existingSecret` containing the password string | `redis-password` |
| `redis.cluster.*` | configs for redis cluster mode | `<see values.yaml>` |
| `redis.master.*` | configs for the redis master | `<see values.yaml>` |
| `redis.slave.*` | configs for the redis slaves | `<see values.yaml>` |

__Airflow Redis (External) Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `externalRedis.host` | the host of the external redis | `localhost` |
| `externalRedis.port` | the port of the external redis | `6379` |
| `externalRedis.databaseNumber` | the database number to use within the the external redis | `1` |
| `externalRedis.passwordSecret` | the name of a pre-created secret containing the external redis password | `""` |
| `externalRedis.passwordSecretKey` | the key within `externalRedis.passwordSecret` containing the password string | `redis-password` |

__Airflow Prometheus Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `serviceMonitor.enabled` | if the ServiceMonitor resources should be deployed | `false` |
| `serviceMonitor.selector` | labels for ServiceMonitor, so that Prometheus can select it | `{ prometheus: "kube-prometheus" }` |
| `serviceMonitor.path` | the ServiceMonitor web endpoint path | `/admin/metrics` |
| `serviceMonitor.interval` | the ServiceMonitor web endpoint path | `30s` |
| `prometheusRule.enabled` | if the PrometheusRule resources should be deployed | `false` |
| `prometheusRule.additionalLabels` | labels for PrometheusRule, so that Prometheus can select it | `{}` |
| `prometheusRule.groups` | alerting rules for Prometheus | `[]` |