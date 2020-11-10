# ⚠️ THIS CHART HAS MOVED ⚠️

### New location: https://github.com/airflow-helm/charts/tree/main/charts/airflow

---
---

# Upgrading Steps

## `v7.12.X` → `v7.13.0`

__The following values have been ADDED:__
* `flower.oauthDomains`

## `v7.11.X` → `v7.12.0`

__The following values have been ADDED:__
* `ingress.web.labels`
* `ingress.flower.labels`
* `ingress.flower.precedingPaths`
* `ingress.flower.succeedingPaths`

## `v7.10.X` → `v7.11.0`

__The following IMPROVEMENTS have been made:__
* You can now use `scheduler.existingSecretConnections` with an externally created Secret to store airflow connections. 
  (Rather than storing them in plain-text with `scheduler.connections`)

__The following values have been ADDED:__
* `scheduler.existingSecretConnections`

## `v7.9.X` → `v7.10.0`

__The following IMPROVEMENTS have been made:__
* We now make use of the `_CMD` variables for `AIRFLOW__CORE__SQL_ALCHEMY_CONN_CMD`, `AIRFLOW__CELERY__RESULT_BACKEND_CMD`, and `AIRFLOW__CELERY__BROKER_URL_CMD`:
  * This fixes the Scheduler liveness probe implemented in `7.8.0`
  * This fixes using `kubectl exec` to run commands like `airflow create_user`
* Configs passed with `airflow.config` are now passed as-defined in your `values.yaml`:
  * This fixes an issue where people had to escape `"` characters in JSON strings

## `v7.8.X` → `v7.9.0`

__The following IMPROVEMENTS have been made:__

* You can now give the airflow ServiceAccount GET/LIST on Event resources
    * This is needed for `KubernetesPodOperator(log_events_on_failure=True)`
    * To enable, set `rbac.events` to `true` (Default: `false`)

__The following values have been ADDED:__
* `rbac.events`

## `v7.7.X` → `v7.8.0`

> __WARNING:__ 
>
> If you install many pip packages with: `airflow.extraPipPackages`, `web.extraPipPackages`, or `dags.installRequirements`
> 
> Ensure you set `scheduler.livenessProbe.initialDelaySeconds` to longer than the install time
>

__The following IMPROVEMENTS have been made:__
* Upgraded to Airflow: `1.10.12`
* The scheduler now has a liveness probe which will force the pod to restart if it becomes unhealthy for more than some threshold of time (default: 150sec)
  * NOTE: this is on by default, but can be disabled with: `scheduler.livenessProbe.enabled`

__The following values have been ADDED:__
* `scheduler.livenessProbe.enabled`
* `scheduler.livenessProbe.initialDelaySeconds`
* `scheduler.livenessProbe.periodSeconds`
* `scheduler.livenessProbe.failureThreshold`

## `v7.6.X` → `v7.7.0`

__If you are using an INTERNAL redis database, some configs have changed:__

