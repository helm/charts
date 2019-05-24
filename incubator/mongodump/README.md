# mongodump

mongodump is a tool for creating backups of Mongodb.

## TL;DR;

```console
$ helm install incubator/mongodump \
  --set mongodb.host=mongo,mongodb.port=2017
```

## Introduction

This chart use a cronjob to backup a Mongodb.

## Prerequisites

-   Kubernetes 1.8

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/mongodump \
  --set mongodb.host=mongo,mongodb.port=2017
```

This command will craete a cronjob to backup Mongodb once a day.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the mongodump chart and their default values.

| Parameter                                     | Description                                                  | Default            |
| --------------------------------------------- | ------------------------------------------------------------ | ------------------ |
| image.repository                              | Name of image to use                                         | mongo              |
| image.tag                                     | Version of image to use                                      | "4.1.11"           |
| image.pullPolicy                              | Pull Policy to use for image                                 | IfNotPresent       |
| mongodb.host                                  | mongodb host to backup                                       | 127.0.0.1          |
| mongodb.port                                  | mongodb port                                                 | 27017              |
| mongodb.keepdays                              | backups reserve days                                         | 3                  |
| schedule                                      | crontab schedule to run on. set as `now` to run as a one time job | "0/3 \* \* \* \*"  |
| successfulJobsHistoryLimit                    | number of successful jobs to remember                        | 5                  |
| failedJobsHistoryLimit                        | number of failed jobs to remember                            | 5                  |
| persistence.size                              | size of PVC to create                                        | 8Gi                |
| persistence.accessMode                        | accessMode to use for PVC                                    | ReadWriteOnce      |
| persistence.storageClass                      | storage class to use for PVC                                 |                    |
| persistence.reclaimPolicy                     | used PV reclaim policy                                       | "delete"           |
| resources                                     | resource definitions                                         | {}                 |
