# THIS CHART IS DEPRECATED.

# Google Cloud Endpoints

[Google Cloud Endpoints](https://cloud.google.com/endpoints/) is an NGINX-based proxy used to develop, deploy, protect, and monitor APIs running on Google Cloud.

Note: This Helm Chart was created using Google documentation, but it is not an officially supported or maintained Google product.

## TL;DR;

```console
$ helm install stable/gcloud-endpoints --set service=project-id.appspot.com,version=version-number,backend=backendapi.default.svc.cluster.local
```

## Introduction

This chart creates a Google Cloud Endpoints deployment and service on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes cluster on Google Container Engine (GKE)
- API with Open API (swagger) specification yaml file
- Deploy your Open API spec using `gcloud beta service-management deploy swagger.yaml` and note the Project ID and version

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/gcloud-endpoints --set service=project-id.appspot.com,version=version-number,backend=backendapi.svc.cluster.local
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Drupal chart and their default values.

| Parameter                         | Description                            | Default                                                   |
| --------------------------------- | -------------------------------------- | --------------------------------------------------------- |
| `image`                           | Endpoints image                        | `b.gcr.io/endpoints/endpoints-runtime:0.3`                |
| `imagePullPolicy`                 | Image pull policy                      | `Always` if `image` tag is `latest`, else `IfNotPresent`  |
| `backend`                         | Backend API in which to proxy requests |                                                           |
| `service`                         | Name of the Endpoints service          |                                                           |
| `serviceConfigURL`                | URL to fetch the service configuration |                                                           |
| `httpPort`                        | Port to accept HTTP/1.x connections    | `8080` if `http2Port` and `sslPort` are not provided      |
| `http2Port`                       | Port to accept HTTP/2 connections      |                                                           |
| `sslPort`                         | Port to accept HTTPS connections       |                                                           |
| `statusPort`                      | Port for status/health (not exposed)   | `8090`                                                    |
| `version`                         | Config version of Endpoints service    |                                                           |
| `serviceAccountKey`               | Service account key JSON file          |                                                           |
| `nginxConfig`                     | Custom NGINX config file               |                                                           |
| `serviceType`                     | Kubernetes Service type                | `LoadBalancer`                                            |
| `resources`                       | CPU/Memory resource requests/limits    | Memory: `128Mi`, CPU: `100m`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/gcloud-endpoints
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Documentation

- [Generic information about Google Cloud Endpoints](https://cloud.google.com/endpoints/)
- [Google Cloud Endpoints documentation](https://cloud.google.com/endpoints/docs/)
- [Google Cloud Endpoints on Kubernetes](https://cloud.google.com/endpoints/docs/kubernetes-concept)
- [Google Cloud Endpoints as a Docker container](https://cloud.google.com/endpoints/docs/quickstart-compute-engine-docker#running_the_api_and_extensible_service_proxy_in_a_docker_container)
