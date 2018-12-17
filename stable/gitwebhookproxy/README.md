# ![](https://raw.githubusercontent.com/stakater/GitWebhookProxy/master/assets/web/gitwebhookproxy-round-100px.png)  GitWebhookProxy

A proxy to let webhooks to reach a Jenkins instance running behind a firewall

## PROBLEM

Jenkins is awesome and matchless tool for both CI & CD; but unfortunately its a gold mine if left in wild with wide open access; so, we always want to put it behind a firewall. But when we put it behind firewall then webhooks don't work anymore and no one wants the pull based polling but rather prefer the build to start as soon as there is a commit!

## SOLUTION

This little proxy makes webhooks start working again!

### Supported Providers

Currently we support the following git providers out of the box:

* Github
* Gitlab

### Configuration

GitWebhookProxy can be configured by providing the following arguments either via command line or via environment variables:

| Parameter     | Description                                                                       | Default  | Example                                    |
|---------------|-----------------------------------------------------------------------------------|----------|--------------------------------------------|
| listenAddress | Address on which the proxy listens.                                               | `:8080`  | `127.0.0.1:80`                             |
| upstreamURL   |          URL to which the proxy requests will be forwarded (required)             |          | `https://someci-instance-url.com/webhook/` |
| secret        | Secret of the Webhook API. If not set validation is not made.  |                  | `iamasecret` |
| provider      | Git Provider which generates the Webhook                                          | `github` | `github` or `gitlab`                       |
| allowedPaths  | Comma-Separated String List of allowed paths on the proxy                         |          | `/project` or `github-webhook/,project/`   |
| ignoredUsers  | Comma-Separated String List of users to ignore while proxying Webhook request     |          | `someuser`                                 |

## DEPLOYING TO KUBERNETES

The GitWebhookProxy can be deployed with Helm Charts.

#### Configuring

Below mentioned attributes in `gitwebhookproxy.yaml` have been hard coded. Please make sure to update values of these according to your own configuration.

1. Change below mentioned attribute's values in `Ingress` in `gitwebhookproxy.yaml`

```yaml
 rules:
  - host: gitwebhookproxy.example.com
```

```yaml
  tls:
  - hosts:
    - gitwebhookproxy.example.com
```

2. Change below mentioned attribute's values in `Secret` in `gitwebhookproxy.yaml`

```yaml
data:
  secret: example
```

3. Change below mentioned attribute's values in `ConfigMap` in `gitwebhookproxy.yaml`

```yaml
data:
  provider: github
  upstreamURL: https://jenkins.example.com
  allowedPaths: /github-webhook,/project
  ignoredUsers: stakater-user
```

*Note:* Make sure to update the `port` in deployment.yaml as well as service.yaml if you change the default `listenAddress` port.

### Helm Charts

Alternatively if you have configured helm on your cluster, you can add gitwebhookproxy to helm from our public chart repository and deploy it via helm using below mentioned commands

1. Add the chart repo:

   i. `helm repo add stable https://kubernetes-charts.storage.googleapis.com/`

   ii. `helm repo update`
2. Set configuration as discussed in the `Configuring` section

   i. `helm fetch --untar stable/gitwebhookproxy`

   ii. Open and edit `gitwebhookproxy/values.yaml` in a text editor and update the values mentioned in `Configuring` section.

3. Install the chart
   * `helm install stable/gitwebhookproxy -f gitwebhookproxy/values.yaml -n gitwebhookproxy`

## Help

**Got a question?**
File a GitHub [issue](https://github.com/stakater/GitWebhookProxy/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack
Join and talk to us on the #tools-gwp channel for discussing about GitWebhookProxy

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CAQ5A4HGD/)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/GitWebhookProxy/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/GitWebhookProxy/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

`GitWebhookProxy` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://github.com/stakater/
