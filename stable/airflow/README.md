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
    AIRFLOW__CORE__EXPOSE_CONFIG: True
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

### Local binaries

Please note a folder `~/.local/bin` will be automatically created and added to the PATH so that
Bash operators can use command line tools installed by `pip install --user` for instance.

## DAGs Deployment

Several options are provided for synchronizing your Airflow DAGs.


### Mount a Shared Persistent Volume

You can store your DAG files on an external volume, and mount this volume into the relevant Pods
(scheduler, web, worker). In this scenario, your CI/CD pipeline should update the DAG files in the
PV.

Since all Pods should have the same collection of DAG files, it is recommended to create just one PV
that is shared. This ensures that the Pods are always in sync about the DagBag.

This is controlled by setting `persistance.enabled=true`. You will have to ensure yourself the
PVC are shared properly between your pods:
- If you are on AWS, you can use [Elastic File System (EFS)](https://aws.amazon.com/efs/).
- If you are on Azure, you can use
[Azure File Storage (AFS)](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv).

To share a PV with multiple Pods, the PV needs to have accessMode 'ReadOnlyMany' or 'ReadWriteMany'.

### Use init-container

If you enable set `dags.init_container.enabled=true`, the pods will try upon startup to fetch the
git repository defined by `dags.git_repo`, on branch `dags.git_branch` as DAG folder.

You can also add a `requirements.txt` file at the root of your DAG project to have other
Python dependencies installed.

This is the easiest way of deploying your DAGs to Airflow.

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

## Helm chart Configuration

The following table lists the configurable parameters of the Airflow chart and their default values.

| Parameter                                | Description                                             | Default                   |
|------------------------------------------|---------------------------------------------------------|---------------------------|
| `airflow.fernetKey`                      | Ferney key (see `values.yaml` for example)              | (auto generated)          |
| `airflow.service.type`                   | services type                                           | `ClusterIP`               |
| `airflow.executor`                       | the executor to run                                     | `Celery`                  |
| `airflow.initRetryLoop`                  | max number of retries during container init             |                           |
| `airflow.image.repository`               | Airflow docker image                                    | `puckel/docker-airflow`   |
| `airflow.image.tag`                      | Airflow docker tag                                      | `1.10.0-4`                |
| `airflow.image.pullPolicy`               | Image pull policy                                       | `IfNotPresent`            |
| `airflow.image.pullSecret`               | Image pull secret                                       |                           |
| `airflow.schedulerNumRuns`               | -1 to loop indefinitively, 1 to restart after each exec |                           |
| `airflow.webReplicas`                    | how many replicas for web server                        | `1`                       |
| `airflow.config`                         | custom airflow configuration env variables              | `{}`                      |
| `airflow.podDisruptionBudget`            | control pod disruption budget                           | `{'maxUnavailable': 1}`   |
| `workers.enabled`                        | enable workers                                          | `true`                    |
| `workers.replicas`                       | number of workers pods to launch                        | `1`                       |
| `workers.resources`                      | custom resource configuration for worker pod            | `{}`                      |
| `workers.celery.instances`               | number of parallel celery tasks per worker              | `1`                       |
| `workers.pod.annotations`                | annotations for the worker pods                         | `{}`                      |
| `workers.secretsDir`                     | directory in which to mount secrets on worker nodes     | /var/airflow/secrets      |
| `workers.secrets`                        | secrets to mount as volumes on worker nodes             | []                        |
| `ingress.enabled`                        | enable ingress                                          | `false`                   |
| `ingress.web.host`                       | hostname for the webserver ui                           | ""                        |
| `ingress.web.path`                       | path of the werbserver ui (read `values.yaml`)          | ``                        |
| `ingress.web.annotations`                | annotations for the web ui ingress                      | `{}`                      |
| `ingress.web.tls.enabled`                | enables TLS termination at the ingress                  | `false`                   |
| `ingress.web.tls.secretName`             | name of the secret containing the TLS certificate & key | ``                        |
| `ingress.flower.host`                    | hostname for the flower ui                              | ""                        |
| `ingress.flower.path`                    | path of the flower ui (read `values.yaml`)              | ``                        |
| `ingress.flower.livenessPath`            | path to the liveness probe (read `values.yaml`)         | `/`                       |
| `ingress.flower.annotations`             | annotations for the web ui ingress                      | `{}`                      |
| `ingress.flower.tls.enabled`             | enables TLS termination at the ingress                  | `false`                   |
| `ingress.flower.tls.secretName`          | name of the secret containing the TLS certificate & key | ``                        |
| `persistance.enabled`                    | enable persistance storage for DAGs                     | `false`                   |
| `persistance.existingClaim`              | if using an existing claim, specify the name here       | `nil`                     |
| `persistance.storageClass`               | Persistent Volume Storage Class                         | (undefined)               |
| `persistance.accessMode`                 | PVC access mode                                         | `ReadWriteOnce`           |
| `persistance.size`                       | Persistant storage size request                         | `1Gi`                     |
| `dags.doNotPickle`                       | should the scheduler disable DAG pickling               | `false`                   |
| `dags.path`                              | mount path for persistent volume                        | `/usr/local/airflow/dags` |
| `dags.initContainer.enabled`             | Fetch the source code when the pods starts              | `false`                   |
| `dags.initContainer.installRequirements` | auto install requirements.txt deps                      | `true`                    |
| `dags.git.url`                           | url to clone the git repository                         | nil                       |
| `dags.git.ref`                           | branch name, tag or sha1 to reset to                    | `master`                  |
| `rbac.create`                            | create RBAC resources                                   | `true`                    |
| `serviceAccount.create`                  | create a service account                                | `true`                    |
| `serviceAccount.name`                    | the service account name                                | ``                        |
| `postgres.enabled`                       | create a postgres server                                | `true`                    |
| `postgres.uri`                           | full URL to custom postgres setup                       | (undefined)               |
| `postgres.portgresHost`                  | PostgreSQL Hostname                                     | (undefined)               |
| `postgres.postgresUser`                  | PostgreSQL User                                         | `postgres`                |
| `postgres.postgresPassword`              | PostgreSQL Password                                     | `airflow`                 |
| `postgres.postgresDatabase`              | PostgreSQL Database name                                | `airflow`                 |
| `postgres.persistence.enabled`           | Enable Postgres PVC                                     | `true`                    |
| `postgres.persistance.storageClass`      | Persistant class                                        | (undefined)               |
| `postgres.persistance.accessMode`        | Access mode                                             | `ReadWriteOnce`           |
| `redis.enabled`                          | Create a Redis cluster                                  | `true`                    |
| `redis.password`                         | Redis password                                          | `airflow`                 |
| `redis.master.persistence.enabled`       | Enable Redis PVC                                        | `false`                   |
| `redis.cluster.enabled`                  | enable master-slave cluster                             | `false`                   |

Full and up-to-date documentation can be found in the comments of the `values.yaml` file.
