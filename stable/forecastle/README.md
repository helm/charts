# ![](assets/web/forecastle-round-100px.png) Forecastle

[![Get started with Stakater](https://stakater.github.io/README/stakater-github-banner.png)](http://stakater.com/?utm_source=IngressMonitorController&utm_medium=github)

## Problem(s)

- We would like to have a central place where we can easily look for and access our applications running on Kubernetes.
- We would like to have a tool which can dynamically discover and list the apps running on Kubernetes.
- A launchpad to access developer tools e.g. Jenkins, Nexus, Kibana, Grafana, etc.

## Solution

Forecastle gives you access to a control panel where you can see your running applications and access them on Kubernetes.

![Screenshot](https://raw.githubusercontent.com/stakater/Forecastle/master/assets/forecastle.png)

## Deploying to Kubernetes

You can deploy Forecastle helm charts. By default forecastle watches in all namespaces. If you want forecastle to watch only in specific namespaces, update the `values.yaml` and modify the `config.data.namespaces` key with a list of namespaces which you want Forecastle to watch.

### Helm Charts

If you configured `helm` on your cluster, you can deploy Forecastle via helm chart located using command


```yaml
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/forecastle
```

## Configuration

Forecastle looks for a specific annotations on ingresses.

- Add the following annotations to your ingresses in order to be discovered by forecastle:

|           Annotation           |                                           Description                                           |
|:------------------------------:|:-----------------------------------------------------------------------------------------------:|
| `forecastle.stakater.com/expose` | **[Required]** Add this with value `true` to the ingress of the app you want to show in Forecastle  |
| `forecastle.stakater.com/icon`   | **[Optional]** Icon/Image URL of the application; |
| `forecastle.stakater.com/appName`   | **[Optional]** Name of the application to be shown in forecastle |


## Usage
The following quickstart let's you set up forecastle quickly:

Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| namespace          | Default namespace for forecastle to install                                                | `default`                        | `default`                        |
| replicas          | Number of pods to run at the same time                                                | `1`                        | `1`                        |
| revisionHistoryLimit          | Revision History Limit Replica Sets                                               | `2`                        | `2`                        |
| matchLabels          | Additional match Labels for selector                                                | `{}`                        | `{}`                        |
| deployment.annotations          | Annotations for deployment                                                | `{}`                        | `{}`                        |
| deployment.labels          | Labels for deployment                                                | `provider: stakater`                        | `provider: stakater`                        |
| deployment.image.name          | Image name for forecastle                                                | `stakater/forecastle`                        | `stakater/forecastle`                        |
| deployment.image.tag          | Image tag for forecastle                                                | `1.0.14`                        | `1.0.14`                        |
| deployment.image.pullPolicy          | Image pull policy for forecastle                                                | `IfNotPresent`                        | `IfNotPresent`                        |
| deployment.env.open          | Additional key value pair as environment variables                                                | `STORAGE: local`                        | ``                        |
| deployment.env.secret          | Additional Key value pair as environment variables. It gets the values based on keys from default forecastle secret if any                                               | `BASIC_AUTH_USER: test`                        | ``                        |
| deployment.env.field          | Additional environment variables to expose pod information to containers.                                               | `POD_IP: status.podIP`                        | ``                        |
| config.annotations          | Annotations for configmap                                              | `{}`                        | `{}`                        |
| config.labels          | Labels for configmap                                               | `{}`                        | `{}`                        |
| config.data          | data for configmap                                                | `namespaces:`                        | `namespaces:`                        |
| rbac.enabled          | Option to create rbac                                               | `true`                        | `true`                        |
| rbac.labels          | Additional labels for rbac                                               | `{}`                        | `{}`                        |
| serviceAccount.create          | Option to create serviceAccount                                               | `true`                        | `true`                        |
| serviceAccount.name          | Name of serviceAccount                                               | `forecastle`                        | `forecastle`                        |
| serviceAccount.labels          | Labels of serviceAccount                                               | `{}`                        | `{}`                        |
| service.enabled          | Option to enable service                                               | `true`                        | `true`                        |
| service.annotations          | annotations of service                                               | `{}`                        | `{}`                        |
| service.labels          | labels of service                                               | `expose: "true"`                        | `expose: "true"`                        |
| service.port          | port of service                                               | `80`                        | `80`                        |
| service.targetPort          | targetPort of service                                               | `3000`                        | `3000`                        |
| ingress.enabled          | option to enable ingress                                               | `false`                        | `false`                        |
| ingress.host          | host of ingress                                               | `forcastle.test`                        | `forcastle.test`                        |
| ingress.path          | path of ingress host                                               | `/`                        | `/`                        |
| ingress.tls.enabled          | option to enable tls ingress                                               | `true`                        | `true`                        |
| ingress.tls.secretName          | name of tls ingress secret                                               | `forecastle-test-cert`                        | `forecastle-test-cert`                        |

## Features

- List apps found in all namespaces listed in the configmap
- Search apps
- Grouped apps per namespace

## Help

**Got a question?**
File a GitHub [issue](https://github.com/stakater/Forecastle/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack

Join and talk to us on the #tools-imc channel for discussing Forecastle

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CAN960CTG/)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/Forecastle/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/Forecastle/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

### Why name Forecastle?

Forecastle is the section of the upper deck of a ship located at the bow forward of the foremast. This Forecastle will act as a control panel and show all your running applications on Kubernetes having a particular annotation.

`Forecastle` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://www.stakater.com/projects-overview.html
