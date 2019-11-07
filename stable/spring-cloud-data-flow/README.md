# Spring Cloud Data Flow Chart

[Spring Cloud Data Flow](http://cloud.spring.io/spring-cloud-dataflow/) is a toolkit for building data integration and real-time data processing pipelines.

Pipelines consist of [Spring Boot](http://projects.spring.io/spring-boot/) apps, built using the [Spring Cloud Stream](http://cloud.spring.io/spring-cloud-stream/) or [Spring Cloud Task](http://cloud.spring.io/spring-cloud-task/) microservice frameworks. This makes Spring Cloud Data Flow suitable for a range of data processing use cases, from import/export to event streaming and predictive analytics.

## Chart Details
This chart will provision a fully functional and fully featured Spring Cloud Data Flow installation
that can deploy and manage data processing pipelines in the cluster that it is deployed to.

Either the default MySQL deployment or an external database can be used as the data store for Spring Cloud Data Flow state and either RabbitMQ or Kafka can be used as the messaging layer for streaming apps to communicate with one another.

For more information on Spring Cloud Data Flow and its capabilities, see it's [documentation](http://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/).

## Prerequisites

Assumes that serviceAccount credentials are available so the deployed Data Flow server can access the API server (Works on GKE and Minikube by default). See [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/spring-cloud-data-flow
```

If you are using a cluster that does not have a load balancer (like Minikube) then you can install using a NodePort:

```bash
$ helm install --name my-release --set server.service.type=NodePort stable/spring-cloud-data-flow
```

### Data Store

By default, MySQL is deployed with this chart. However, if you wish to use an external database, please use the following `set` flags to the `helm` command to disable MySQL deployment, for example:

`--set mysql.enabled=false`

In addition, you are required to set all fields listed in [External Database Configuration](#external-database-configuration).

### Messaging Layer

There are three messaging layers available in this chart:
- RabbitMQ (default)
- RabbitMQ HA
- Kafka

To change the messaging layer to a highly available (HA) version of RabbitMQ, use the following `set` flags to the `helm` command, for example:

`--set rabbitmq-ha.enabled=true,rabbitmq.enabled=false`

Alternatively, to change the messaging layer to Kafka, use the following `set` flags to the `helm` command, for example:

`--set kafka.enabled=true,rabbitmq.enabled=false`

Only one messaging layer can be used at a given time. If RabbitMQ and Kafka are enabled, both charts will be installed with RabbitMQ being used in the deployment.

Note that this chart pulls in many different Docker images so can take a while to fully install.

### Feature Toggles

If you only need to deploy tasks and schedules, streams can be disabled:

`--set features.streaming.enabled=false --set rabbitmq.enabled=false`

If you only need to deploy streams, tasks and schedules can be disabled:

`--set features.batch.enabled=false`

NOTE: Both `features.streaming.enabled` and `features.batch.enabled` should not be set to `false` at the same time.

## Configuration

The following tables list the configurable parameters and their default values.

### RBAC Configuration

| Parameter     | Description                 | Default                   |
| ------------- | --------------------------- | ------------------------- |
| rbac.create   | Create RBAC configurations  | true

### ServiceAccount Configuration

| Parameter             | Description            | Default                     |
| --------------------- | ---------------------- | --------------------------- |
| serviceAccount.create | Create ServiceAccount  | true
| serviceAccount.name   | ServiceAccount name    | (generated if not specified)

### Data Flow Server Configuration

| Parameter                         | Description                                                        | Default          |
| --------------------------------- | ------------------------------------------------------------------ | ---------------- |
| server.version                    | The version/tag of the Data Flow server                            | 2.2.1.RELEASE
| server.imagePullPolicy            | The imagePullPolicy of the Data Flow server                        | IfNotPresent
| server.service.type               | The service type for the Data Flow server                          | LoadBalancer
| server.service.annotations        | Extra annotations for service resource                             | {}
| server.service.externalPort       | The external port for the Data Flow server                         | 80
| server.service.labels             | Extra labels for the service resource                              | {}
| server.platformName               | The name of the configured platform account                        | default
| server.configMap                  | Custom ConfigMap name for Data Flow server configuration           |
| server.trustCerts                 | Trust self signed certs                                            | false

### Skipper Server Configuration

| Parameter                         | Description                                                      | Default          |
| --------------------------------- | ---------------------------------------------------------------- | ---------------- |
| skipper.version                   | The version/tag of the Skipper server                            | 2.1.2.RELEASE
| skipper.imagePullPolicy           | The imagePullPolicy of the Skipper server                        | IfNotPresent
| skipper.platformName              | The name of the configured platform account                      | default
| skipper.service.type              | The service type for the Skipper server                          | ClusterIP
| skipper.service.annotations       | Extra annotations for service resources                          | {}
| skipper.service.labels            | Extra labels for the service resource                            | {}
| skipper.configMap                 | Custom ConfigMap name for Skipper server configuration           |
| skipper.trustCerts                | Trust self signed certs                                          | false

### Spring Cloud Deployer for Kubernetes Configuration

| Parameter                                   | Description                            | Default                   |
| ------------------------------------------- | -------------------------------------- | ------------------------- |
| deployer.resourceLimits.cpu                 | Deployer resource limit for cpu        | 500m
| deployer.resourceLimits.memory              | Deployer resource limit for memory     | 1024Mi
| deployer.readinessProbe.initialDelaySeconds | Deployer readiness probe initial delay | 120
| deployer.livenessProbe.initialDelaySeconds  | Deployer liveness probe initial delay  | 90

### RabbitMQ Configuration

| Parameter                  | Description                              | Default                   |
| -------------------------- | ---------------------------------------- | ------------------------- |
| rabbitmq.enabled           | Enable RabbitMQ as the middleware to use | true
| rabbitmq.rabbitmqUsername  | RabbitMQ user name                       | user

### RabbitMQ HA Configuration

| Parameter                     | Description                                 | Default                   |
| ----------------------------- | ------------------------------------------- | ------------------------- |
| rabbitmq-ha.enabled           | Enable RabbitMQ HA as the middleware to use | false
| rabbitmq-ha.rabbitmqUsername  | RabbitMQ user name                          | user

### Kafka Configuration

| Parameter                    | Description                               | Default                                     |
| ---------------------------- | ----------------------------------------- | ------------------------------------------- |
| kafka.enabled                | Enable RabbitMQ as the middleware to use  | false
| kafka.replicas               | The number of Kafka replicas to use       | 1
| kafka.configurationOverrides | Kafka deployment configuration overrides  | replication.factor=1, metrics.enabled=false
| kafka.zookeeper.replicaCount | The number of ZooKeeper replicates to use | 1

### MySQL Configuration

| Parameter                  | Description                  | Default                   |
| -------------------------- | ---------------------------- | ------------------------- |
| mysql.enabled              | Enable deployment of MySQL   | true
| mysql.mysqlDatabase        | MySQL database name          | dataflow

### External Database Configuration

| Parameter           | Description                    | Default                   |
| ------------------- | ------------------------------ | ------------------------- |
| database.driver     | Database driver                | nil
| database.scheme     | Database scheme                | nil
| database.host       | Database host                  | nil
| database.port       | Database port                  | nil
| database.user       | Database user                  | scdf
| database.password   | Database password              | nil
| database.dataflow   | Database name for SCDF server  | dataflow
| database.skipper    | Database name for SCDF skipper | skipper

### Feature Toggles

| Parameter                    | Description                             | Default                   |
| ---------------------------- | --------------------------------------- | ------------------------- |
| features.streaming.enabled   | Enables or disables streams             | true
| features.batch.enabled       | Enables or disables tasks and schedules | true

