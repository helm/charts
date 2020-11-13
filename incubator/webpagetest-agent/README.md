# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# WebPageTest Agent

[WebPageTest](https://webpagetest.org/) is a website testing tool

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install incubator/webpagetest-agent
```

## Introduction

This chart deploys [WebPageTest Private Instance Containers](https://github.com/WPO-Foundation/webpagetest-docs/blob/master/user/Private%20Instances/README.md) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Depending on your configuration you can then use Official WPT agent instances to test your websites.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/webpagetest-agent
```

The command deploys a WebPageTest agent on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
Please note the default install probably won't do much without some configuration of the values.yaml file.


> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the WordPress chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `image.repository`                   | WebPageTest agent image | `timothyclarke/wptagent`
| `image.tag`                          | WebPageTest agent tag  | `2018-01-23`                              |
| `image.pullPolicy`                   | Image pull policy                          | `IfNotPresent`                                             |
| `agent.key`                          | API Key for agent to auth the master   | `nil`                                                      |
| `agent.server`                       | Hostname of the WPT server (see below)     | `agent-web-page-test.local`                                |
| `agent.location`                     | WPT location tag                           | `Test`                                                     |
| `agent.shaper`                       | Traffic shaping method the agent uses      | `none`                                                      |
| `nodeSelector`                       | Node labels for pod assignment             | `{}`                                                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set agent.key=SecretKey \
    incubator/webpagetest-agent
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/webpagetest-agent
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Ingress
There are none. This is a worker node. The standard operation is for it to poll the
WebPageTest Server for work.

## WebPageTest Server Config
At time of writing this chart the server has two means of config
* Log onto the server and use vim or similar
* Use the AWS/EC2 init scripts to configure some values, the login and use vim ir similar to configure the rest
As such these charts will get an environment up and working, but if you want more than defaults you will need to write your own config maps or update the WebPageTest Source for either the [server](https://github.com/WPO-Foundation/webpagetest) or the [agent](https://github.com/WPO-Foundation/wptagent)

### Defaults
A default install of the server will have a location of 'Test' with a blank key.
This config makes use of that. To use different values you will probably need to update
settings/locations.ini and or settings/keys.ini on the WebPageTest server.

### agent.server
**You'll probably want to update this one.**
This is the host header that the agent will use to speak to the master.

### agent.shaper
This is the method that the agent will use to throttle bandwidth or add latency. Some methods require root access.
The default method did not work when this chart was being created so a value of 'none' was selected to disable this feature.

### agent.key
The API key is used by the agent to authenticate itself to the WebPageTest server.

### agent.location
This is the WebPageTest location to use. This needs to match something in settings/locations.ini

## Future
* Integrate with webpagetest-server and embed along with correct creation of keys
