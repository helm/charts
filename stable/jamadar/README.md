# ![](https://raw.githubusercontent.com/stakater/Jamadar/master/assets/web/jamadar-round-100px.png) Jamadar

[![Get started with Stakater](https://stakater.github.io/README/stakater-github-banner.png)](http://stakater.com/?utm_source=Jamadar&utm_medium=github)


## WHY NAME JAMADAR?
Jamadar, an Urdu word, is used for Sweepers/Cleaners in Pakistan. This Jamadar will keep your cluster clean and sweep away the left overs of your cluster and will act as you want it to.

## Problem
Dangling/Redundant resources take a lot of space and memory in a cluster. So we want to delete these unneeded resources depending upon the age and pre-defined  annotations. e.g. I would like to delete namespaces that were without a specific annotation and are almost a month old and would like to take action whenever that happens.

## Solution

Jamadar is a Kubernetes controller that can poll at configured time intervals and watch for dangling resources that are an 'X' time period old and don't have a specific annotation, and will delete them and take corresponding actions.

## Configuring

First of all you need to modify `configs/config.yaml` file. Following are the available options that you can use to customize Jamadar:

| Key                   |Description                                                                    |
|-----------------------|-------------------------------------------------------------------------------|
| pollTimeInterval      | The time interval after which the controller will poll and look for dangling resources, The value can be in "ms", "s", "m", "h" or even combined like 2h45m       |
| age        | The time period that a dangling resource  has been created e.g. delete only resources that are 7 days old, The value can be in "d", "w", "m", "y", Combined format is not supported     |
| resources               | The resources that you want to be taken care of by Jamadar, e.g. namespaces, pods, etc   |
| actions               | The Array of actions that you want to take, e.g. send message to Slack, etc   |
| restrictedNamespaces               | The Array of string which contains the namespaces names to ignore   |

### Supported Resources
Currently we are supporting the following dangling resources,
- namespaces


We will be adding support for other Resources as well in the future

### Supported Actions
Currently we are supporting following Actions with their Parameters,
- Default: No parameters needed, it will just log to console the details.
- Slack: you need to provide `token` and `Channel Name` as Parameters in the yaml file

We will be adding support for other Actions as well in the future

## Deploying to Kubernetes

You have to first clone or download the repository contents. The kubernetes deployment and files are provided inside `deployments/kubernetes/manifests` folder.

### Helm Charts

If you configured `helm` on your cluster, you can deploy Jamadar via helm chart
 ```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/jamadar
```

## Help

**Got a question?**
File a GitHub [issue](https://github.com/stakater/Jamadar/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack
Join and talk to us on the #tools-imc channel for discussing Jamadar

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CA66MMYSE/)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/Jamadar/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/Jamadar/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

`Jamadar` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://github.com/stakater/
