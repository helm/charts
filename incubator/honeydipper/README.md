# Honeydipper

[Honeydipper](https://github.com/honeydipper/honeydipper) is basically, your swiss army knife for systems engineering and operations. An event-driven, policy-based orchestration system, with a pluggable open architecture.

## Introduction

This chart creates a deployment to run the Honeydipper daemon, and exposes a service pointing to the webhook listener.

## Prerequisites

 * Kubernetes 1.10+

## Required Configuration

Honeydipper daemon loads most of the configurations from git repos. To start, a few environment variables are required to bootstrap repo. Below are the settings required.

 * daemon.env.REPO, defaults to `https://github.com/honeydipper/honeydipper-config-essentials.git`

Please refer to [values.yaml](./values.yaml) for detailed example.

## Customization

The following options are supported . See [values.yaml](./values.yaml) for more detailed explanation and examples:

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| daemon.spec | Additional pod spec settings for daemon deploy, can be anything other than `containers`, `nodeSelector`, `affinity`, `tolerations` or `volumes` | |
| daemon.replicaCount | The number of replicas of daemons to start | 1 |
| daemon.image.repository | The docker image for Honeydipper daemon | `honeydipper/honeydipper` |
| daemon.image.tag | The version tag of the docker image to use | `latest` |
| daemon.image.pullPolicy | Pull policy for the docker image | `Always` |
| daemon.args | Honeydipper daemon args, should be a list of Honeydipper daemon services, empty means all | |
| daemon.resources | The pod resource spec, cpu limit, memory limit, etc., as defined in a pod sped | |
| daemon.nodeSelector | A map of node selectors for the pod, as defined in a pod sped | |
| daemon.affinity | A map of affinity settings for the pod, as defined in a pod sped | |
| daemon.tolerations | A list of toleration settings for the pod, as defined in a pod sped | |
| daemon.volumes | A map of volumes for the pod, from volume name to its mount point and a `spec` defining the volume | |
| daemon.env | A map of environment variables from name to its value, the value is either a string or a data structure used for `valueFrom` as defined in a pod spec | |
| drivers.webhook.service.type | The exposed service type for the webhook | `LoadBalancer` |
| drivers.webhook.service.port | The exposed service port for the webhook, needs to match the driver configurations set in the configuration repo | 8080 |
| drivers.webhook.service.nodePort | The exposed service node port for the webhook. If set to 0, Kubernetes will assign a random port. | 0 |
| drivers.webhook.ingress.enabled | Use ingress controller for the webhook service | `false` |
| drivers.webhook.ingress.annotations | If using ingress controllers, specify a map of anotations | |
| drivers.webhook.ingress.path | If using ingress controllers, specify the path mapped to webhook | |
| drivers.webhook.ingress.hosts | If using ingress controllers, specify a list of host names for the webhook | |
| drivers.webhook.ingress.tls | If using ingress controllers, specify the secret that defines the key and certs | |
| drivers.redis.local | Use redis sidecar container for eventbus, this is only useful for testing. In production, multiple replicas of daemon should share the redis server | true |

### Specifying environment

Using command line:

```helm
helm --set daemon.env.REPO=git@github.com:example/example.git,daemon.env.BOOTSTRAP_PATH=/submodule,daemon.env.BRANCH=test_branch install --name test incubator/honeydipper
```

In values file

```yaml
daemon:
  env:
    REPO: git@github.com:example/example.git
    BOOTSTRAP_PATH: /submodule
    BRANCH: test_branch
    SECRET_VARIABLE:
      secretRef:
        name: my-secret
        key: my-key
```

### Mounting volumes

Using values file

```yaml
daemon:
  volumes:
    my-config:
      mountPath: /etc/myconfig/file
      subPath: file
      spec:
        configMap:
          name: my-config
```

## Testing the Deployment

To perform a sanity test (i.e. ensure Honeydipper daemon is running, and when you curl the webhook url `http(s)://your-service-url/health`, you should get a `200` response code.)

 1. Install the chart

```bash
helm install -f test-values.yaml --name trial incubator/honeydipper --debug
```

 2. Run the tests

```bash
helm test trial
```
