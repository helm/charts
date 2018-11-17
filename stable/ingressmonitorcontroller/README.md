# ![](https://raw.githubusercontent.com/stakater/IngressMonitorController/master/assets/web/IMC-round-100px.png) Ingress Monitor Controller

A Kubernetes/Openshift controller to watch ingresses/routes and create liveness alerts for your apps/microservices in Uptime checkers.

[![Get started with Stakater](https://stakater.github.io/README/stakater-github-banner.png)](http://stakater.com/?utm_source=IngressMonitorController&utm_medium=github)

## Problem Statement

We want to monitor ingresses in a kubernetes cluster and routes in openshift cluster via any uptime checker but the problem is having to manually check for new ingresses or routes / removed ingresses or routes and add them to the checker or remove them.

## Solution

[IngressMonitorController](https://github.com/stakater/IngressMonitorController) will continuously watch ingresses/routes in specific or all namespaces, and automatically add / remove monitors in any of the uptime checkers. With the help of this solution, you can keep a check on your services and see whether they're up and running and live, without worrying about manually registering them on the Uptime checker.

## Supported Uptime Checkers

Currently we support the following monitors:

- [UptimeRobot](https://uptimerobot.com)
- [Pingdom](https://pingdom.com) ([Additional Config](https://github.com/stakater/IngressMonitorController/blob/master/docs/pingdom-configuration.md))
- [StatusCake](https://www.statuscake.com) ([Additional Config](https://github.com/stakater/IngressMonitorController/blob/master/docs/statuscake-configuration.md))

## Usage

The following quickstart let's you set up Ingress Monitor Controller to register uptime monitors for ingresses/routes in all namespaces:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| useFullName          | Option to use full name containing release name for resources                                                      | `false`                        | `false`                        |
| matchLabels          | Match labels for deployment selector                                                      | `{}`                        | `{}`
| deployment.labels          | Labels for deployment                                                      | `{}`                        | `{}`
| deployment.annotations           | Annotations for deployment                                                      | `{}`                        | `{}`
| config.labels          | Labels for configmap                                                      | `{}`                        | `{}`
| config.annotations          | Annotations for configmap                                                      | `fabric8.io/target-platform: kubernetes`                        | `fabric8.io/target-platform: kubernetes`
| rbac.create          | Option to create rbac resources                                                      | `true`                        | `true`
| rbac.labels          | Labels for rbac                                                      | `{}`                        | `{}`
| serviceAccount.create          | Option to create service account                                                      | `true`                        | `true`
| serviceAccount.labels          | Labels for serviceAccount                                                      | `{}`                        | `{}`
| serviceAccount.name          | Name of serviceAccount                                                      | `ingressmonitorcontroller`                        | `ingressmonitorcontroller`
| image.name          | Image of ingressMonitorController                                                      | `stakater/ingressmonitorcontroller`                        | `stakater/ingressmonitorcontroller`
| image.tag          | Version of ingressMonitorController Image                                                      | `1.0.47`                        | `1.0.47`
| image.pullPolicy          | Pull policy for image                                                      | `IfNotPresent`                        | `IfNotPresent`
| providers.name          | Name of the provider                                                      | `UptimeRobot`                        | `UptimeRobot`                        |
| providers.apiKey        | ApiKey of the provider                                                    | `u956-afus321g565fghr519`            | `your-api-key`                       |
| providers.apiURL        | Base url of the ApiProvider                                               | `https://api.uptimerobot.com/v2/` | `https://api.uptimerobot.com/v2/` |
| providers.alertContacts | A `-` separated list of contact id's that you want to add to the monitors | `12345_0_0-23564_0_0`               | `some-alert-contacts`                |
| watchNamespace | Name of the namespace if you want to monitor ingresses/route only in that namespace. | `dev`               | `""`                |
| enableMonitorDeletion | A safeguard flag that is used to enable or disable monitor deletion on ingress deletion (Useful for prod environments where you don't want to remove monitor on ingress deletion) | `false`               | `false`                |



  *Note:* Follow [this](https://github.com/stakater/IngressMonitorController/blob/master/docs/uptimerobot-configuration.md) guide to see how to fetch `alertContacts` from UptimeRobot.

2. Enable for your Ingress/Route

   You will need to add the following annotation on your ingresses/routes so that the controller is able to recognize and monitor it.

   ```yaml
   "monitor.stakater.com/enabled": "true"
   ```

3. Deploy the controller by running the following command:

   ```bash
   helm install --name imc-stakater . --namespace default
   ```

## Help

### Documentation
You can find more detailed documentation for configuration, extension, and support for other Uptime checkers etc. [here](https://github.com/stakater/IngressMonitorController/blob/master/docs/Deploying-to-Kubernetes.md)

### Have a question?
File a GitHub [issue](https://github.com/stakater/IngressMonitorController/issues), or send us an [email](mailto:hello@stakater.com).

### Talk to us on Slack
Join and talk to us on the #tools-ingressmonitor channel for discussing the Ingress Monitor Controller

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CA66MMYSE/)

## License

Apache2 © [Stakater](http://stakater.com)

## About

The `IngressMonitorController` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://www.stakater.com/projects-overview.html

## Contributers

Stakater Team and the Open Source community! :trophy:
