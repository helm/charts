# ![](assets/web/Konfigurator-round-100px.png) Konfigurator

## Problem

Dynamically generate application configuration when Kubernetes resources change.

## Solution

A Kubernetes operator that can dynamically generate app configuration when Kubernetes resources change

## Features

- Render Configurations to
  - ConfigMap
  - Secret
- Support for Go Templating Engine
- Custom helper functions
- Support to watch the following Kubernetes Resources
  - Pods
  - Services
  - Ingresses

## Deploying to Kubernetes

Deploying Konfigurator is a 2 step procedure:

1. Deploy CRD to your cluster
2. Deploy Konfigurator operator

### Helm Charts

if you have configured helm on your cluster, you can add konfigurator to helm from public chart repository and deploy it via helm using below mentioned commands

```yaml
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/konfigurator
```

**NOTE:**
By default helm installs crd when deploying konfigurator. If crd has already installed in your cluster. You can set this `crd.enabled: false` variable before installing the konfigurator. Or you can simply run the following command to install it.

```yaml
helm install stable/konfigurator --set konfigurator.crd.enabled=false
```

Once Konfigurator is running, you can start creating resources supported by it. For details about its custom resources, look [here](https://github.com/stakater/Konfigurator/tree/master/docs/konfigurator-template.md).

## Usage

The following quickstart let's you set up Konfigurator quickly:

Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| crd.enabled          | Option to create crd                                                | `true`                        | `true`                        |
| matchLabels          | Additional match Labels for selector                                                | `{}`                        | `{}`                        |
| deployment.annotations          | Annotations for deployment                                                | `{}`                        | `{}`                        |
| deployment.labels          | Labels for deployment                                                | `provider: stakater`                        | `provider: stakater`                        |
| deployment.image.name          | Image name for Konfigurator                                                | `stakater/konfigurator`                        | `stakater/konfigurator`                        |
| deployment.image.tag          | Image tag for Konfigurator                                                | `0.0.10`                        | `0.0.10`                        |
| deployment.image.pullPolicy          | Image pull policy for Konfigurator                                                | `IfNotPresent`                        | `IfNotPresent`                        |
| deployment.containerPort          | Container port for Konfigurator                                                | `60000`                        | `60000`                        |
| deployment.env.open          | Additional key value pair as environment variables                                                | `STORAGE: local`                        | ``                        |
| deployment.env.secret          | Additional Key value pair as environment variables. It gets the values based on keys from default Konfigurator secret if any                                               | `BASIC_AUTH_USER: test`                        | ``                        |
| deployment.env.field          | Additional environment variables to expose pod information to containers.                                               | `POD_IP: status.podIP`                        | ``                        |
| rbac.enabled          | Option to create rbac                                               | `true`                        | `true`                        |
| rbac.labels          | Additional labels for rbac                                               | `{}`                        | `{}`                        |
| serviceAccount.create          | Option to create serviceAccount                                               | `true`                        | `true`                        |
| serviceAccount.name          | Name of serviceAccount                                               | `konfigurator`                        | `konfigurator`                        |

### CustomResourceDefinition

You can set the following properties in KonfiguratorTemplate to customize your generated resource

| Name                           | Description                                                                                                                                                           | Example                                    |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|
| renderTarget                   | This tells the operator where the underlying rendered config will be stored                                                                                           | `ConfigMap` or `Secret`                    |
| app.name                       | This is the name of your app, it needs to be equal to the name specified in your Deployment, DaemonSet or StatefulSet                                                 | `fluentd`                                  |
| app.Kind                       | This specifies the resource on which your app is running on                                                                                                           | `Deployment`, `DaemonSet` or `StatefulSet` |
| app.volumeMounts               | This is an array which lists where the rendered resource will be mounted                                                                                              |                                            |
| app.volumeMounts.mountPath     | The path inside the container where you want the rendered resource to be mounted                                                                                      | `/home/app/config/`                        |
| app.volumeMounts.containerName | The container name inside which the resource will be mounted                                                                                                          | `my-container`                             |
| app.templates                  | A list of key value pairs. All the configuration templates go inside this property. You can paste your static config as is inside this block and it will work as well | `app.config: someConfig`                   |

## Example

[Here](https://github.com/stakater/Konfigurator/blob/master/examples/parsing-multiline-logs-with-fluentd.md) is the detailed example that shows how konfigurator dynamically generates fluentd configuration.

## Help

**Got a question?**
File a GitHub [issue](https://github.com/stakater/Konfigurator/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack

Join and talk to us on Slack for discussing Konfigurator

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CC8R7L8KG/)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/Konfigurator/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/Konfigurator/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

`Konfigurator` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://github.com/stakater/
