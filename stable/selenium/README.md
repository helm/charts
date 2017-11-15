# Selenium

## TL;DR;

```console
$ helm install stable/selenium
```

## Introduction

This chart bootstraps a [Selenium](http://www.seleniumhq.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/selenium
```

The command deploys Selenium on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Selenium chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `hub.image` | The selenium hub image | `selenium/hub` |
| `hub.tag` | The selenium hub image tag | `3.7.1` |
| `hub.pullPolicy` | The pull policy for the hub image | `IfNotPresent` |
| `hub.port` | The port the hub listens on | `4444` |
| `hub.javaOpts` | The java options for the selenium hub JVM, default sets the maximum heap size to 1,000 mb | `-Xmx1000m` |
| `hub.resources` | The resources for the hub container, defaults to minimum half a cpu and maximum 1,000 mb RAM | `{"limits":{"cpu":".5", "memory":"1000Mi"}}` |
| `hub.serviceType` | The Service type | `NodePort` |
| `hub.serviceSessionAffinity` | The session affinity for the hub service| `None` |
| `hub.gridNewSessionWaitTimeout` | | `nil` |
| `hub.gridJettyMaxThreads` | | `nil` |
| `hub.gridNodePolling` | | `nil` |
| `hub.gridCleanUpCycle` | | `nil` |
| `hub.gridTimeout` | | `nil` |
| `hub.gridBrowserTimeout` | | `nil` |
| `hub.gridMaxSession` | | `nil` |
| `hub.gridUnregisterIfStillDownAfer` | | `nil` |
| `hub.seOpts` | Command line arguments to pass to hub | `nil` |
| `hub.timeZone` | The time zone for the container | `nil` |
| `chrome.enabled` | Schedule a chrome node pod | `false` |
| `chrome.image` | The selenium node chrome image | `selenium/node-chrome` |
| `chrome.tag` | The selenium node chrome tag | `3.7.1` |
| `chrome.pullPolicy` | The pull policy for the node chrome image | `IfNotPresent` |
| `chrome.replicas` | The number of selenium node chrome pods | `1` |
| `chrome.javaOpts` | The java options for the selenium node chrome JVM, default sets the maximum heap size to 900 mb | `-Xmx900m` |
| `chrome.volumeMounts` | Additional volumes to mount, the default provides a larger shared memory | `[{"mountPath":"/dev/shm", "name":"dshm"}]` |
| `chrome.volumes` | Additional volumes import, the default provides a larger shared memory | `[{"name":"dshm", "emptyDir":{"medium":"Memory"}}]` |
| `chrome.resources` | The resources for the node chrome container, defaults to minimum half a cpu and maximum 1,000 mb | `{"limits":{"cpu":".5", "memory":"1000Mi"}}` |
| `chrome.screenWidth` | | `nil` |
| `chrome.screenHeight` | | `nil` |
| `chrome.screenDepth` | | `nil` |
| `chrome.display` | The vnc display | `nil` |
| `chrome.chromeVersion` | The version of chrome to use | `nil` |
| `chrome.nodeMaxInstances` | The maximum number of browser instances | `nil` |
| `chrome.nodeMaxSession` | The maximum number of sessions | `nil` |
| `chrome.nodeRegistryCycle` | The number of milliseconds to wait, registering a node| `nil` |
| `chrome.nodePort` | The port to listen on | `nil` |
| `chrome.seOpts` | Command line arguments to pass to node | `nil` |
| `chrome.timeZone` | The time zone for the container | `nil` |
| `chromeDebug.enabled` | Schedule a selenium node chrome debug pod | `false` |
| `chromeDebug.image` | The selenium node chrome debug image | `selenium/node-chrome-debug` |
| `chromeDebug.tag` | The selenium node chrome debug tag | `3.7.1` |
| `chromeDebug.pullPolicy` | The selenium node chrome debug pull policy | `IfNotPresent` |
| `chromeDebug.replicas` | The number of selenium node chrome debug pods | `1` |
| `chromeDebug.javaOpts` | The java options for a selenium node chrome debug JVM, default sets the max heap size to 900 mb | `-Xmx900m` |
| `chromeDebug.volumeMounts` | Additional volumes to mount, the default provides a larger shared | `[{"mountPath":"/dev/shm", "name":"dshm"}]` |
| `chromeDebug.volumes` | Additional volumes import, the default provides a larger shared | `[{"name":"dshm", "emptyDir":{"medium":"Memory"}}]` |
| `chromeDebug.resources` | The resources for the hub container, defaults to minimum half a cpu and maximum 1,000 mb | `{"limits":{"cpu":".5", "memory":"1000Mi"}}` |
| `chromeDebug.screenWidth` | | `nil` |
| `chromeDebug.screenHeight` | | `nil` |
| `chromeDebug.screenDepth` | | `nil` |
| `chromeDebug.display` | The vnc display | `nil` |
| `chromeDebug.chromeVersion` | The version of chrome to use | `nil` |
| `chromeDebug.nodeMaxInstances` | The maximum number of browser instances | `nil` |
| `chromeDebug.nodeMaxSession` | The maximum number of sessions | `nil` |
| `chromeDebug.nodeRegistryCycle` | The number of milliseconds to wait, registering a node| `nil` |
| `chromeDebug.nodePort` | The port to listen on | `nil` |
| `chromeDebug.seOpts` | Command line arguments to pass to node | `nil` |
| `chromeDebug.timeZone` | The time zone for the container | `nil` |
| `firefox.enabled` | Schedule a selenium node firefox pod | `false` |
| `firefox.image` | The selenium node firefox image | `selenium/node-firefox` |
| `firefox.tag` | The selenium node firefox tag | `3.7.1` |
| `firefox.pullPolicy` | The selenium node firefox pull policy | `IfNotPresent` |
| `firefox.replicas` | The number of selenium node firefox pods | `1` |
| `firefox.javaOpts` | The java options for a selenium node firefox JVM, default sets the max heap size to 900 mb | `-Xmx900m` |
| `firefox.resources` | The resources for the hub container, defaults to minimum half a cpu and maximum 1,000 mb | `{"limits":{"cpu":".5", "memory":"1000Mi"}}` |
| `firefox.screenWidth` | | `nil` |
| `firefox.screenHeight` | | `nil` |
| `firefox.screenDepth` | | `nil` |
| `firefox.display` | The vnc display | `nil` |
| `firefox.firefoxVersion` | The version of firefox to use | `nil` |
| `firefox.nodeMaxInstances` | The maximum number of browser instances | `nil` |
| `firefox.nodeMaxSession` | The maximum number of sessions | `nil` |
| `firefox.nodeRegistryCycle` | The number of milliseconds to wait, registering a node| `nil` |
| `firefox.nodePort` | The port to listen on | `nil` |
| `firefox.seOpts` | Command line arguments to pass to node | `nil` |
| `firefox.timeZone` | The time zone for the container | `nil` |
| `firefoxDebug.enabled` | Schedule a selenium node firefox debug pod | `false` |
| `firefoxDebug.image` | The selenium node firefox debug image | `selenium/node-firefox-debug` |
| `firefoxDebug.tag` | The selenium node firefox debug tag | `3.7.1` |
| `firefoxDebug.pullPolicy` | The selenium node firefox debug pull policy | `IfNotPresent` |
| `firefoxDebug.replicas` | The numer of selenium node firefox debug pods | `1` |
| `firefoxDebug.javaOpts` | The java options for a selenium node firefox debug JVM, default sets the max heap size to 900 mb | `-Xmx900m` |
| `firefoxDebug.resources` | The resources for the selenium node firefox debug container, defaults to minimum half a cpu and maximum 1,000 mb | `{"limits":{"cpu":".5", "memory":"1000Mi"}}` |
| `firefoxDebug.screenWidth` | | `nil` |
| `firefoxDebug.screenHeight` | | `nil` |
| `firefoxDebug.screenDepth` | | `nil` |
| `firefoxDebug.display` | The vnc display | `nil` |
| `firefoxDebug.firefoxVersion` | The version of firefox to use | `nil` |
| `firefoxDebug.nodeMaxInstances` | The maximum number of browser instances | `nil` |
| `firefoxDebug.nodeMaxSession` | The maximum number of sessions | `nil` |
| `firefoxDebug.nodeRegistryCycle` | The number of milliseconds to wait, registering a node| `nil` |
| `firefoxDebug.nodePort` | The port to listen on | `nil` |
| `firefoxDebug.seOpts` | Command line arguments to pass to node | `nil` |
| `firefoxDebug.timeZone` | The time zone for the container | `nil` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set chrome.enabled=true \
    stable/selenium
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/selenium
```

> **Tip**: You can use the default [values.yaml](values.yaml)
