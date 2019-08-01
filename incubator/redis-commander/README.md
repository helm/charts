# Redis Commander - Redis web management tool written in node.js

[Redis Commander](https://joeferner.github.io/redis-commander/) is a node.js web application used to view, edit, and manage a Redis Database.

## Introduction

This chart bootstraps a redis-commander deployment with single pod

## Prerequisites
- Redis deployed on Kubernetes cluster


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/redis-commander
```

The command deploys Redis Commander deployment on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                                    | Description                                       | Default                                |
| -----------------------------------------    | ------------------------------------------------- | -------------------------------------- |
| `redis_hosts`                                | comma separated list of redis hosts               | `redis`

`redis_hosts` is passed as the environment variable `REDIS_HOSTS` to the redis-commander container, possible formats:

hostname

label:hostname

label:hostname:port

label:hostname:port:dbIndex

label:hostname:port:dbIndex:password

see the [Redis Commander DockerHub Page](https://hub.docker.com/r/rediscommander/redis-commander) for more information
