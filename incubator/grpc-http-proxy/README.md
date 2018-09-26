# grpc-http-proxy

[grpc-http-proxy](https://github.com/mercari/grpc-http-proxy) is a reverse proxy which converts JSON HTTP requests to gRPC calls without much configuration. It is designed to run in a Kubernetes cluster, and uses the Kubernetes API to find in-cluster servers that provide the desired gRPC service using custom Kubernetes annotations.

## Pre Requisites

- Kubernetes 1.9+

## Install

To install the chart with the release name `grpc-http-proxy`:

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
$ helm install --name grpc-http-proxy --set accessToken answerIs42 incubator/grpc-http-proxy
```

`accessToken` need to be configured for authentication. Proxy server will expect this token in HTTP Header `X-Access-Token`

## Uninstall

To uninstall the chart:

```console
helm delete grpc-http-proxy --purge
```

## Configuration

The following table lists the configurable parameters of the cert-manager chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount`  | Number of grpc-http-proxy replicas  | `1` |
| `image.repository` | Image repository | `mercari/grpc-http-proxy` |
| `image.tag` | Image tag | `v0.1.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `accessToken` | Access token for authentication. |  |
| `logLevel` | Log Level. | `INFO` |
| `annotations` | Extra annotations to add on deployment|  |
| `service.type` | Kubernetes Service type. | `NodePort` |
| `service.port` | Port at which Service is listening. | `3000` |
| `service.annotations` | Extra annotations to add on Service |  |
| `resources` | CPU/memory resource requests/limits | |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml .
```
