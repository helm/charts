# Knative Build

This chart installs Knative components for Build.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Build which provides you a standard, portable, reusable, and performance optimized method for defining and running Knative builds on a kubernetes cluster. Visit [Knative Build](https://github.com/knative/build/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Build:
    - Deployments: controller, webhook
    - Service: controller, webhook
    - ServiceAccount: build-controller

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `build.enabled`                                  | Enable/Disable Knative Build             | `true`    |
| `build.buildController.image`                    | Build Controller Image                   | gcr.io/knative-releases/github.com/knative/build/cmd/controller@sha256:77b883fec7820bd3219c011796f552f15572a037895fbe7a7c78c7328fd96187    |
| `build.buildController.replicas`                 | Number of pods for Build Contoller       |    1      |
| `build.buildWebhook.image`                       | Build Webhook Image                      | gcr.io/knative-releases/github.com/knative/build/cmd/webhook@sha256:488920f65763374a2886860e3b06c3b614ee685b68ec4fdbbcd08d849bb84b71  |
| `build.buildWebhook.replicas`                    | Number of pods for Build Webhook         |    1      |
| `build.credsInit.image`                          | credsInit Image                          |    gcr.io/knative-releases/github.com/knative/build/cmd/creds-init@sha256:ebf58f848c65c50a7158a155db7e0384c3430221564c4bbaf83e8fbde8f756fe    |
| `build.gcsFetcher.image`                         | gcsFetcher Image                          |    gcr.io/cloud-builders/gcs-fetcher      |
| `build.gitInit.image`                            | gitInit Image                            |    gcr.io/knative-releases/github.com/knative/build/cmd/git-init@sha256:09f22919256ba4f7451e4e595227fb852b0a55e5e1e4694cb7df5ba0ad742b23      |
| `build.nop.image`                                | nop Image                                |    gcr.io/knative-releases/github.com/knative/build/cmd/nop@sha256:a318ee728d516ff732e2861c02ddf86197e52c6288049695781acb7710c841d4      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.

