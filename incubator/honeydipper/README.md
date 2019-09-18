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
| daemon.dnsConfig | dnsConfig specifies the DNS parameters of the pod. Parameters specified here will be merged to the generated DNS configuration based on DNSPolicy | |
| daemon.serviceAccountName | name of the ServiceAccount to use to run this pod, More info: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ | |
| daemon.replicaCount | The number of replicas of daemons to start | 1 |
| daemon.image.repository | The docker image for Honeydipper daemon | `honeydipper/honeydipper` |
| daemon.image.tag | The version tag of the docker image to use | `latest` |
| daemon.image.pullPolicy | Pull policy for the docker image | `Always` |
| daemon.args | Honeydipper daemon args, should be a list of Honeydipper daemon services, empty means all | |
| daemon.resources | The pod resource spec, cpu limit, memory limit, etc., as defined in a pod sped | |
| daemon.nodeSelector | A map of node selectors for the pod, as defined in a pod sped | |
| daemon.affinity | A map of affinity settings for the pod, as defined in a pod sped | |
| daemon.tolerations | A list of toleration settings for the pod, as defined in a pod sped | |
| daemon.extraVolumes | A list of volumns to be added to the pod | |
| daemon.extraVolumeMounts | A list of volumns to be mounted to main daemon container | |
| daemon.env | A list of environment variables to be added to the main daemon container | |
| drivers.webhook.service.type | The exposed service type for the webhook | `LoadBalancer` |
| drivers.webhook.service.port | The exposed service port for the webhook, needs to match the driver configurations set in the configuration repo | 8080 |
| drivers.webhook.service.nodePort | The exposed service node port for the webhook. If set to 0, Kubernetes will assign a random port. | 0 |
| drivers.webhook.ingress.enabled | Use ingress controller for the webhook service | `false` |
| drivers.webhook.ingress.annotations | If using ingress controllers, specify a map of anotations | |
| drivers.webhook.ingress.path | If using ingress controllers, specify the path mapped to webhook | |
| drivers.webhook.ingress.hosts | If using ingress controllers, specify a list of host names for the webhook | |
| drivers.webhook.ingress.tls | If using ingress controllers, specify the secret that defines the key and certs | |
| drivers.redis.local | Use redis sidecar container for eventbus, this is only useful for testing. In production, multiple replicas of daemon should share the redis server | true |
| drivers.redis.image.repository | When using redis sidecar container for eventbus, this is used to specify the image repository | redis |
| drivers.redis.image.tag | When using redis sidecar container for eventbus, this is used to specify the image tag | 5 |

### Specifying environment

Using command line:

```helm
helm -f values.yaml install --name test incubator/honeydipper
```

In values file

```yaml
daemon:
  env:
    - name: REPO
      value: git@github.com:example/example.git
    - name: BOOTSTRAP_PATH
      value: /submodule
    - name: BRANCH
      value: test_branch
    - name: SECRET_VARIABLE
      valueFrom:
        secretRef:
          name: my-secret
          key: my-key
```

### Mounting volumes

Using values file

```yaml
daemon:
  extraVolumeMounts:
    - name: my-config
      mountPath: /etc/myconfig/file
      subPath: file
  extraVolumes:
    - name: my-config
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
