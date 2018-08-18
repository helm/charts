# Red Hat JBoss A-MQ for OpenShift

JBoss A-MQ 6.3 (with SSL) for OpenShift is a JMS 1.1-compliant messaging system.
It consists of a broker and client-side libraries that enable remote
communication among distributed client applications.

## Prerequisities

* OpenShift Platform 3.6+
* [JBoss Image Streams](https://github.com/jboss-openshift/application-templates/blob/master/jboss-image-streams.json)

## Introduction

This chart defines resources needed to develop a multi-node Red Hat JBoss A-MQ
6.3 based application, including a deployment configuration, using persistence
and secure communication using SSL.

## Generate SSL secrets

For a minimal SSL configuration to allow for connections outside of OpenShift,
A-MQ requires a broker keyStore, a client keyStore, and a client trustStore that
includes the broker keyStore. The broker keyStore is also used to create a
secret for the A-MQ for OpenShift image, which is added to the service account.

The following commands use keytool, a package included with the Java Development
Kit, to generate the necessary certificates and stores:

1. Generate a self-signed certificate for the broker keyStore:

```bash
$ keytool -genkey -alias broker -keyalg RSA -keystore broker.ks
```

2. Export the certificate so that it can be shared with clients:

```bash
$ keytool -export -alias broker -keystore broker.ks -file broker_cert
```

3. Generate a self-signed certificate for the client keyStore:

```bash
$ keytool -genkey -alias client -keyalg RSA -keystore client.ks
```

4. Create a client trustStore that imports the broker certificate:

```bash
$ keytool -import -alias broker -keystore client.ts -file broker_cert
```

## Installing the Chart

```bash
$ helm install --name my-release \
    --set broker.config.ssl.truststore.password=password,broker.config.ssl.keystore.password=password,broker.config.ssl.keystore.body="(cat secrets/broker.ks | base64)"
    .
```

## Configuration

The following tables lists the configurable parameters of the A-MQ chart and
their default values.

| Parameter                               | Description                                                                                                          | Default        |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------- |
| `broker.name`                           | Broker name                                                                                                          | `broker`       |
| `broker.replicas`                       | The number of replicas                                                                                               | `1`            |
| `broker.image.stream`                   | The stream name to pull from                                                                                         | `jboss-amq-63` |
| `broker.image.tag`                      | The image tag to pull                                                                                                | `1.2-6`        |
| `broker.image.pullPolicy`               | Image pull policy                                                                                                    | `Always`       |
| `broker.resources`                      | A-MQ selector requests and limits                                                                                    | `{}`           |
| `broker.selector`                       | A-MQ selector labels                                                                                                 | `{}`           |
| `broker.env`                            | Additional A-MQ environment variables                                                                                | `nil`          |
| `broker.persistence.size`               | The size of the PVC created                                                                                          | `10Gi`         |
| `broker.config.transorts`               | Protocols to configure, separated by commas. Allowed values are: `openwire`, `amqp`, `stomp` and `mqtt`"             | `openwire`     |
| `broker.config.user.username`           | User name for standard broker user. It is required for connecting to the broker                                      | `admin`        |
| `broker.config.user.password`           | Password for standard broker user. It is required for connecting to the broker. If left empty, it will be generated. | `nil`          |
| `broker.config.ssl.truststore.password` | SSL trust store password. It is required                                                                             | `nil`          |
| `broker.config.ssl.keystore.body`       | SSL key store content in base64 format                                                                               | `nil`          |
| `broker.config.ssl.keystore.password`   | SSL key store password. It is required                                                                               | `nil`          |
| `broker.config.queues`                  | Queue names, separated by commas. These queues will be automatically created when the broker starts                  | `nil`          |
| `broker.config.topics`                  | Topic names, separated by commas. These topics will be automatically created when the broker starts                  | `nil`          |
| `broker.config.splitDir`                | Split the data directory for each node in a mesh, this is now the default behaviour                                  | `false`        |
| `broker.config.storageLimit`            | The A-MQ storage usage limit                                                                                         | `10 gb`        |
| `broker.config.queueMemoryLimit`        | The A-MQ storage usage limit                                                                                         | `1mb`          |
| `drainer.name`                          | Drainer name                                                                                                         | `1mb`          |
| `drainer.image.stream`                  | The stream name to pull from                                                                                         | `jboss-amq-63` |
| `drainer.image.tag`                     | The image tag to pull                                                                                                | `1.2-6`        |
| `drainer.image.pullPolicy`              | Image pull policy                                                                                                    | `Always`       |
| `drainer.replicas`                      | The number of replicas                                                                                               | `1`            |
| `drainer.resources`                     | A-MQ selector requests and limits                                                                                    | `{}`           |
| `drainer.selector`                      | A-MQ selector labels                                                                                                 | `{}`           |

## Reference

* [Red Hat JBoss A-MQ for Openshift](https://access.redhat.com/documentation/en-us/red_hat_jboss_a-mq/6.3/html-single/red_hat_jboss_a-mq_for_openshift/#tutorial-deployment-workflow)
