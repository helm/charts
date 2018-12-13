# ![](assets/web/Konfigurator-round-100px.png) Konfigurator

## Problem

Dynamically generating app configuration when kubernetes resources change.

## Solution

A kubernetes operator that can dynamically generate app configuration when kubernetes resources change

## Features

- Render Configurations to
  - ConfigMap
  - Secret
- Support for GO Templating Engine
- Custom helper functions
- Support to watch the following Kubernetes Resources
  - Pods
  - Services
  - Ingresses

## Deploying to Kubernetes

Deploying Konfigurator is a 2 step procedure:

1. Deploy CRD to your cluster
2. Deploy Konfigurator operator

So first apply the CRD manifest by running the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/stakater/Konfigurator/master/deploy/crd.yaml
```

Once the CRD is installed, you can deploy the operator on your kubernetes cluster via any of the following methods.

### Helm Charts

if you have configured helm on your cluster, you can add konfigurator to helm from public chart repository and deploy it via helm using below mentioned commands

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/konfigurator
```

Once Konfigurator is running, you can start creating resources supported by it. For details about its custom resources, look [here](https://github.com/stakater/Konfigurator/tree/master/docs/konfigurator-template.md).

## Usage

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
