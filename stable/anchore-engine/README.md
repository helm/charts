Anchore Engine Helm Chart
=========================

This chart deploys the Anchore Engine docker container image analysis system. Anchore Engine
requires a PostgreSQL database (>=9.6) which may be handled by the chart or supplied externally,
and executes in a 2-tier architecture with an api/control layer and a batch execution worker pool layer.

See [Anchore Engine](https://github.com/anchore/anchore-engine) for more project details.


Chart Details
-------------

The chart is split into three primary sections: GlobalConfig, CoreConfig, WorkerConfig. As the name implies,
the GlobalConfig is for configuration values that all components require, while the Core and Worker sections are
tier-specific and allow customization for each role.

NOTE: It is highly recommended to set a non-default password when deploying. The admin password is set to a default in the chart. To customize it use:
 `--set globalConfig.users.admin.password=<pass>` or set it in the values.yaml locally.


### Core Role
The core services provide the apis and state management for the system. Core services must be available within the cluster
for use by the workers.
* Core component provides webhook calls to external services for notifications of events:
  * New images added
  * CVE changes in images
  * Policy evaluation state change for an image


### Worker Role
The workers download and analyze images and upload results to the core services. The workers poll the queue service and
do not have their own external api.


Installing the Chart
--------------------

Deploying PostgreSQL as a dependency managed in the chart:

`helm install stable/anchore-engine`


Using and existing/external PostgreSQL service:

`helm install --name <name> --set postgresql.enabled=False stable/anchore-engine`


This installs the chart in cluster-local mode. To expose the service outside the chart there are two options:
1. Use a LoadBalancer service type by setting the `service.type=LoadBalancer` in the values.yaml or on CLI
2. Use an ingress by setting `ingress.enabled=True` in the values.yaml or on CLI



Configuration
-------------

While the configuration options of Anchore Engine are extensive, the options provided by the chart are:

### Exposing the service outside the cluster:

* Use ingress, which enables SSL termination at the LB:
  * ingress.enabled=True (may require service.type=NodePort for some K8s installations e.g. GKE)

* Use a LoadBalancer service type:
  * service.type=LoadBalancer 


### Database

* External Postgres (not managed by helm)
  * postgresql.enabled=False
  * postgresql.externalEndpoint=myserver.mypostgres.com:5432
  * postgresql.postgresUser=username
  * postgresql.postgresPassword=password
  * postgresql.postgresDatabase=db name  
  * globalConfig.dbConfig.ssl=True


### Policy Sync from anchore.io
anchore.io is a hosted version of anchore engine that includes a UI and policy editor. You can configure a local anchore-engine
to download and keep the policy bundles in sync (policies defining how to evaluate images).
Simply provide the credentials for your anchore.io account in the values.yaml or using `--set` on CLI to enable:

* coreConfig.policyBundleSyncEnabled=True
* globalConfig.users.admin.anchoreIOCredentials.useAnonymous=False
* globalConfig.users.admin.anchoreIOCredentials.user=username
* globalConfig.users.admin.anchoreIOCredentials.password=password


Adding Workers
--------------

To set a specific number of workers once the service is running:

If using defaults from the chart:

`helm upgrade --set workerConfig.replicaCount=2 <releasename> stable/anchore-engine`

If customized values, use the local directory for the chart values:

`helm upgrade --set workerConfig.replicaCount=2 <releasename> ./anchore-engine`

To launch with more than one worker you can either modify values.yaml or run with:

`helm install --set workerConfig.replicaCount=2 stable/anchore-engine`
