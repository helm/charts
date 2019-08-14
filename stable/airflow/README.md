# Airflow / Celery

[Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and
monitor workflows.


## Install Chart

To install the Airflow Chart into your Kubernetes cluster :

```bash
helm install --namespace "airflow" --name "airflow" stable/airflow
```

After installation succeeds, you can get a status of Chart

```bash
helm status "airflow"
```

If you want to delete your Chart, use this command:

```bash
helm delete  --purge "airflow"
```

### Helm ingresses

The Chart provides ingress configuration to allow customization the installation by adapting
the `values.yaml` depending on your setup.
Please read the comments in the `values.yaml` file for more details on how to configure your reverse
proxy or load balancer.

### Chart Prefix

This Helm automatically prefixes all names using the release name to avoid collisions.

### URL prefix

This chart exposes 2 endpoints:

- Airflow Web UI
- Flower, a debug UI for Celery

Both can be placed either at the root of a domain or at a sub path, for example:

```
http://mycompany.com/airflow/
http://mycompany.com/airflow/flower
```

NOTE: Mounting the Airflow UI under a subpath requires an airflow version >= 2.0.x. For the moment
(June 2018) this is **not** available on official package, you will have to use an image where
airflow has been updated to its current HEAD. You can use the following image:
`stibbons31/docker-airflow-dev:2.0dev`. It is rebase regularly on top of the `puckel/docker-airflow`
image.

Please also note that the Airflow UI and Flower do not behave the same:

- Airflow Web UI behaves transparently, to configure it one just needs to specify the
  `ingress.web.path` value.
- Flower cannot handle this scheme directly and requires a URL rewrite mechanism in front
  of it. In short, it is able to generate the right URLs in the returned HTML file but cannot
  respond to these URL. It is commonly found in software that wasn't intended to work under
  something else than a root URL or localhost port. To use it, see the `values.yaml` for how
  to configure your ingress controller to rewrite the URL (or "strip" the prefix path).

  Note: unreleased Flower (as of June 2018) does not need the prefix strip feature anymore. It is
  integrated in `docker-airflow-dev:2.0dev` image.

### Airflow configuration

`airflow.cfg` configuration can be changed by defining environment variables in the following form:
`AIRFLOW__<section>__<key>`.

See the
[Airflow documentation for more information](http://airflow.readthedocs.io/en/latest/configuration.html?highlight=__CORE__#setting-configuration-options)

This helm chart allows you to add these additional settings with the value key `airflow.config`.
You can also add generic environment variables such as proxy or private pypi:

```yaml
airflow:
  config:
    AIRFLOW__WEBSERVER__EXPOSE_CONFIG: True
    PIP_INDEX_URL: http://pypi.mycompany.com/
    PIP_TRUSTED_HOST: pypi.mycompany.com
    HTTP_PROXY: http://proxy.mycompany.com:1234
    HTTPS_PROXY: http://proxy.mycompany.com:1234
```

If you are using a private image for your dags (see [Embedded Dags](#embedded-dags))
or for use with the KubernetesPodOperator (available in version 1.10.0), then add
an image pull secret to the airflow config:
```yaml
airflow:
  image:
    pullSecret: my-docker-repo-secret
```

### Airflow connections

Connections define how your Airflow instance connects to environment and 3rd party service providers.
This helm chart allows you to define your own connections at the time of Airflow initialization.
For each connection the id and the type has to be defined. All other properties are optional.

Example:
```yaml
airflow:
  connections:
  - id: my_aws
    type: aws
    extra: '{"aws_access_key_id": "**********", "aws_secret_access_key": "***", "region_name":"eu-central-1"}'
```

Note: As connections may require to include sensitive data - the resulting script is stored encrypted in a kubernetes secret and mounted into the airflow scheduler container. It is probably wise not to put connection data in the default values.yaml and instead create an encrypted my-secret-values.yaml. this way it can be decrypted before the installation and passed to helm with -f <my-secret-values.yaml>

#### Airflow variables

Variables are a generic way to store and retrieve arbitrary content or settings as a simple key value store within Airflow.
These variables will be automatically imported by the scheduler when it starts up.

Example:
```yaml
airflow:
  variables: '{ "environment": "dev" }'
```

#### Airflow pools

Some systems can get overwhelmed when too many processes hit them at the same time.
Airflow pools can be used to limit the execution parallelism on arbitrary sets of tasks. For more info see the [airflow
documentation](https://airflow.apache.org/concepts.html#pools).
The feature to import pools has only been added in airflow 1.10.2.
These pools will be automatically imported by the scheduler when it starts up.

Example:
```yaml
airflow:
  pools: '{ "example": { "description": "This is an example of a pool", "slots": 2 } }'
```

### Worker Statefulset

Celery workers uses StatefulSet.
It is used to freeze their DNS using a Kubernetes Headless Service, and allow the webserver to
requests the logs from each workers individually.
This requires to expose a port (8793) and ensure the pod DNS is accessible to the web server pod,
which is why StatefulSet is for.

#### Worker secrets

You can add kubernetes secrets which will be mounted as volumes on the worker nodes
at `secretsDir/<secret name>`.
```yaml
workers:
  secretsDir: /var/airflow/secrets
  secrets:
    - redshift-user
    - redshift-password
    - elasticsearch-user
    - elasticsearch-password
```

With the above configuration, you could read the `redshift-user` password
from within a dag or other function using:
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
$ kubectl create secret generic redshift-user --from-file=redshift-user=~/secrets/redshift-user.txt
```
Where `redshift-user.txt` contains the user secret as a single text string.

### Database connection credentials

In this chart, postgres is used as the database backing Airflow.
Additionally, if you're using the `CeleryExecutor` then redis is used.
By default, insecure username/password combinations are used.

For a real production deployment, it's a good idea to create secure credentials before installing the Helm chart.
For example, from the command line, run:
```bash
kubectl create secret generic airflow-postgres --from-literal=postgres-password=$(openssl rand -base64 13)
kubectl create secret generic airflow-redis --from-literal=redis-password=$(openssl rand -base64 13)
```
Next, you can use those secrets with the Helm chart:
```yaml
# values.yaml

postgres:
  existingSecret: airflow-postgres

redis:
  existingSecret: airflow-redis
```
This approach has the additional advantage of keeping secrets outside of the Helm upgrade process.

### Additional environment variables

It is possible to specify additional environment variables using the same format as in a pod's `.spec.containers.env` definition.
These environment variables will be mounted in the web, scheduler, and worker pods.
You can use this feature to pass additional secret environment variables to Airflow. 

Here is a simple example showing how to pass in a Fernet key and LDAP password.
Of course, for this example to work, both the `airflow` and `ldap` Kubernetes secrets must already exist in the proper namespace; be sure to create those before running Helm.
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

### Local binaries

Please note a folder `~/.local/bin` will be automatically created and added to the PATH so that
Bash operators can use command line tools installed by `pip install --user` for instance.

## Installing dependencies

Add a `requirements.txt` file at the root of your DAG project (`dags.path` entry at `values.yaml`) and they will be automatically installed. That works for both shared persistent volume and init-container deployment strategies (see below).

## DAGs Deployment

Several options are provided for synchronizing your Airflow DAGs.


### Mount a Shared Persistent Volume

You can store your DAG files on an external volume, and mount this volume into the relevant Pods
(scheduler, web, worker). In this scenario, your CI/CD pipeline should update the DAG files in the
PV.

Since all Pods should have the same collection of DAG files, it is recommended to create just one PV
that is shared. This ensures that the Pods are always in sync about the DagBag.

This is controlled by setting `persistence.enabled=true`. You will have to ensure yourself the
PVC are shared properly between your pods:
- If you are on AWS, you can use [Elastic File System (EFS)](https://aws.amazon.com/efs/).
- If you are on Azure, you can use
[Azure File Storage (AFS)](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv).

To share a PV with multiple Pods, the PV needs to have accessMode 'ReadOnlyMany' or 'ReadWriteMany'.

Since you're unlikely to be using init-container with this configuration, you'll need to mount a file to /requirements.txt to get additional Python modules for your DAGs to be installed on container start. Use the extraConfigMapMounts configuration option for this.

### Use init-container

If you enable set `dags.init_container.enabled=true`, the pods will try upon startup to fetch the
git repository defined by `dags.git_repo`, on branch `dags.git_branch` as DAG folder.

This is the easiest way of deploying your DAGs to Airflow.

If you are using a private Git repo, you can set `dags.gitSecret` to the name of a secret you created containing private keys and a `known_hosts` file.

For example, this will create a secret named `my-git-secret` from your ed25519 key and known_hosts file stored in your home directory:  `kubectl create secret generic my-git-secret --from-file=id_ed25519=~/.ssh/id_ed25519 --from-file=known_hosts=~/.ssh/known_hosts --from-file=id_id_ed25519.pub=~/.ssh/id_ed25519.pub`

### Embedded DAGs

If you want more control on the way you deploy your DAGs, you can use embedded DAGs, where DAGs
are burned inside the Docker container deployed as Scheduler and Workers.

Be aware this requires more tooling than using shared PVC, or init-container:

- your CI/CD should be able to build a new docker image each time your DAGs are updated.
- your CI/CD should be able to control the deployment of this new image in your kubernetes cluster

Example of procedure:

- Fork the [puckel/docker-airflow](https://github.com/puckel/docker-airflow) repository
- Place your DAG inside the `dags` folder of the repository, and ensure your Python dependencies
  are well installed (for example consuming a `requirements.txt` in your `Dockerfile`)
- Update the value of `airflow.image` in your `values.yaml` and deploy on your Kubernetes cluster

## Logs

By default (`logsPersistence.enabled: false`) logs from the web server, scheduler, and Celery workers are written to within the Docker container's filesystem.
Therefore, any restart of the pod will wipe the logs.
For production purposes, you will likely want to persist the logs externally (e.g. S3), which you have to set up yourself through configuration.
You can also persist logs using a `PersistentVolume` using `logsPersistence.enabled: true`.
To use an existing volume, pass the name to `logsPersistence.existingClaim`.
Otherwise, a new volume will be created.

Note that it is also possible to persist logs by mounting a `PersistentVolume` to the log directory (`/usr/local/airflow/logs` by default) using `airflow.extraVolumes` and `airflow.extraVolumeMounts`. 

Refer to the `Mount a Shared Persistent Volume` section above for details on using persistent volumes.

## Using one volume for both logs and DAGs

You may want to store DAGs and logs on the same volume and configure Airflow to use subdirectories for them. One reason is that mounting the same volume multiple times with different subPaths can cause problems in Kubernetes, e.g. one of the mounts gets stuck during container initialisation.

Here's an approach that achieves this:

- Configure the `extraVolume` and `extraVolumeMount` arrays to put the (e.g. AWS EFS) volume at /usr/local/airflow/efs
- Configure `persistence.enabled` and `logsPersistence.enabled` to be false
- Configure `dags.path` to be /usr/local/airflow/efs/dags
- Configure `logs.path` to be /usr/local/airflow/efs/logs

## Service monitor

The service monitor is something introduced by the [CoresOS prometheus operator](https://github.com/coreos/prometheus-operator).
To be able to expose metrics to prometheus you need install a plugin, this can be added to the docker image. A good one is: https://github.com/epoch8/airflow-exporter.
This exposes dag and task based metrics from Airflow.
For service monitor configuration see the generic [Helm chart Configuration](#helm-chart-configuration).

## Helm chart Configuration

The following table lists the configurable parameters of the Airflow chart and their default values.

| Parameter                                | Description                                             | Default                   |
|------------------------------------------|---------------------------------------------------------|---------------------------|
| `airflow.fernetKey`                      | Ferney key (see `values.yaml` for example)              | (auto generated)          |
| `airflow.service.type`                   | service type for Airflow UI                             | `ClusterIP`               |
| `airflow.service.annotations`            | (optional) service annotations for Airflow UI           | `{}`                      |
| `airflow.service.externalPort`           | (optional) external port for Airflow UI                 | `8080`                    |
| `airflow.executor`                       | the executor to run                                     | `Celery`                  |
| `airflow.initRetryLoop`                  | max number of retries during container init             |                           |
| `airflow.image.repository`               | Airflow docker image                                    | `puckel/docker-airflow`   |
| `airflow.image.tag`                      | Airflow docker tag                                      | `1.10.2`                  |
| `airflow.image.pullPolicy`               | Image pull policy                                       | `IfNotPresent`            |
| `airflow.image.pullSecret`               | Image pull secret                                       |                           |
| `airflow.schedulerNumRuns`               | -1 to loop indefinitively, 1 to restart after each exec |                           |
| `airflow.webReplicas`                    | how many replicas for web server                        | `1`                       |
| `airflow.config`                         | custom airflow configuration env variables              | `{}`                      |
| `airflow.podDisruptionBudget`            | control pod disruption budget                           | `{'maxUnavailable': 1}`   |
| `airflow.extraEnv`                       | specify additional environment variables to mount       | `{}`                      |
| `airflow.extraConfigmapMounts`           | Additional configMap volume mounts on the airflow pods. | `[]`                      |
| `airflow.podAnnotations`                 | annotations for scheduler, worker and web pods          | `{}`                      |
| `airflow.extraContainers`                | additional containers to run in the scheduler, worker & web pods | `[]`             |
| `airflow.extraVolumeMounts`              | additional volumeMounts to the main container in scheduler, worker & web pods | `[]`|
| `airflow.extraVolumes`                   | additional volumes for the scheduler, worker & web pods | `[]`                      |
| `airflow.initdb`                         | run `airflow initdb` when starting the scheduler        | `true`                    |
| `flower.resources`                       | custom resource configuration for flower pod            | `{}`                      |
| `flower.service.type`                    | service type for Flower UI                              | `ClusterIP`               |
| `flower.service.annotations`             | (optional) service annotations for Flower UI            | `{}`                      |
| `flower.service.externalPort`            | (optional) external port for Flower UI                  | `5555`                    |
| `web.resources`                          | custom resource configuration for web pod               | `{}`                      |
| `web.initialStartupDelay`                | amount of time webserver pod should sleep before initializing webserver             | `60`  |
| `web.initialDelaySeconds`                | initial delay on livenessprobe before checking if webserver is available    | `360` |
| `web.secretsDir`                         | directory in which to mount secrets on webserver nodes  | /var/airflow/secrets      |
| `web.secrets`                            | secrets to mount as volumes on webserver nodes          | []                        |
| `scheduler.resources`                    | custom resource configuration for scheduler pod         | `{}`                      |
| `workers.enabled`                        | enable workers                                          | `true`                    |
| `workers.replicas`                       | number of workers pods to launch                        | `1`                       |
| `workers.resources`                      | custom resource configuration for worker pod            | `{}`                      |
| `workers.celery.instances`               | number of parallel celery tasks per worker              | `1`                       |
| `workers.podAnnotations`                 | annotations for the worker pods                         | `{}`                      |
| `workers.secretsDir`                     | directory in which to mount secrets on worker nodes     | /var/airflow/secrets      |
| `workers.secrets`                        | secrets to mount as volumes on worker nodes             | []                        |
| `nodeSelector`                           | Node labels for pod assignment                          | `{}`                      |
| `affinity`                               | Affinity labels for pod assignment                      | `{}`                      |
| `tolerations`                            | Toleration labels for pod assignment                    | `[]`                      |
| `ingress.enabled`                        | enable ingress                                          | `false`                   |
| `ingress.web.host`                       | hostname for the webserver ui                           | ""                        |
| `ingress.web.path`                       | path of the werbserver ui (read `values.yaml`)          | ``                        |
| `ingress.web.annotations`                | annotations for the web ui ingress                      | `{}`                      |
| `ingress.web.livenessPath`               | path to the web liveness probe                          | `{{ ingress.web.path }}/health` |
| `ingress.web.tls.enabled`                | enables TLS termination at the ingress                  | `false`                   |
| `ingress.web.tls.secretName`             | name of the secret containing the TLS certificate & key | ``                        |
| `ingress.flower.host`                    | hostname for the flower ui                              | ""                        |
| `ingress.flower.path`                    | path of the flower ui (read `values.yaml`)              | ``                        |
| `ingress.flower.livenessPath`            | path to the liveness probe (read `values.yaml`)         | `/`                       |
| `ingress.flower.annotations`             | annotations for the flower ui ingress                   | `{}`                      |
| `ingress.flower.tls.enabled`             | enables TLS termination at the ingress                  | `false`                   |
| `ingress.flower.tls.secretName`          | name of the secret containing the TLS certificate & key | ``                        |
| `persistence.enabled`                    | enable persistence storage for DAGs                     | `false`                   |
| `persistence.existingClaim`              | if using an existing claim, specify the name here       | `nil`                     |
| `persistence.subPath`                    | (optional) relative path on the volume to use for DAGs  | (undefined)               |
| `persistence.storageClass`               | Persistent Volume Storage Class                         | (undefined)               |
| `persistence.accessMode`                 | PVC access mode                                         | `ReadWriteOnce`           |
| `persistence.size`                       | Persistant storage size request                         | `1Gi`                     |
| `logsPersistence.enabled`                | enable persistent storage for logs                      | `false`                   |
| `logsPersistence.existingClaim`          | if using an existing claim, specify the name here       | `nil`                     |
| `logsPersistence.subPath`                | (optional) relative path on the volume to use for logs  | (undefined)               |
| `logsPersistence.storageClass`           | Persistent Volume Storage Class                         | (undefined)               |
| `logsPersistence.accessMode`             | PVC access mode                                         | `ReadWriteOnce`           |
| `logsPersistence.size`                   | Persistant storage size request                         | `1Gi`                     |
| `dags.doNotPickle`                       | should the scheduler disable DAG pickling               | `false`                   |
| `dags.path`                              | mount path for persistent volume                        | `/usr/local/airflow/dags` |
| `dags.initContainer.enabled`             | Fetch the source code when the pods starts              | `false`                   |
| `dags.initContainer.image.repository`    | Init container Docker image.                            | `alpine/git`              |
| `dags.initContainer.image.tag`           | Init container Docker image tag.                        | `1.0.4`                   |
| `dags.initContainer.installRequirements` | auto install requirements.txt deps                      | `true`                    |
| `dags.git.url`                           | url to clone the git repository                         | nil                       |
| `dags.git.ref`                           | branch name, tag or sha1 to reset to                    | `master`                  |
| `dags.git.secret`                        | name of a secret containing an ssh deploy key           | nil                       |
| `logs.path`                              | mount path for logs persistent volume                   | `/usr/local/airflow/logs` |
| `rbac.create`                            | create RBAC resources                                   | `true`                    |
| `serviceAccount.create`                  | create a service account                                | `true`                    |
| `serviceAccount.name`                    | the service account name                                | ``                        |
| `postgresql.enabled`                     | create a postgres server                                | `true`                    |
| `postgresql.existingSecret`              | The name of an existing secret with a key `postgres-password` to use as the password  | `nil` |
| `postgresql.uri`                         | full URL to custom postgres setup                       | (undefined)               |
| `postgresql.postgresHost`                | PostgreSQL Hostname                                     | (undefined)               |
| `postgresql.postgresUser`                | PostgreSQL User                                         | `postgres`                |
| `postgresql.postgresPassword`            | PostgreSQL Password                                     | `airflow`                 |
| `postgresql.postgresDatabase`            | PostgreSQL Database name                                | `airflow`                 |
| `postgresql.persistence.enabled`         | Enable Postgres PVC                                     | `true`                    |
| `postgresql.persistance.storageClass`    | Persistant class                                        | (undefined)               |
| `postgresql.persistance.accessMode`      | Access mode                                             | `ReadWriteOnce`           |
| `redis.enabled`                          | Create a Redis cluster                                  | `true`                    |
| `redis.existingSecret`                   | The name of an existing secret with a key `redis-password` to use as the password  | `nil` |
| `redis.redisHost`                        | Redis Hostname                                          | (undefined)               |
| `redis.password`                         | Redis password                                          | `airflow`                 |
| `redis.master.persistence.enabled`       | Enable Redis PVC                                        | `false`                   |
| `redis.cluster.enabled`                  | enable master-slave cluster                             | `false`                   |
| `serviceMonitor.enabled`                 | enable service monitor                                  | `false`                   |
| `serviceMonitor.interval`                | Interval at which metrics should be scraped             | `30s`                     |
| `serviceMonitor.path`                    | The path at which the metrics should be scraped         | `/admin/metrics`          |
| `serviceMonitor.selector`                | label Selector for Prometheus to find ServiceMonitors   | `prometheus: kube-prometheus` |
| `prometheusRule.enabled`                 | enable prometheus rule                                  | `false`                   |
| `prometheusRule.groups`                  | define alerting rules                                   | `{}`                      |
| `prometheusRule.additionalLabels`        | add additional labels to the prometheus rule            | `{}`                      |


Full and up-to-date documentation can be found in the comments of the `values.yaml` file.

## Upgrading

### To 4.0.0
This version splits the specs for the NodeSelector, Affinity and Toleration features. Instead of being global, and injected in every component, they are now defined _by component_ to provide more flexibility for your deployments. As such, the migration steps are really simple. Just copy and paste your node/affinity/tolerance definitions in the four airflow components, which are `worker`, `scheduler`, `flower` and `web`. The default values file should help you with locating those.

### To 3.0.0
This version introduces a simplified way of managing secrets, including the database credentials to postgres and redis.
With the default settings in prior versions, database credentials were generated and stored in an Airflow-managed Kubernetes secret.
However, these credentials were also stored in postgres- and redis-managed secrets (created by the respective subcharts), leading to duplication.
Moreover, it was tricky to bring your own passwords and to load additional secrets as environment variables.

To deal with these issues, we've removed the Airflow-managed Kubernetes secret (`templates/secret-env.yaml`).
If your deployment was called `airflow`, this upgrade will delete the `airflow-env` secret.
Instead, the pods now source the database secrets from the postgres- and redis-managed secrets, i.e. the postgres password is in the `airflow-postgres` secret.
This upgrade _shouldn't_ break the deployment, but you may need to make some adjustments if you were doing something nonstandard.

For production, it's better create random passwords before installing the Helm chart.
You can use these passwords by specifying the newly added `postgres.existingSecret` and `redis.existingSecret` parameters.

We've also added `airflow.extraEnv`, which provides a flexible way to inject environment variables into your pods.
This parameter is great for things like the Fernet key and LDAP password.

The following parameters are no longer necessary and have been removed: `airflow.defaultSecretsMapping`, `airflow.secretsMapping`, `airflow.existingAirflowSecret`.
If you were using them, you'll have to migrate your settings to `postgres.existingSecret`, `redis.existingSecret`, and `airflow.extraEnv`, which are described in greater depth in the documentation above.

### To 2.8.3+
The parameter `airflow.service.type` no longer applies to the Flower service, but the default of `ClusterIP` has been maintained.  If using a custom values file and have changed the service type, also specify `flower.service.type`.

### To 2.0.0
The parameter `workers.pod.annotations` has been renamed to `workers.podAnnotations`.  If using a
custom values file, rename this parameter.
