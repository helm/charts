# ⚠️ THIS CHART HAS MOVED ⚠️

### New location: https://github.com/airflow-helm/charts/tree/main/charts/airflow

---
---

# Airflow Helm Chart

[Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## Installation

__(Helm 2) install the Airflow Helm Chart:__
```bash
helm install stable/airflow \
  --name "airflow" \
  --version "X.X.X" \
  --namespace "airflow" \
  --values ./custom-values.yaml
```

__(Helm 3) install the Airflow Helm Chart:__
```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

helm install "airflow" stable/airflow \
  --version "X.X.X" \
  --namespace "airflow" \
  --values ./custom-values.yaml
```

__Get the status of the Airflow Helm Chart:__
```bash
helm status "airflow"
```

__Uninstall the Airflow Helm Chart:__
```bash
helm delete "airflow"
```

__Run bash commands in the Airflow Webserver Pod:__
```bash
# create an interactive bash session in the Webserver Pod
# use this bash session for commands like: `airflow create_user`
kubectl exec \
  -it \
  --namespace airflow \
  --container airflow-web \
  Deployment/airflow-web \
  /bin/bash
```

---

## Upgrade Steps

Chart version numbers: [Chart.yaml](Chart.yaml) or [Artifact Hub](https://artifacthub.io/packages/helm/helm-stable/airflow)

- [v7.12.X → v7.13.0](UPGRADE.md#v712x--v7130)
- [v7.11.X → v7.12.0](UPGRADE.md#v711x--v7120)
- [v7.10.X → v7.11.0](UPGRADE.md#v710x--v7110)
- [v7.9.X → v7.10.0](UPGRADE.md#v79x--v7100)
- [v7.8.X → v7.9.0](UPGRADE.md#v78x--v790)
- [v7.7.X → v7.8.0](UPGRADE.md#v77x--v780)
- [v7.6.X → v7.7.0](UPGRADE.md#v76x--v770)
- [v7.5.X → v7.6.0](UPGRADE.md#v75x--v760)
- [v7.4.X → v7.5.0](UPGRADE.md#v74x--v750)
- [v7.3.X → v7.4.0](UPGRADE.md#v73x--v740)
- [v7.2.X → v7.3.0](UPGRADE.md#v72x--v730)
- [v7.1.X → v7.2.0](UPGRADE.md#v71x--v720)
- [v7.0.X → v7.1.0](UPGRADE.md#v70x--v710)
- [v6.X.X → v7.0.0](UPGRADE.md#v6xx--v700)

---

## Example Helm Values

Here are some starting points for your `custom-values.yaml`:

| Name | File | Description |
| --- | --- | --- |
| (CeleryExecutor) Minimal | [examples/minikube/custom-values.yaml](examples/minikube/custom-values.yaml) | a __non-production__ starting point |
| (CeleryExecutor) Google Cloud | [examples/google-gke/custom-values.yaml](examples/google-gke/custom-values.yaml) | a __production__ starting point for GKE on Google Cloud |

---

## Docs (Airflow) - Configs

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

## Docs (Airflow) - Connections

### Option 1 - Values.yaml

We expose the `scheduler.connections` value to specify [Airflow Connections](https://airflow.apache.org/docs/stable/concepts.html#connections), which will be automatically imported by the airflow-scheduler when it starts up.

By default, we will delete and re-create connections each time the airflow-scheduler restarts.
(If you want to manually modify a connection in the WebUI, you should disable this behaviour by setting `scheduler.refreshConnections` to `false`)

For example, to add a connection called `my_aws`:
```yaml
scheduler:
  connections:
    - id: my_aws
      type: aws
      extra: |
        {
          "aws_access_key_id": "XXXXXXXX",
          "aws_secret_access_key": "XXXXXXXX",
          "region_name":"eu-central-1"
        }
```

### Option 2 - Kubernetes Secret

If you don't want to store connections in your `values.yaml`, use `scheduler.existingSecretConnections` to specify the name of an existing Kubernetes Secret containing an `add-connections.sh` script.
Note, your script will be run EACH TIME the airflow-scheduler Pod restarts, and `scheduler.connections` will not longer work.

Here is an example Secret you might create:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-airflow-connections
type: Opaque
stringData:
  add-connections.sh: |
    #!/usr/bin/env bash

    # remove any existing connection
    airflow connections --delete \
      --conn_id "my_aws"
  
    # re-add your custom connection
    airflow connections --add \
      --conn_id "my_aws" \
      --conn_type "aws" \
      --conn_extra "{\"aws_access_key_id\": \"XXXXXXXX\", \"aws_secret_access_key\": \"XXXXXXXX\", \"region_name\":\"eu-central-1\"}"
```

## Docs (Airflow) - Variables

We expose the `scheduler.variables` value to specify [Airflow Variables](https://airflow.apache.org/docs/stable/concepts.html#variables), which will be automatically imported by the airflow-scheduler when it starts up.

For example, to specify a variable called `environment`:
```yaml
scheduler:
  variables: |
    { "environment": "dev" }
```

## Docs (Airflow) - Pools

We expose the `scheduler.pools` value to specify [Airflow Pools](https://airflow.apache.org/docs/stable/concepts.html#pools), which will be automatically imported by the Airflow scheduler when it starts up.

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

## Docs (Airflow) - Environment Variables

We expose the `airflow.extraEnv` value to mount extra environment variables, this can be used to pass sensitive configs to Airflow.

For example, passing a Fernet key and LDAP password, (the `airflow` and `ldap` Kubernetes Secrets must already exist):
```yaml
airflow:
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

## Docs (Airflow) - ConfigMaps

We expose the `airflow.extraConfigmapMounts` value to mount extra Kubernetes ConfigMaps.

For example, a `webserver_config.py` file:
```yaml
airflow:
  extraConfigmapMounts:
    - name: my-webserver-config
      mountPath: /opt/airflow/webserver_config.py
      configMap: my-airflow-webserver-config
      readOnly: true
      subPath: webserver_config.py
```

To create the `my-airflow-webserver-config` ConfigMap, you could use:
```bash
kubectl create configmap \
  my-airflow-webserver-config \
  --from-file=webserver_config.py \
  --namespace airflow
```

## Docs (Airflow) - Install Python Packages

We expose the `airflow.extraPipPackages` and `web.extraPipPackages` values to install Python Pip packages, these will work with any pip package that you can install with `pip install XXXX`.

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
    - "apache-airflow[google_auth]==1.10.12"
```

---

## Docs (Kubernetes) - Ingress

This chart provides an optional Kubernetes Ingress resource, for accessing airflow-webserver and airflow-flower outside of the cluster.

### URL Prefix:

If you already have something hosted at the root of your domain, you might want to place airflow under a URL-prefix:
- http://example.com/airflow/
- http://example.com/airflow/flower

In this example, would set these values:
```yaml
web:
  baseUrl: "http://example.com/airflow/"

flower:
  urlPrefix: "/airflow/flower"

ingress:
  web:
    path: "/airflow"

  flower:
    path: "/airflow/flower"
```

### Custom Paths:

We expose the `ingress.web.precedingPaths` and `ingress.web.succeedingPaths` values, which are __before__ and __after__ the default path respectively.

A common use-case is enabling https with the `aws-alb-ingress-controller` [ssl-redirect](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/tasks/ssl_redirect/), which needs a redirect path to be hit before the airflow-webserver one.

You would set the values of `precedingPaths` as the following:
```yaml
ingress:
  web:
    precedingPaths:
      - path: "/*"
        serviceName: "ssl-redirect"
        servicePort: "use-annotation"
```

## Docs (Kubernetes) - Worker Autoscaling

We use a Kubernetes StatefulSet for the Celery workers, this allows the webserver to requests logs from each workers individually, with a fixed DNS name.

Celery workers can be scaled using the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).
To enable autoscaling, you must set `workers.autoscaling.enabled=true`, then provide `workers.autoscaling.maxReplicas`, and `workers.replicas` for the minimum amount.

Assume every task a worker executes consumes approximately `200Mi` memory, that means memory is a good metric for utilisation monitoring.
For a worker pod you can calculate it: `WORKER_CONCURRENCY * 200Mi`, so for `10 tasks` a worker will consume `~2Gi` of memory.

In the following config if a worker consumes `80%` of `2Gi` (which will happen if it runs 9-10 tasks at the same time), an autoscaling event will be triggered, and a new worker will be added.
If you have many tasks in a queue, Kubernetes will keep adding workers until maxReplicas reached, in this case `16`.
```yaml
workers:
  # the initial/minimum number of workers
  replicas: 2

  resources:
    requests:
      memory: "2Gi"

  podDisruptionBudget:
    enabled: true
    ## prevents losing more than 20% of current worker task slots in a voluntary disruption
    maxUnavailable: "20%"

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

    ## wait at most 9min for running tasks to complete before SIGTERM
    ## WARNING: 
    ##  - some cluster-autoscaler (GKE) will not respect graceful 
    ##    termination periods over 10min
    gracefullTermination: true
    gracefullTerminationPeriod: 540

  ## how many seconds (after the 9min) to wait before SIGKILL
  terminationPeriod: 60

dags:
  git:
    gitSync:
      resources:
        requests:
          ## IMPORTANT! for autoscaling to work
          memory: "64Mi"
```

## Docs (Kubernetes) - Worker Secrets

We expose the `workers.secrets` value to allow mounting secrets at `{workers.secretsDir}/<secret-name>` in airflow-worker Pods.

For example, mounting password Secrets:
```yaml
workers:
  secretsDir: /var/airflow/secrets
  secrets:
    - redshift-user
    - redshift-password
    - elasticsearch-user
    - elasticsearch-password
```

With the above configuration, you could read the `redshift-user` password from within a DAG or Python function using:
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

To create the `redshift-user` Secret, you could use:
```bash
kubectl create secret generic \
  redshift-user \
  --from-literal=redshift-user=MY_REDSHIFT_USERNAME \
  --namespace airflow
```

## Docs (Kubernetes) - Additional Manifests

We expose the `extraManifests.[]` value to add custom Kubernetes manifests to the chart.

For example, adding a `BackendConfig` resource for GKE:
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

---

## Docs (Database) - DB Initialization 

If the value `scheduler.initdb` is set to `true` (this is the default), the airflow-scheduler container will run `airflow initdb` as part of its startup script.

If the value `scheduler.preinitdb` is set to `true`, then we ALSO RUN `airflow initdb` in an init-container (retrying 5 times).
This is unusually NOT necessary unless your synced DAGs include custom database hooks that prevent `airflow initdb` from running.

## Docs (Database) - Passwords

PostgreSQL is the default database in this chart, because we use insecure username/password combinations by default, you should create secure credentials before installing the Helm chart.

Example bash command to create the required Kubernetes Secrets:
```bash
# set postgress password
kubectl create secret generic \
  airflow-postgresql \
  --from-literal=postgresql-password=$(openssl rand -base64 13) \
  --namespace airflow

# set redis password
kubectl create secret generic \
  airflow-redis \
  --from-literal=redis-password=$(openssl rand -base64 13) \
  --namespace airflow
```

Example `values.yaml`, to use those secrets:
```yaml
postgresql:
  existingSecret: airflow-postgresql

redis:
  existingSecret: airflow-redis
```

## Docs (Database) - External Database

While this chart comes with an embedded [stable/postgresql](https://github.com/helm/charts/tree/master/stable/postgresql), this is NOT SUITABLE for production.
You should make use of an external `mysql` or `postgres` database, for example, one that is managed by your cloud provider.

### Option 1 - Postgres

Example values for an external Postgres database, with an existing `airflow_cluster1` database:
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

### Option 2 - MySQL

__WARNING:__ Airflow requires that `explicit_defaults_for_timestamp=1` in your MySQL instance, [see here](https://airflow.apache.org/docs/stable/howto/initialize-database.html)

Example values for an external MySQL database, with an existing `airflow_cluster1` database:
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

---

## Docs (Other) - Log Persistence

By default, logs from the airflow-web/scheduler/worker are written within the Docker container's filesystem, therefore any restart of the pod will wipe the logs.
For a production deployment, you will likely want to persist the logs.

### Option 1 - S3/GCS bucket (Recommended)

You must give airflow credentials for it to read/write on the remote bucket, this can be achieved with `AIRFLOW__CORE__REMOTE_LOG_CONN_ID`, or by using something like [Workload Identity (GKE)](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity), or [IAM Roles for Service Accounts (EKS)](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html). 

Example, using `AIRFLOW__CORE__REMOTE_LOG_CONN_ID` (can be used with AWS too):
```yaml
airflow:
  config:
    AIRFLOW__CORE__REMOTE_LOGGING: "True"
    AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "gs://<<MY-BUCKET-NAME>>/airflow/logs"
    AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "google_cloud_airflow"

scheduler:
  connections:
    - id: google_cloud_airflow
      type: google_cloud_platform
      extra: |-
        {
         "extra__google_cloud_platform__num_retries": "5",
         "extra__google_cloud_platform__keyfile_dict": "{...}"
        }
```
    
Example, using [Workload Identity (GKE)](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity):
```yaml
airflow:
  config:
    AIRFLOW__CORE__REMOTE_LOGGING: "True"
    AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "gs://<<MY-BUCKET-NAME>>/airflow/logs"
    AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "google_cloud_default"

serviceAccount:
  annotations:
    iam.gke.io/gcp-service-account: "<<MY-ROLE-NAME>>@<<MY-PROJECT-NAME>>.iam.gserviceaccount.com"
```

Example, using [IAM Roles for Service Accounts (EKS)](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html):
```yaml
airflow:
  config:
    AIRFLOW__CORE__REMOTE_LOGGING: "True"
    AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "s3://<<MY-BUCKET-NAME>>/airflow/logs"
    AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "aws_default"

scheduler:
  securityContext:
    fsGroup: 65534

web:
  securityContext:
    fsGroup: 65534

workers:
  securityContext:
    fsGroup: 65534

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::XXXXXXXXXX:role/<<MY-ROLE-NAME>>"
```

### Option 2 - Kubernetes PVC

```yaml
logs:
  persistence:
    enabled: true
```

## Docs (Other) - Service Monitor

The service monitor is something introduced by the [CoresOS Prometheus Operator](https://github.com/coreos/prometheus-operator).
To be able to expose metrics to prometheus you need install a plugin, this can be added to the docker image.
A good one is [epoch8/airflow-exporter](https://github.com/epoch8/airflow-exporter), which exposes dag and task based metrics from Airflow.

For more information, see the `serviceMonitor` section of `values.yaml`.

---

## Docs (Other) - DAG Storage

### Option 1 - Git-Sync Sidecar (Recommended)

This method places a git sidecar in each worker/scheduler/web Kubernetes Pod, that perpetually syncs your git repo into the dag folder every `dags.git.gitSync.refreshTime` seconds.

__WARNING:__  In the `dags.git.secret` the `known_hosts` file is present to reduce the possibility of a man-in-the-middle attack.
However, if you want to implicitly trust all repo host signatures set `dags.git.sshKeyscan` to `true`.

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
kubectl create secret generic \
  airflow-git-keys \
  --from-file=id_rsa=~/.ssh/id_rsa \
  --from-file=id_rsa.pub=~/.ssh/id_rsa.pub \
  --from-file=known_hosts=~/.ssh/known_hosts \
  --namespace airflow
```

### Option 2 - Mount a Shared Persistent Volume

This method stores your DAGs in a Kubernetes Persistent Volume Claim (PVC), you must use some external system to ensure this volume has your latest DAGs.
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

### Option 2a - Single PVC for DAGs & Logs

You may want to store DAGs and logs on the same volume and configure Airflow to use subdirectories for them.

__WARNING:__ you must use a PVC which supports `accessMode: ReadWriteMany`

Here's an approach that achieves this:
- Configure `airflow.extraVolume` and `airflow.extraVolumeMount` to put a volume at `/opt/airflow/efs`
- Configure `dags.persistence.enabled` and `logs.persistence.enabled` to be `false`
- Configure `dags.path` to be `/opt/airflow/efs/dags`
- Configure `logs.path` to be `/opt/airflow/efs/logs`

## Docs (Other) - requirements.txt

We expose the `dags.installRequirements` value to enable installing any `requirements.txt` found at the root of your `dags.path` folder as airflow-workers start.

__WARNING__: if you update the `requirements.txt`, you will have to restart your airflow-workers for changes to take effect

__NOTE__: you might also want to consider using `airflow.extraPipPackages`

---

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
| `scheduler.resources` | resource requests/limits for the scheduler Pods | `{}` |
| `scheduler.nodeSelector` | the nodeSelector configs for the scheduler Pods | `{}` |
| `scheduler.affinity` | the affinity configs for the scheduler Pods | `{}` |
| `scheduler.tolerations` | the toleration configs for the scheduler Pods | `[]` |
| `scheduler.securityContext` | the security context for the scheduler Pods | `{}` |
| `scheduler.labels` | labels for the scheduler Deployment | `{}` |
| `scheduler.podLabels` | Pod labels for the scheduler Deployment | `{}` |
| `scheduler.annotations` | annotations for the scheduler Deployment | `{}` |
| `scheduler.podAnnotations` | Pod Annotations for the scheduler Deployment | `{}` |
| `scheduler.safeToEvict` | if we should tell Kubernetes Autoscaler that its safe to evict these Pods | `true` |
| `scheduler.podDisruptionBudget.*` | configs for the PodDisruptionBudget of the scheduler | `<see values.yaml>` |
| `scheduler.connections` | custom airflow connections for the airflow scheduler | `[]` |
| `scheduler.refreshConnections` | if `scheduler.connections` are deleted and re-added after each scheduler restart | `true` |
| `scheduler.existingSecretConnections` | the name of an existing Secret containing an `add-connections.sh` script to run on scheduler start | `""` |
| `scheduler.variables` | custom airflow variables for the airflow scheduler | `"{}"` |
| `scheduler.pools` | custom airflow pools for the airflow scheduler | `"{}"` |
| `scheduler.numRuns` | the value of the `airflow --num_runs` parameter used to run the airflow scheduler | `-1` |
| `scheduler.initdb` | if we run `airflow initdb` when the scheduler starts | `true` |
| `scheduler.preinitdb` | if we run `airflow initdb` inside a special initContainer | `false` |
| `scheduler.initialStartupDelay` | the number of seconds to wait (in bash) before starting the scheduler container | `0` |
| `scheduler.livenessProbe.*` | configs for the scheduler liveness probe | `<see values.yaml>` |
| `scheduler.extraInitContainers` | extra init containers to run before the scheduler pod | `[]` |

__Airflow Webserver Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `web.resources` | resource requests/limits for the airflow web pods | `{}` |
| `web.replicas` | the number of web Pods to run | `1` |
| `web.nodeSelector` | the number of web Pods to run | `{}` |
| `web.affinity` | the affinity configs for the web Pods | `{}` |
| `web.tolerations` | the toleration configs for the web Pods | `[]` |
| `web.securityContext` | the security context for the web Pods | `{}` |
| `web.labels` | labels for the web Deployment | `{}` |
| `web.podLabels` | Pod labels for the web Deployment | `{}` |
| `web.annotations` | annotations for the web Deployment | `{}` |
| `web.podAnnotations` | Pod annotations for the web Deployment | `{}` |
| `web.safeToEvict` | if we should tell Kubernetes Autoscaler that its safe to evict these Pods | `true` |
| `web.podDisruptionBudget.*` | configs for the PodDisruptionBudget of the web Deployment | `<see values.yaml>` |
| `web.service.*` | configs for the Service of the web pods | `<see values.yaml>` |
| `web.baseUrl` | sets `AIRFLOW__WEBSERVER__BASE_URL` | `http://localhost:8080` |
| `web.serializeDAGs` | sets `AIRFLOW__CORE__STORE_SERIALIZED_DAGS` | `false` |
| `web.extraPipPackages` | extra pip packages to install in the web container | `[]` |
| `web.initialStartupDelay` | the number of seconds to wait (in bash) before starting the web container | `0` |
| `web.minReadySeconds` | the number of seconds to wait before declaring a new Pod available | `5` |
| `web.readinessProbe.*` | configs for the web Service readiness probe | `<see values.yaml>` |
| `web.livenessProbe.*` | configs for the web Service liveness probe | `<see values.yaml>` |
| `web.secretsDir` | the directory in which to mount secrets on web containers | `/var/airflow/secrets` |
| `web.secrets` | the names of existing Kubernetes Secrets to mount as files at `{workers.secretsDir}/<secret_name>/<keys_in_secret>` | `[]` |
| `web.secretsMap` | the name of an existing Kubernetes Secret to mount as files to `{web.secretsDir}/<keys_in_secret>` | `""` |

__Airflow Worker Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `workers.enabled` | if the airflow workers StatefulSet should be deployed | `true` |
| `workers.resources` | resource requests/limits for the airflow worker Pods | `{}` |
| `workers.replicas` | the number of workers Pods to run | `1` |
| `workers.nodeSelector` | the nodeSelector configs for the worker Pods | `{}` |
| `workers.affinity` | the affinity configs for the worker Pods | `{}` |
| `workers.tolerations` | the toleration configs for the worker Pods | `[]` |
| `workers.securityContext` | the security context for the worker Pods | `{}` |
| `workers.labels` | labels for the worker StatefulSet | `{}` |
| `workers.podLabels` | Pod labels for the worker StatefulSet | `{}` |
| `workers.annotations` | annotations for the worker StatefulSet | `{}` |
| `workers.podAnnotations` | Pod annotations for the worker StatefulSet | `{}` |
| `workers.safeToEvict` | if we should tell Kubernetes Autoscaler that its safe to evict these Pods | `true` |
| `workers.podDisruptionBudget.*` | configs for the PodDisruptionBudget of the worker StatefulSet | `<see values.yaml>` |
| `workers.autoscaling.*` | configs for the HorizontalPodAutoscaler of the worker Pods | `<see values.yaml>` |
| `workers.initialStartupDelay` | the number of seconds to wait (in bash) before starting each worker container | `0` |
| `workers.celery.*` | configs for the celery worker Pods | `<see values.yaml>` |
| `workers.terminationPeriod` | how many seconds to wait after SIGTERM before SIGKILL of the celery worker | `60` |
| `workers.secretsDir` | directory in which to mount secrets on worker containers | `/var/airflow/secrets` |
| `workers.secrets` | the names of existing Kubernetes Secrets to mount as files at `{workers.secretsDir}/<secret_name>/<keys_in_secret>` | `[]` |
| `workers.secretsMap` | the name of an existing Kubernetes Secret to mount as files to `{web.secretsDir}/<keys_in_secret>` | `""` |

__Airflow Flower Values:__

| Parameter | Description | Default |
| --- | --- | --- |
| `flower.enabled` | if the Flower UI should be deployed | `true` |
| `flower.resources` | resource requests/limits for the flower Pods | `{}` |
| `flower.affinity` | the affinity configs for the flower Pods | `{}` |
| `flower.tolerations` | the toleration configs for the flower Pods | `[]` |
| `flower.securityContext` | the security context for the flower Pods | `{}` |
| `flower.labels` | labels for the flower Deployment | `{}` |
| `flower.podLabels` | Pod labels for the flower Deployment | `{}` |
| `flower.annotations` | annotations for the flower Deployment | `{}` |
| `flower.podAnnotations` | Pod annotations for the flower Deployment | `{}` |
| `flower.safeToEvict` | if we should tell Kubernetes Autoscaler that its safe to evict these Pods | `true` |
| `flower.podDisruptionBudget.*` | configs for the PodDisruptionBudget of the flower Deployment | `<see values.yaml>` |
| `flower.oauthDomains` | the value of the flower `--auth` argument | `""` |
| `flower.basicAuthSecret` | the name of a pre-created secret containing the basic authentication value for flower | `""` |
| `flower.basicAuthSecretKey` | the key within `flower.basicAuthSecret` containing the basic authentication string | `""` |
| `flower.urlPrefix` | sets `AIRFLOW__CELERY__FLOWER_URL_PREFIX` | `""` |
| `flower.service.*` | configs for the Service of the flower Pods | `<see values.yaml>` |
| `flower.initialStartupDelay` | the number of seconds to wait (in bash) before starting the flower container | `0` |
| `flower.minReadySeconds` | the number of seconds to wait before declaring a new Pod available | `5` |
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
| `rbac.events` | if the created RBAR role has GET/LIST access to Event resources | `false` |
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
| `postgresql.master.*` | configs for the postgres StatefulSet | `<see values.yaml>` |

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
| `redis.existingSecretPasswordKey` | the key within `redis.existingSecret` containing the password string | `redis-password` |
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
