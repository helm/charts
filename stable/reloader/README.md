# ![](https://raw.githubusercontent.com/stakater/Reloader/master/assets/web/reloader-round-100px.png) RELOADER

A Kubernetes controller to watch changes in ConfigMap and Secrets and then restart pods for Deployment, StatefulSet and DaemonSet

[![Get started with Stakater](https://stakater.github.io/README/stakater-github-banner.png)](http://stakater.com/?utm_source=Reloader&utm_medium=github)

## Problem

We would like to watch if some change happens in `ConfigMap` and/or `Secret`; then perform a rolling upgrade on relevant `Deployment`, `Deamonset` and `Statefulset`

## Solution

Reloader can watch changes in `ConfigMap` and `Secret` and do rolling upgrades on Pods with their associated `Deployments`, `Deamonsets` and `Statefulsets`.

## How to use Reloader

### Configmap

For a `Deployment` called `foo` have a `ConfigMap` called `foo-configmap`. Then add this annotation to main metadata of your `Deployment`

```yaml
kind: Deployment
metadata:
  annotations:
    configmap.reloader.stakater.com/reload: "foo-configmap"
spec:
  template:
    metadata:
```

Use comma separated list to define multiple configmaps.

```yaml
kind: Deployment
metadata:
  annotations:
    configmap.reloader.stakater.com/reload: "foo-configmap,bar-configmap,baz-configmap"
spec:
  template:
    metadata:
```

### Secret

For a `Deployment` called `foo` have a `Secret` called `foo-secret`. Then add this annotation to main metadata of  your `Deployment`

```yaml
kind: Deployment
metadata:
  annotations:
    secret.reloader.stakater.com/reload: "foo-secret"
spec:
  template:
    metadata:
```

Use comma separated list to define multiple secrets.

```yaml
kind: Deployment
metadata:
  annotations:
    secret.reloader.stakater.com/reload: "foo-secret,bar-secret,baz-secret"
spec:
  template:
    metadata:
```

## Usage

The following quickstart let's you set up Reloader quickly:

Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| watchGlobally          | Option to watch configmap and secrets in all namespaces                                                | `true`                        | `true`                        |
| matchLabels          | Additional match Labels for selector                                                | `{}`                        | `{}`                        |
| deployment.annotations          | Annotations for deployment                                                | `{}`                        | `{}`                        |
| deployment.labels          | Labels for deployment                                                | `provider`                        | `provider`                        |
| deployment.image.name          | Image name for reloader                                                | `stakater/reloader`                        | `stakater/reloader`                        |
| deployment.image.tag          | Image tag for reloader                                                | `v0.0.29`                        | `v0.0.29`                        |
| deployment.image.pullPolicy          | Image pull policy for reloader                                                | `IfNotPresent`                        | `IfNotPresent`                        |
| deployment.env.open          | Additional key value pair as environment variables                                                | `STORAGE: local`                        | ``                        |
| deployment.env.secret          | Additional Key value pair as environment variables. It gets the values based on keys from default reloader secret if any                                               | `BASIC_AUTH_USER: test`                        | ``                        |
| deployment.env.field          | Additional environment variables to expose pod information to containers.                                               | `POD_IP: status.podIP`                        | ``                        |
| rbac.enabled          | Option to create rbac                                               | `true`                        | `true`                        |
| rbac.labels          | Additional labels for rbac                                               | `{}`                        | `{}`                        |
| serviceAccount.create          | Option to create serviceAccount                                               | `true`                        | `true`                        |
| serviceAccount.name          | Name of serviceAccount                                               | `reloader`                        | `reloader`                        |
| custom_annotations          | Optional flags to pass to the Reloader entrypoint           | `{}`          | `{}`          |
## Deploying to Kubernetes

You can deploy Reloader by following methods:

### Helm Charts

if you have configured helm on your cluster, you can add reloader to helm from public chart repository and deploy it via helm using below mentioned commands

 ```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/reloader
```

**Note:**  By default reloader watches in all namespaces. To watch in single namespace, please run following command. It will install reloader in `test` namespace which will only watch `Deployments`, `Deamonsets` and `Statefulsets` in `test` namespace.

```bash
helm install stable/reloader --set reloader.watchGlobally=false --namespace test
```

## Help

### Documentation
You can find more documentation [here](https://github.com/stakater/Reloader/tree/master/docs)

### Have a question?
File a GitHub [issue](https://github.com/stakater/Reloader/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack

Join and talk to us on Slack for discussing Reloader

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CC5S05S12)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/Reloader/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/Reloader/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

[Reloader](https://github.com/stakater/Reloader) is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://github.com/stakater/
