# Spring Cloud Data Flow Chart

[Spring Cloud Data Flow](http://cloud.spring.io/spring-cloud-dataflow/) is a toolkit for building data integration and real-time data processing pipelines.

Pipelines consist of [Spring Boot](http://projects.spring.io/spring-boot/) apps, built using the [Spring Cloud Stream](http://cloud.spring.io/spring-cloud-stream/) or [Spring Cloud Task](http://cloud.spring.io/spring-cloud-task/) microservice frameworks. This makes Spring Cloud Data Flow suitable for a range of data processing use cases, from import/export to event streaming and predictive analytics.

## Chart Details
This chart will provision a fully functional and fully featured Spring Cloud Data Flow installation
that can deploy and manage data processing pipelines in the cluster that it is deployed to.

MySQL is used as the data store for Spring Cloud Data Flow state and either RabbitMQ or Kafka is used as the messaging layer for streaming apps to communicate with one another.

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

RabbitMQ is the default messaging layer, Kafka can be enabled instead by using the following `set` flags to the `helm` command, for example:

`--set kafka.enabled=true,rabbitmq.enabled=false`

Only one messaging layer can be used at a given time. If RabbitMQ and Kafka are enabled, both charts will be installed with RabbitMQ being used in the deployment.

Note that this chart pulls in many different Docker images so can take a while to fully install.

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

| Parameter                         | Description                                        | Default          |
| --------------------------------- | -------------------------------------------------- | ---------------- |
| server.version                    | The version/tag of the Data Flow server            | 2.0.2.RELEASE
| server.imagePullPolicy            | The imagePullPolicy of the Data Flow server        | IfNotPresent
| server.service.type               | The service type for the Data Flow server          | LoadBalancer
| server.platformName               | The name of the configured platform account        | default
| server.service.externalPort       | The external port for the Data Flow server         | 80

### Skipper Server Configuration

| Parameter                          | Description                                       | Default          |
| ---------------------------------- | ------------------------------------------------- | ---------------- |
| skipper.version                    | The version/tag of the Skipper server             | 2.0.1.RELEASE
| skipper.imagePullPolicy            | The imagePullPolicy of the Skipper server         | IfNotPresent
| skipper.platformName               | The name of the configured platform account       | default
| skipper.service.type               | The service type for the Skipper server           | ClusterIP

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

### Kafka Configuration

| Parameter                    | Description                               | Default                                     |
| ---------------------------- | ----------------------------------------- | ------------------------------------------- |
| kafka.enabled                | Enable RabbitMQ as the middleware to use  | false
| kafka.replicas               | The number of Kafka replicas to use       | 1
| kafka.configurationOverrides | Kafka deployment configuration overrides  | replication.factor=1, metrics.enabled=false
| kafka.zookeeper.replicaCount | The number of ZooKeeper replicates to use | 1

### MySQL Configuration

| Parameter                  | Description           | Default                   |
| -------------------------- | --------------------- | ------------------------- |
| mysql.mysqlDatabase        | MySQL database name   | dataflow
