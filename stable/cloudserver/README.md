# Cloudserver Helm Chart

[Cloudserver](https://github.com/scality/cloudserver) is an open-source Node.js implementation of the Amazon S3 protocol on the front-end and backend storage capabilities to multiple clouds, including Azure and Google.

## TL;DR;

```console
$ helm install stable/cloudserver
```

## Introduction

This chart bootstraps a [Cloudserver](https://github.com/scality/cloudserver) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/cloudserver
```

The command above deploys Cloudserver on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Cloudserver chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`serviceAccounts.api.create` | If true, create the cloudserver api service account | `true`
`serviceAccounts.api.name` | name of the cloudserver api service account to use or create | `{{ cloudserver.api.fullname }}`
`serviceAccounts.localdata.create` | If true, create the cloudserver localdata service account | `true`
`serviceAccounts.localdata.name` | name of the cloudserver localdata service account to use or create | `{{ cloudserver.localdata.fullname }}`
`image.repository` | cloudserver image repository | `zenko/cloudserver`
`image.tag` | cloudserver image tag | `8.1.5`
`image.pullPolicy` | cloudserver image pullPolicy | `IfNotPresent`
`api.replicaCount` | number of api replicas | `1`
`api.locationConstraints` | cloudserver location constraint configuration | `{}`
`api.credentials.accessKey` | cloudserver api access key | `my-access-key`
`api.credentials.secretKey` | cloudserver api secret key | `my-secret-key`
`api.logLevel` | cloudserver api log level | `info`
`api.env` | additional environmental variables for the cloudserver api | `{}`
`api.proxy.http` | HTTP proxy endpoint | `""`
`api.proxy.https` | HTTPS proxy endpoint | `""`
`api.proxy.caCert` | If true, add an additional trusted certificate | `false`
`api.proxy.no_proxy` | exceptions to proxification | `""`
`api.service.type` | api service type | `ClusterIP`
`api.service.port` | api service port | `80`
`api.service.annotations` | api service annotations | `{}`
`api.endpoint` | allowed virtual hosts for external access | `cloudserver.local`
`api.ingress.enabled` | If true, an ingress will be created for the api | `false`
`api.ingress.annotations` | api ingress annotations | `{}`
`api.ingress.path` | api ingress path | `/`
`api.ingress.hosts` | api ingress hostnames | `[]`
`api.ingress.tls` | api ingress TLS configuration | `[]`
`api.resources` | api resource requests and limits | `{}`
`api.nodeSelector` | api node selector labels for pod assignment | `{}`
`api.tolerations` | api toleration for pod assignment | `[]`
`api.affinity` | api affinity for pod assignment | `{}`
`api.autoscaling.enabled` | If true, create an HPA for the api | `false`
`api.config.minReplicas` | Minimum number of replicas for the HPA | `1`
`api.config.maxReplicas` | Maximum number of replicas for the HPA | `1`
`api.config.targetCPUUtilizationPercentage` | Target CPU utilisation percentage to scale | `80`
`localdata.replicaCount` | localdata replica count | `1`
`localdata.persistentVolume.enabled` | If true, create a Persistent Volume Claim for localdata | `true`
`localdata.persistentVolume.accessModes` | localdata Persistent Volume access modes | `ReadWriteOnce`
`localdata.persistentVolume.annotations` | Annotations for localdata Persistent Volume Claim | `{}`
`localdata.persistentVolume.existingClaim` | localdata Persistent Volume existing claim name | `""`
`localdata.persistentVolume.size` | localdata Persistent Volume size | `1Gi`
`localdata.resources` | local resource requests and limits | `{}`
`mongodb-replicaset.enabled` | If true, install the MongoDB-Replicaset chart | `true`
`mongodb-replicaset.replicas` | Number of replicas in the replica set | `1`
`mongodb-replicaset.replicaSetName` | The name of the replica set | `rs0`
`mongodb-replicaset.securityContext` | Security context for the pod | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`
`redis-ha.enabled` | If true, install the Redis-HA chart | `true`
`redis-ha.replicas` | Number of redis master/slave pods | `1`
`redis-ha.redis.masterGroupName` | Redis convention for naming the cluster group | `cloudserver`
`redis-ha.affinity` | Redis affinity for pod assignment | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/cloudserver --name my-release \
    --set api.replicaCount=5
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/cloudserver --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
