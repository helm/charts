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

New to v0.1.8 of the chart: configurable archive drivers.
Archive drivers allow Anchore Engine to store the large analysis results in storage other than the postgresql db (the default).
The currently supported drivers are: S3 and OpenStack's Swift, as well as a localfs option for testing (not for production).


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


Using an existing/external PostgreSQL service:

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

### Archive Driver Configuration (new in v0.1.8 of chart)

The archive subsystem of Anchore Engine is what stores large json documents and can consume quite a lot of storage if
you analyze a lot of images. A general rule for storage provisioning is 10MB per image analyzed, so with thousands of
analyzed images, you may need many gigabytes of storage. The Archive drivers now support other backends than just postgresql,
so you can leverage external and scalable storage systems and keep the postgresql storage usage to a much lower level.

The supported archive drivers are:

* S3 - Any AWS s3-api compatible system (e.g. minio, scality, etc)
* OpenStack Swift 
* Local FS - A local filesystem on the core pod. Does not handle sharding or replication, so generally only for testing.
* DB - the default postgresql backend

Configuring Compression:

The archive system has compression available to help reduce size of objects and storage consumed in exchange for slightly
slower performance and more cpu usage. There are two config values:

To toggle on/off (default is True)
* coreConfig.archive.compression.enabled=True

To set a minimum size for compression to be used (to avoid compressing things too small to be of much benefit, the default is 100):
* coreConfig.archive.compression.min_size_kbytes=100

Using S3, in values.yaml:

```
coreConfig:
  archive:
    driver:
      name: 's3'
      config:
        access_key: 'MY_ACCESS_KEY'
        secret_key: 'MY_SECRET_KEY'
        #iamauto: True
        url: 'https://S3-end-point.example.com'
        region: null
        bucket: 'anchorearchive'
        create_bucket: True
    compression:
    ... # Compression ocnfig here
```

Using Swift:

The swift configuration is basically a pass-thru to the underlying pythonswiftclient so it can take quite a few different
options depending on your swift deployment and config. The best way to configure the swift driver is by using a custom values.yaml

The Swift driver supports three authentication methods: 

* Keystone V3
* Keystone V2
* Legacy (username / password)

To set the config for Keystone V3 in the values.yaml file:
```
coreConfig:
  archive:
    driver:
      name: swift
      config:
        auth_version: '3'
        os_username: 'myusername'
        os_password: 'mypassword'
        os_project_name: myproject
        os_project_domain_name: example.com
        os_auth_url: 'foo.example.com:8000/auth/etc'
        container: 'anchorearchive'
        # Optionally
        create_container: True 
    compression:
    ... # Compression config here
```

To set the config for Keystone V2, in the values.yaml:
```
coreConfig:
  archive:
    driver:    
      name: swift
      config:
        auth_version: '2'
        os_username: 'myusername'
        os_password: 'mypassword'
        os_tenant_name: 'mytenant'
        os_auth_url: 'foo.example.com:8000/auth/etc'
        container: 'anchorearchive'
        # Optionally
        create_container: True
    compression:
    ... # Compression config here

```

To set the config for Legacy username/password, in the values.yaml:
```
coreConfig:
  archive:
    compression:
      enabled: False
      min_size_kbytes: 100
    driver:
      name: swift
      config:
        user: 'user:password'
        auth: 'http://swift.example.com:8080/auth/v1.0'
        key:  'anchore'
        container: 'anchorearchive'
        # Optionally
        create_container: True
    compression:
    ... # Compression config here
```


Using Postgresql:

This is the default and requires very little configuration.

* coreConfig.archive.driver.name=db
* coreconfig.archive.driver.config={}


### Prometheus Metrics (new in v0.1.8 of chart)

Anchore Engine, as of v0.2.1, also supports exporting prometheus metrics form each container.
To enable metrics:

* globalConfig.enableMetrics=True

When enabled, each service provides the metrics over the existing service port so your prometheus deployment will need to
know about each pod and the ports it provides to scrape the metrics.

### Event Notifications (new in v0.1.8 of chart)

Anchore Engine in v0.2.3 introduces a new events subsystem that exposes system-wide events via both a REST api as well
as via webhooks. The webhooks support filtering to ensure only certain event classes result in webhook calls to help limit
the volume of calls if you desire. Events, and all webhooks, are emitted from the core components, so configuration is
done in the coreConfig.

To configure the events:

* coreConfig.events.notification.enabled=True
* coreconfig.events.level=[info, error] (Default is error only)


### Policy Sync from anchore.io

anchore.io is a hosted version of anchore engine that includes a UI and policy editor. You can configure a local anchore-engine
to download and keep the policy bundles in sync (policies defining how to evaluate images).
Simply provide the credentials for your anchore.io account in the values.yaml or using `--set` on CLI to enable:

* coreConfig.policyBundleSyncEnabled=True
* globalConfig.users.admin.anchoreIOCredentials.useAnonymous=False
* globalConfig.users.admin.anchoreIOCredentials.user=username
* globalConfig.users.admin.anchoreIOCredentials.password=password


Adding Core Components
----------------------

As of Anchore Engine v0.2.0, all services can now be scaled-out by increasing the replica counts. The chart now supports
this configuration.

To set a specific number of core service containers:

`helm install stable/anchore-engine --set coreConfig.replicaCount=2`

To update the number in a running configuration:

`helm upgrade --set coreConfig.replicaCount=2 <releasename> stable/anchore-engine <-f values.yaml>`

Adding Workers
--------------

To set a specific number of workers once the service is running:

If using defaults from the chart:

`helm upgrade --set workerConfig.replicaCount=2 <releasename> stable/anchore-engine`

If customized values, use the local directory for the chart values:

`helm upgrade --set workerConfig.replicaCount=2 <releasename> ./anchore-engine`

To launch with more than one worker you can either modify values.yaml or run with:

`helm install --set workerConfig.replicaCount=2 stable/anchore-engine`
