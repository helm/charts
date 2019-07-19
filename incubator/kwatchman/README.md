Kwatchman
=======

Kwatchman is a tool to watch for k8s resources changes and trigger handlers

TL;DR;
------

```console
$ helm install --name kwatchman --namespace=kwatchman incubator/kwatchman
```

Introduction
------------

This chart bootstraps a [kwatchman](https://github.com/snebel29/kwatchman) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

 - kwatchman leverages kubernetes watch and list and pipes `Add`, `Update` and `Delete` events through a chain of built-in handlers
 - kwatchman remove event noise when configuring [diff]() handler, by filtering events that implement no user changes on its manifest.
 - kwatchman provide manifest and and free "payload" field to implement any handler, to do things like
    - Log events to stdout to enrich logging platform data for troubleshooting
    - Notify events to IM services such as Slack
    - Etc.
 
Recommendations
-------------

Kwatchman was never tested with previous versions

 - Kubernetes +1.11
 

Installing the Chart
--------------------

The chart can be installed as follows:

```console
$ helm install --name kwatchman --namespace=kwatchman incubator/kwatchman
```

The command deploys kwatchman on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists various ways to override default configuration during deployment.

> **Tip**: List all releases using `helm list`

Uninstalling the Chart
----------------------

To uninstall/delete the `kwatchman` deployment:

```console
$ helm delete kwatchman --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Configuration
-------------

The following table lists the configurable parameters of the kwatchman chart and their default values.

| Parameter                            | Description                            | Default                           |
| -----------------------              | ----------------------------------     | ----------------------------------|
| `image.repository`                   | Docker image repository                | `snebel29/kwatchman`              |
| `image.tag`                          | Docker image tag                       | `latest`                          |
| `image.pullPolicy`                   | Docker image pull policy               | `IfNotPresent`                    |
| `nameOverride`                       | Override kwatchman.name template       | Refer to _helpers.tpl             |
| `fullnameOverride`                   | Override kwatchman.fullname template   | Refer to _helpers.tpl             |
| `rbac.create`                        | Create RBAC objects                    | `true`                            |
| `kwatchman.filter_by.namespace`      | Watch in the given namespace           | `""` which means all              |
| `kwatchman.filter_by.LabelSelector`  | Watch objects filtered by label        | `""` which means all              |
| `kwatchman.config`                   | Kwatchman config file (YAML)           | Refer [config](https://github.com/snebel29/kwatchman#configuration)              |
| `resources.limits.cpu`               | Container resource requests and limits | `100m`                            |
| `resources.limits.memory`            | Container resource requests and limits | `128mi`                           |
| `resources.requests.cpu`             | Container resource requests and limits | `100m`                            |
| `resources.requests.memory`          | Container resource requests and limits | `128mi`                           |
| `affinity`                           | Affinity settings                      | `{}`                              |
| `nodeSelector`                       | Node labels for pod assignment         | `{}`                              |
| `tolerations`                        | Tolerations for pod assignment         | `[]`                              |

> **Tip**: Here is the [labelSelector syntax](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#syntax-and-character-set)

> **Tip**: kwatchman config file in TOML and YAML format are compatible
