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

The following table lists the configurable parameters of the Selenium chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `global.nodeSelector` | Node label to be useed globally for scheduling of all images | `nil` |
| `global.hostAliases` | A list of hostAliases, that contains ip and hostnames, to be used globally | `[]` |
| `global.affinity` | Deployemnt affinities to be used globally for scheduling of all images | `nil` |
| `global.tolerations` | Deployment tolerations to be used globally for scheduling of all images | `nil` |
| `global.imagePullSecrets` | The secret to use for pulling the images for all deployments | `nil` |
| `hub.image` | The selenium hub image | `selenium/hub` |
| `hub.tag` | The selenium hub image tag | `3.141.59` |
| `hub.imagePullSecrets` | The secret to use for pulling the image. Will override the global parameter if set | `nil` |
| `hub.pullPolicy` | The pull policy for the hub image | `IfNotPresent` |
| `hub.port` | The port the hub listens on | `4444` |
| `hub.servicePort` | The port the hub Service listens on | `4444` |
| `hub.nodePort` | The port the hub is exposed when Nodeport mode is selected | `nil` |
| `hub.podAnnotations` | Annotations on the hub pod | `{}` |
| `hub.podLabels` | Additionals labels to the hub pod | `{}`|
| `hub.securityContext` |	SecurityContext on the hub pod |	`{"runAsUser": 1000, "fsGroup": 1000}` |
| `hub.extraEnvs` |  Any additional environment variables to set in the pods | `[]` |
| `hub.javaOpts` | The java options for the selenium hub JVM, default sets the maximum heap size to 400 mb | `-Xmx400m` |
| `hub.resources` | The resources for the hub container, defaults to minimum half a cpu and maximum 512 mb RAM | `{"limits":{"cpu":".5", "memory":"512Mi"}}` |
| `hub.serviceType` | The Service type | `LoadBalancer` |
| `hub.serviceLoadBalancerIP` | The Public IP for the Load Balancer | `nil` |
| `hub.loadBalancerSourceRanges` | A list of IP CIDRs allowed access to load balancer (if supported) | `[]` |
| `hub.serviceSessionAffinity` | The session affinity for the hub service| `None` |
| `hub.gridNewSessionWaitTimeout` | | `nil` |
| `hub.gridJettyMaxThreads` | | `nil` |
| `hub.gridNodePolling` | | `nil` |
| `hub.gridCleanUpCycle` | Specifies how often the hub will poll running proxies for timed-out (i.e. hung) threads **(in ms)**. Must also specify "timeout" option | `nil` |
| `hub.gridTimeout` | Specifies the timeout before the server automatically kills a session that hasn't had any activity in the last X seconds.| `nil` |
| `hub.gridBrowserTimeout` | Number of seconds a browser session is allowed to hang while a WebDriver command is running | `nil` |
| `hub.gridMaxSession` | | `nil` |
| `hub.gridUnregisterIfStillDownAfter` | | `nil` |
| `hub.seOpts` | Command line arguments to pass to hub | `nil` |
| `hub.timeZone` | The time zone for the container | `nil` |
| `hub.nodeSelector` | Node label to use for scheduling of the hub if set this takes precedence over the global value | `nil` |
| `hub.affinity` | Deployemnt affinities to use for scheduling of the hub if set this takes precedence over the global value | `nil` |
| `hub.tolerations` | Deployment tolerations to use for scheduling of the hub if set this takes precedence over the global value | `nil` |
| `hub.ingress.enabled` | Configure an ingress for the selenium hub | `false` |
| `hub.ingress.annotations` | Annotations for the ingress for the selenium hub | `nil` |
| `hub.ingress.path` | The path for this ingress from which to route the traffic to the selenium hub | `/` |
| `hub.ingress.hosts` | The list hosts for which this ingress should resolve the selenium hub | `[selenium-hub.local]` |
| `hub.ingress.tls` | The tls secret to configure ssl for this ingress | `[]` |
| `hub.readinessTimeout` | Timeout for hub readiness probe in seconds | `1` |
| `hub.livenessTimeout` | Timeout for hub liveness probe in seconds | `1` |
| `hub.probePath` | Path for readiness and liveness probes to check | `/wd/hub/status` |
| `chrome.enabled` | Schedule a chrome node pod | `false` |
| `chrome.runAsDaemonSet` | Schedule chrome node pods as DaemonSet | `false` |
| `chrome.image` | The selenium node chrome image | `selenium/node-chrome` |
| `chrome.tag` | The selenium node chrome tag | `3.141.59` |
| `chrome.imagePullSecrets` | The secret to use for pulling the image. Will override the global parameter if set | `nil` |
| `chrome.pullPolicy` | The pull policy for the node chrome image | `IfNotPresent` |
| `chrome.replicas` | The number of selenium node chrome pods. This is ignored if runAsDaemonSet is enabled. | `1` |
| `chrome.enableLivenessProbe` | When true will add a liveness check to the pod | `false` |
| `chrome.waitForRunningSessions` | When true will wait for current running sessions to finish before terminating the pod | `false` |
| `chrome.podAnnotations` | Annotations on the chrome pods | `{}` |
| `chrome.podLabels` | Additional labels on the chrome pods | `{}` |
| `chrome.securityContext` |	SecurityContext on the chrome pods |	`{"runAsUser": 1000, "fsGroup": 1000}` |
| `chrome.extraEnvs` |  Any additional environment variables to set in the pods | `[]` |
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
| `chrome.nodeSelector` | Node label to use for scheduling of chrome images if set this takes precedence over the global value | `nil` |
| `chrome.affinity` | Deployemnt affinities to use for scheduling of the chrome if set this takes precedence over the global value | `nil` |
| `chrome.tolerations` | Deployment tolerations to use for scheduling of the chrome if set this takes precedence over the global value | `nil` |
| `chromeDebug.enabled` | Schedule a selenium node chrome debug pod | `false` |
| `chromeDebug.runAsDaemonSet` | Schedule selenium node chrome debug pods as DaemonSet | `false` |
| `chromeDebug.image` | The selenium node chrome debug image | `selenium/node-chrome-debug` |
| `chromeDebug.tag` | The selenium node chrome debug tag | `3.141.59` |
| `chromeDebug.imagePullSecrets` | The secret to use for pulling the image. Will override the global parameter if set | `nil` |
| `chromeDebug.pullPolicy` | The selenium node chrome debug pull policy | `IfNotPresent` |
| `chromeDebug.replicas` | The number of selenium node chrome debug pods. This is ignored if runAsDaemonSet is enabled. | `1` |
| `chromeDebug.enableLivenessProbe` | When true will add a liveness check to the pod | `false` |
| `chromeDebug.waitForRunningSessions` | When true will wait for current running sessions to finish before terminating the pod | `false` |
| `chromeDebug.podAnnotations` | Annotations on the Chrome debug pod | `{}` |
| `chromeDebug.podLabels` | Additional labels on the Chrome debug pods | `{}` |
| `chromeDebug.securityContext` |	SecurityContext on the Chrome debug pods |	`{"runAsUser": 1000, "fsGroup": 1000}` |
| `chromeDebug.extraEnvs` |  Any additional environment variables to set in the pods | `[]` |
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
| `chromeDebug.nodeSelector` | Node label to use for scheduling of chromeDebug images if set this takes precedence over the global value | `nil` |
| `chromeDebug.affinity` | Deployemnt affinities to use for scheduling of the chromeDebug if set this takes precedence over the global value | `nil` |
| `chromeDebug.tolerations` | Deployment tolerations to use for scheduling of the chromeDebug if set this takes precedence over the global value | `nil` |
| `firefox.enabled` | Schedule a selenium node firefox pod | `false` |
| `firefox.runAsDaemonSet` | Schedule selenium node firefox pods as DaemonSet | `false` |
| `firefox.image` | The selenium node firefox image | `selenium/node-firefox` |
| `firefox.tag` | The selenium node firefox tag | `3.141.59` |
| `firefox.imagePullSecrets` | The secret to use for pulling the image. Will override the global parameter if set | `nil` |
| `firefox.pullPolicy` | The selenium node firefox pull policy | `IfNotPresent` |
| `firefox.replicas` | The number of selenium node firefox pods. This is ignored if runAsDaemonSet is enabled. | `1` |
| `firefox.enableLivenessProbe` | When true will add a liveness check to the pod | `false` |
| `firefox.waitForRunningSessions` | When true will wait for current running sessions to finish before terminating the pod | `false` |
| `firefox.podAnnotations` | Annotations on the firefox pods | `{}` |
| `firefox.podLabels` | Additional labels on the firefox pods | `{}` |
| `firefox.securityContext` |	SecurityContext on the firefox pods |	`{"runAsUser": 1000, "fsGroup": 1000}` |
| `firefox.extraEnvs` |  Any additional environment variables to set in the pods | `[]` |
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
| `firefox.nodeSelector` | Node label to use for scheduling of firefox images if set this takes precedence over the global value | `nil` |
| `firefox.affinity` | Deployemnt affinities to use for scheduling of the firefox if set this takes precedence over the global value | `nil` |
| `firefox.tolerations` | Deployment tolerations to use for scheduling of the firefox if set this takes precedence over the global value | `nil` |
| `firefoxDebug.enabled` | Schedule a selenium node firefox debug pod | `false` |
| `firefoxDebug.runAsDaemonSet` | Schedule selenium node firefox debug pods as DaemonSet | `false` |
| `firefoxDebug.image` | The selenium node firefox debug image | `selenium/node-firefox-debug` |
| `firefoxDebug.tag` | The selenium node firefox debug tag | `3.141.59` |
| `firefoxDebug.imagePullSecrets` | The secret to use for pulling the image. Will override the global parameter if set | `nil` |
| `firefoxDebug.pullPolicy` | The selenium node firefox debug pull policy | `IfNotPresent` |
| `firefoxDebug.replicas` | The number of selenium node firefox debug pods. This is ignored if runAsDaemonSet is enabled. | `1` |
| `firefoxDebug.enableLivenessProbe` | When true will add a liveness check to the pod | `false` |
| `firefoxDebug.waitForRunningSessions` | When true will wait for current running sessions to finish before terminating the pod | `false` |
| `firefoxDebug.podAnnotations` | Annotations on the firefox debug pods | `{}` |
| `firefoxDebug.podLabels` | Additional labels on the firefox debug pods | `{}` |
| `firefoxDebug.securityContext` |	SecurityContext on the firefox debug pods |	`{"runAsUser": 1000, "fsGroup": 1000}` |
| `firefoxDebug.extraEnvs` |  Any additional environment variables to set in the pods | `[]` |
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
| `firefoxDebug.nodeSelector` | Node label to use for scheduling of firefoxDebug images if set this takes precedence over the global value | `nil` |
| `firefoxDebug.affinity` | Deployemnt affinities to use for scheduling of the firefoxDebug if set this takes precedence over the global value | `nil` |
| `firefoxDebug.tolerations` | Deployment tolerations to use for scheduling of the firefoxDebug if set this takes precedence over the global value | `nil` |

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