| 7.6.x | 7.7.x | Notes |
| --- | --- | ---|
| `redis.existingSecretKey` | `redis.existingSecretPasswordKey` | Changed to align with [stable/redis](https://github.com/helm/charts/tree/master/stable/redis) |

## `v7.5.X` → `v7.6.0`

> __WARNING:__ 
>
> We now annotate all pods with `cluster-autoscaler.kubernetes.io/safe-to-evict` by default.
> 
> If you want to disable this:
>  - Set: `flower.safeToEvict`, `scheduler.safeToEvict`, `web.safeToEvict`, `workers.safeToEvict` to `false`
>  - Set: `postgresql.master.podAnnotations`, `redis.master.podAnnotations`, `redis.slave.podAnnotations` to `{}`
>
> Note for GKE:
>  - GKE's cluster-autoscaler will not honor a `gracefulTerminationPeriod` of more than 10min,
>    if your jobs need more than this amount of time to finish, please set `workers.safeToEvict` to `false`
> 

__The following IMPROVEMENTS have been made:__
* The chart YAML has been refactored
* You can now configure `safe-to-evict` annotations (so that pods with emptyDir Volumes can be evicted by cluster-autoscaler)
* You can now create PodDisruptionBudgets for all components: {flower, webserver, worker}
* The chart now forces the correct ports to be used (NOTE: this will not prevent you changing Service/Ingress ports)
* You can now run multiple instances of flower
* You can now specify minReadySeconds for flower

__The following values have CHANGED DEFAULTS:__
* `workers.celery.instances`:
    * Is now `16` by default (letting each worker take 16 tasks)
* `postgresql.master.podAnnotations`:
    * Is now `{"cluster-autoscaler.kubernetes.io/safe-to-evict": "true"}`
* `redis.master.podAnnotations`:
    * Is now `{"cluster-autoscaler.kubernetes.io/safe-to-evict": "true"}`
* `redis.slave.podAnnotations`:
    * Is now `{"cluster-autoscaler.kubernetes.io/safe-to-evict": "true"}`

__The following values have been ADDED:__
* `flower.minReadySeconds`
* `flower.podDisruptionBudget.*`
* `flower.replicas`
* `flower.safeToEvict`
* `scheduler.safeToEvict`
* `web.podDisruptionBudget.*`
* `web.safeToEvict`
* `workers.podDisruptionBudget.*`
* `workers.safeToEvict`

## `v7.4.X` → `v7.5.0`

__The following IMPROVEMENTS have been made:__

* Added an ability to setup external database connection propertites with the value `externalDatabase.properties` for TLS or other advanced parameters

__The following values have been ADDED:__

* `externalDatabase.properties`

## `v7.3.X` → `v7.4.0`

__The following IMPROVEMENTS have been made:__

* Reduced how likely it is for a celery worker to receive SIGKILL with graceful termination enabled.
  New celery worker graceful shutdown lifecycle:
    1. prevent worker accepting new tasks
    2. wait AT MOST `workers.celery.gracefullTerminationPeriod` for tasks to finish
    3. send `SIGTERM` to worker
    4. wait AT MOST `workers.terminationPeriod` for kill to finish
    5. send `SIGKILL` to worker

__The following values have been ADDED:__

* `workers.celery.gracefullTerminationPeriod`:
    * if you currently use a high value of `workers.terminationPeriod`, consider lowering it to `60` and setting a high value for `workers.celery.gracefullTerminationPeriod`

## `v7.2.X` → `v7.3.0`

__The following IMPROVEMENTS have been made:__

* Added an ability to specify a specific port for Flower when using NodePort service type with the value `flower.service.nodePort.http`

__The following values have been ADDED:__

* `flower.service.nodePort.http`

## `v7.1.X` → `v7.2.0`

__The following IMPROVEMENTS have been made:__

* Fixed Flower's liveness probe when Basic Authentication is enabled for Flower.
  You can specify a basic auth value via a Kubernetes Secret using the values `flower.basicAuthSecret` and `flower.basicAuthSecretKey`.
  The secret value will get encoded and included in the liveness probe's header.

__The following values have been ADDED:__

* `flower.basicAuthSecret`
* `flower.basicAuthSecretKey`

## `v7.0.X` → `v7.1.0`

__The following IMPROVEMENTS have been made:__

* We have dramatically reduced the start time of airflow pods.
  This was mostly achieved by removing arbitrary delays in the start commands for airflow pods.
  If you still want these delays, please set the added `*.initialStartupDelay` to non-zero values.
* We have improved support for when `airflow.executor` is set to `KubernetesExecutor`:
    * redis configs/components are no longer deployed
    * we now set `AIRFLOW__KUBERNETES__NAMESPACE`, `AIRFLOW__KUBERNETES__WORKER_SERVICE_ACCOUNT_NAME`, and `AIRFLOW__KUBERNETES__ENV_FROM_CONFIGMAP_REF`
* We have fixed an error caused by including a `'` in your redis/postgres/mysql password.
* We have reverted a change in 7.0.0 which prevented the use of airflow docker images with embedded DAGs. 
  (Just ensure that `dags.initContainer.enabled` and `git.gitSync.enabled` are `false`)
* The `AIRFLOW__CORE__SQL_ALCHEMY_CONN`, `AIRFLOW__CELERY__RESULT_BACKEND`, and `AIRFLOW__CELERY__BROKER_URL` environment variables are now available if you `kubectl exec ...` into airflow Pods.
* We have improved the script used when `workers.celery.gracefullTermination` is `true`.
* We have fixed an error with pools in `scheduler.pools` not being added to the scheduler.
* We have fixed an error with the `scheduler.preinitdb` container not knowing the database connection string.

__The following values have CHANGED DEFAULTS:__

* `airflow.fernetKey`:
    * ~~Is now `""` by default, to enforce that users generate a custom one.~~
      ~~(However, please consider using `airflow.extraEnv` to define it from a pre-created secret)~~
      __(We have undone this change in `7.1.1`, but we still encourage you to set a custom fernetKey!)__
* `dags.installRequirements`:
    * Is now `false` by default, as this was an unintended change with the 7.0.0 upgrade.

__The following values have been ADDED:__

* `scheduler.initialStartupDelay`
* `workers.initialStartupDelay`
* `flower.initialStartupDelay`
* `web.readinessProbe.enabled`
* `web.livenessProbe.enabled`

## `v6.X.X` → `v7.0.0`

> __WARNING:__ 
>
> You MUST stop using images derived from `puckel/docker-airflow` and instead derive from `apache/airflow`

This version updates to Airflow 1.10.10, and moves to the official Airflow Docker images.
Due to the size of these changes, it may be easier to create a new [values.yaml](values.yaml), starting from the one in this repo.

__The official image has a new `AIRFLOW_HOME`, you must change any references in your custom `values.yaml`:__

| Variable | 6.x.x | 7.x.x |
| --- | --- | --- | 
| `AIRFLOW_HOME` | `/usr/local/airflow` | `/opt/airflow` | 
| `dags.path` | `/usr/local/airflow/dags` | `/opt/airflow/dags` | 
| `logs.path` | `/usr/local/airflow/logs` | `/opt/airflow/logs` | 

__These internal mount paths have moved, you must update any references:__

| 6.x.x | 7.x.x |
| --- | --- |
| `/usr/local/git` | `/home/airflow/git` |
| `/usr/local/scripts` | `/home/airflow/scripts` |
| `/usr/local/connections` | `/home/airflow/connections` |
| `/usr/local/variables-pools` | `/home/airflow/variables-pools` |
| `/usr/local/airflow/.local` | `/home/airflow/.local` |

__The following values have been MOVED:__

| 6.x.x | 7.x.x |
| --- | --- |
| `airflow.podDisruptionBudgetEnabled` | `scheduler.podDisruptionBudget.enabled` |
| `airflow.podDisruptionBudget.maxUnavailable` | `scheduler.podDisruptionBudget.maxUnavailable` |
| `airflow.podDisruptionBudget.minAvailable` | `scheduler.podDisruptionBudget.minAvailable` |
| `airflow.webReplicas` | `web.replicas` |
| `airflow.initdb` | `scheduler.initdb` |
| `airflow.preinitdb` | `scheduler.preinitdb` |
| `airflow.extraInitContainers` | `scheduler.extraInitContainers` |
| `airflow.schedulerNumRuns` | `scheduler.numRuns` |
| `airflow.connections` | `scheduler.connections` |
| `airflow.variables` | `scheduler.variables` |
| `airflow.pools` | `scheduler.pools` |
| `airflow.service.*` | `web.service.*` |
| `dags.initContainer.installRequirements` | `dags.installRequirements` |
| `logsPersistence.*` | `logs.persistence.*` |
| `persistence.*` | `dags.persistence.*` |

__If you are using an EXTERNAL postgres database, some configs have changed:__

| 6.x.x | 7.x.x | Notes |
| --- | --- | ---|
| `N/A` | `externalDatabase.type` | can choose `mysql` or `postgres` |
| `postgresql.postgresHost` | `externalDatabase.host` | |
| `postgresql.service.port` | `externalDatabase.port` | we no longer support changing the port of the embedded postgresql chart |
| `postgresql.postgresqlDatabase` | `externalDatabase.database` | |
| `postgresql.postgresqlUsername` | `externalDatabase.user` | |
| `postgresql.postgresqlPassword` | `N/A` | we don't support storing external database passwords in plain text |
| `postgresql.existingSecret` | `externalDatabase.passwordSecret` | |
| `postgresql.existingSecretKey` | `externalDatabase.passwordSecretKey` | |

__If you are using an EXTERNAL redis database, some configs have changed:__

| 6.x.x | 7.x.x | Notes |
| --- | --- | ---|
| `redis.redisHost` | `externalRedis.host` | |
| `redis.master.service.port` | `externalRedis.port` | we no longer support changing the port of the embedded redis chart |
| `redis.password` | `N/A` | we don't support storing external redis passwords in plain text |
| `N/A` | `externalRedis.databaseNumber` | changing the database number was not previously supported |
| `redis.existingSecret` | `externalRedis.passwordSecret` | |
| `redis.existingSecretKey` | `externalRedis.passwordSecretKey` | |


__The following values have been SPLIT:__

* `web.initialDelaySeconds`:
  * --> `web.readinessProbe.initialDelaySeconds`
  * --> `web.livenessProbe.initialDelaySeconds`

__The following values have CHANGED BEHAVIOUR:__

* `airflow.executor`:
  * Previously you specified the executor name without the `Executor` suffix, now you must include it.
  * For example: `Celery` --> `CeleryExecutor`
* `airflow.fernetKey`:
  * Previously if omitted, this would be generated for you, we now have a default value, which we STRONGLY ENCOURAGE you to change.
  * Also note, you should consider using `airflow.extraEnv` to prevent this value being stored in your `values.yaml`
* `dags.installRequirements`:
  * Previously, `dags.installRequirements` only worked if `dags.initContainer.enabled` was true, now it will work regardless of other settings.

__The following values have NEW DEFAULTS:__
* `dags.persistence.accessMode`:
  * `ReadWriteOnce` --> `ReadOnlyMany`
* `logs.persistence.accessMode`:
  * `ReadWriteOnce` --> `ReadWriteMany`

__The following values have been REMOVED:__

* `postgresql.service.port`:
  * As there is no reason to change the port of the embedded postgresql, and we have separated the external database configs. 
* `redis.master.service.port`:
  * As there is no reason to change the port of the embedded redis, and we have separated the external redis configs. 

__The following values have been ADDED:__

* `airflow.extraPipPackages`:
  * Allows extra pip packages to be installed in the airflow-web/scheduler/worker containers.
* `web.extraPipPackages`:
  * Allows extra pip packages to be installed in the airflow-web container only.

__Other changes:__

* Special characters will now be correctly encoded in passwords for postgres/mysql/redis.

## `v5.X.X` → `v6.0.0`

This version updates `postgresql` and `redis` dependencies.

__Thee following values have CHANGED:__

| 5.x.x | 6.x.x | Notes |
| --- | --- | ---|
|`postgresql.postgresHost` |`postgresql.postgresqlHost` | |
|`postgresql.postgresUser` |`postgresql.postgresqlUsername` | |
|`postgresql.postgresPassword` |`postgresql.postgresqlPassword` | |
|`postgresql.postgresDatabase` |`postgresql.postgresqlDatabase` | |
|`postgresql.persistence.accessMode` |`postgresql.persistence.accessModes` | Instead of a single value, now the config accepts an array |
|`redis.master.persistence.accessMode` |`redis.master.persistence.accessModes` | Instead of a single value, now the config accepts an array |

## `v4.X.X` → `v5.0.0`

> __WARNING:__ 
>
> This upgrade will fail if a custom ingress path is set for web and/or flower and `web.baseUrl` and/or `flower.urlPrefix`

This version splits the configuration for webserver and flower web UI from Ingress configurations, for separation of concerns.

__The following values have been ADDED:__

* `web.baseUrl`
* `flower.urlPrefix`

## `v3.X.X` → `v4.0.0`

This version splits the specs for the NodeSelector, Affinity and Toleration features.
Instead of being global, and injected in every component, they are now defined _by component_ to provide more flexibility for your deployments. 
As such, the migration steps are really simple, just ust copy and paste your node/affinity/tolerance definitions in the four airflow components, which are `worker`, `scheduler`, `flower` and `web`. 
The default `values.yaml` file should help you with locating those.
