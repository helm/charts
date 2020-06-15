# DEPRECATED - Home Assistant

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/billimek/billimek-charts/tree/master/charts/home-assistant
- **Charts repo:** https://billimek.com/billimek-charts

This is a helm chart for [Home Assistant](https://www.home-assistant.io/)

## TL;DR;

```console
$ helm install stable/home-assistant
```

## Introduction

This code is adapted for [the official home assistant docker image](https://hub.docker.com/r/homeassistant/home-assistant/)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/home-assistant
```
## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Home Assistant chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image.repository`         | Image repository | `homeassistant/home-assistant` |
| `image.tag`                | Image tag. Possible values listed [here](https://hub.docker.com/r/homeassistant/home-assistant/tags/).| `0.108.7`|
| `image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `image.pullSecrets`        | Secrets to use when pulling the image | `[]` |
| `strategyType`             | Specifies the strategy used to replace old Pods by new ones | `Recreate` |
| `probes.liveness.enabled`  | Use the livenessProbe?  | `true` |
| `probes.liveness.scheme `  | Specify liveness `scheme` parameter for the deployment  | `HTTP` |
| `probes.liveness.initialDelaySeconds`  | Specify liveness `initialDelaySeconds` parameter for the deployment  | `60` |
| `probes.liveness.failureThreshold`     | Specify liveness `failureThreshold` parameter for the deployment     | `5`  |
| `probes.liveness.timeoutSeconds`       | Specify liveness `timeoutSeconds` parameter for the deployment       | `10` |
| `probes.readiness.enabled`  | Use the readinessProbe?  | `true` |
| `probes.readiness.scheme `  | Specify readiness `scheme` parameter for the deployment  | `HTTP` |
| `probes.readiness.initialDelaySeconds` | Specify readiness `initialDelaySeconds` parameter for the deployment | `60` |
| `probes.readiness.failureThreshold`    | Specify readiness `failureThreshold` parameter for the deployment    | `5`  |
| `probes.readiness.timeoutSeconds`      | Specify readiness `timeoutSeconds` parameter for the deployment      | `10` |
| `probes.startup.enabled`  | Use the startupProbe? (new in kubernetes 1.16)  | `false` |
| `probes.startup.scheme `  | Specify startup `scheme` parameter for the deployment  | `HTTP` |
| `probes.startup.failureThreshold`    | Specify startup `failureThreshold` parameter for the deployment    | `5`  |
| `probes.startup.periodSeconds`      | Specify startup `periodSeconds` parameter for the deployment      | `10` |
| `service.type`             | Kubernetes service type for the home-assistant GUI | `ClusterIP` |
| `service.port`             | Kubernetes port where the home-assistant GUI is exposed| `8123` |
| `service.portName`         | Kubernetes port name where the home-assistant GUI is exposed | `api` |
| `service.additionalPorts`  | Add additional ports exposed by the home assistant container integrations. Example homematic needs to expose a proxy port | `{}` |
| `service.annotations`      | Service annotations for the home-assistant GUI | `{}` |
| `service.clusterIP`   | Cluster IP for the home-assistant GUI | `` |
| `service.externalIPs`   | External IPs for the home-assistant GUI | `[]` |
| `service.loadBalancerIP`   | Loadbalancer IP for the home-assistant GUI | `` |
| `service.loadBalancerSourceRanges`   | Loadbalancer client IP restriction range for the home-assistant GUI | `[]` |
| `service.publishNotReadyAddresses`   | Set to true if the editors (vscode or configurator) should be reachable when home assistant does not run | `false` |
| `service.externalTrafficPolicy`   | Loadbalancer externalTrafficPolicy | `` |
| `hostNetwork`              | Enable hostNetwork - might be needed for discovery to work | `false` |
| `service.nodePort`   | nodePort to listen on for the home-assistant GUI | `` |
| `ingress.enabled`              | Enables Ingress | `false` |
| `ingress.annotations`          | Ingress annotations | `{}` |
| `ingress.path`                 | Ingress path | `/` |
| `ingress.hosts`                | Ingress accepted hostnames | `chart-example.local` |
| `ingress.tls`                  | Ingress TLS configuration | `[]` |
| `persistence.enabled`      | Use persistent volume to store data | `true` |
| `persistence.size`         | Size of persistent volume claim | `5Gi` |
| `persistence.existingClaim`| Use an existing PVC to persist data | `nil` |
| `persistence.hostPath`| The path to the config directory on the host, instead of a PVC | `nil` |
| `persistence.storageClass` | Type of persistent volume claim | `-` |
| `persistence.accessMode`  | Persistence access modes | `ReadWriteMany` |
| `git.enabled`                  | Use git-sync in init container | `false` |
| `git.secret`                   | Git secret to use for git-sync | `git-creds` |
| `git.syncPath`                 | Git sync path | `/config` |
| `git.keyPath`                  | Git ssh key path | `/root/.ssh` |
| `git.user.name`                | Human-readable name in the “committer” and “author” fields | `` |
| `git.user.email`               | Email address for the “committer” and “author” fields | `` |
| `zwave.enabled`                  | Enable zwave host device passthrough. Also enables privileged container mode. | `false` |
| `zwave.device`                  | Device to passthrough to guest | `ttyACM0` |
| `hostMounts`        | Array of host directories to mount; can be used for devices | [] |
| `hostMounts.name`   | Name of the volume | `nil` |
| `hostMounts.hostPath` | The path on the host machine | `nil` |
| `hostMounts.mountPath` | The path at which to mount (optional; assumed same as hostPath) | `nil` |
| `hostMounts.type` | The type to mount (optional, i.e., `Directory`) | `nil` |
| `extraEnv`          | Extra ENV vars to pass to the home-assistant container | `{}` |
| `extraEnvSecrets`   | Extra env vars to pass to the home-assistant container from k8s secrets - see `values.yaml` for an example | `{}` |
| `configurator.enabled`     | Enable the optional [configuration UI](https://github.com/danielperna84/hass-configurator) | `false` |
| `configurator.image.repository`         | Image repository | `billimek/hass-configurator-docker` |
| `configurator.image.tag`                | Image tag | `0.3.5-x86_64`|
| `configurator.image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `configurator.hassApiUrl`               | Home Assistant API URL (e.g. 'http://home-assistant:8123/api/') - will auto-configure to proper URL if not set | ``|
| `configurator.hassApiPassword`          | Home Assistant API Password | `` |
| `configurator.basepath`                 | Base path of the home assistant configuration files | `/config` |
| `configurator.enforceBasepath`          | If set to true, will prevent navigation to other directories in the configurator UI | `true` |
| `configurator.username`                 | If this and password (below) are set, will require basic auth to access the configurator UI  | `` |
| `configurator.password`                 | If this and username (above) are set, will require basic auth to access the configurator UI. password is in the format of a sha256 hash (e.g. "test" would be "{sha256}9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08")  | `` |
| `configurator.extraEnv`                 | Extra ENV vars to pass to the configuration UI | `{}` |
| `configurator.ingress.enabled`          | Enables Ingress for the configurator UI | `false` |
| `configurator.ingress.annotations`      | Ingress annotations for the configurator UI | `{}` |
| `configurator.ingress.hosts`            | Ingress accepted hostnames for the configurator UI | `chart-example.local` |
| `configurator.ingress.tls`              | Ingress TLS configuration for the configurator UI | `[]` |
| `configurator.strategy.type`            | hass-configurator Deployment Strategy type | `` |
| `configurator.tolerations`              | Toleration labels for pod assignment for the configurator UI | `[]` |
| `configurator.nodeSelector`             | Node labels for pod assignment for the configurator UI | `{}` |
| `configurator.schedulerName`            | Use an alternate scheduler, e.g. "stork" for the configurator UI | `` |
| `configurator.podAnnotations`           | Affinity settings for pod assignment for the configurator UI | `{}` |
| `configurator.resources`                | CPU/Memory resource requests/limits for the configurator UI | `{}` |
| `configurator.securityContext`          | Security context to be added to hass-configurator pods for the configurator UI | `{}` |
| `configurator.service.type`             | Kubernetes service type for the configurator UI | `ClusterIP` |
| `configurator.service.port`             | Kubernetes port where the configurator UI is exposed| `3218` |
| `configurator.service.nodePort`         | nodePort to listen on for the configurator UI | `` |
| `configurator.service.annotations`      | Service annotations for the configurator UI | `{}` |
| `configurator.service.labels`           | Service labels to use for the configurator UI | `{}` |
| `configurator.service.clusterIP`        | Cluster IP for the configurator UI | `` |
| `configurator.service.externalIPs`      | External IPs for the configurator UI | `[]` |
| `configurator.service.loadBalancerIP`   | Loadbalancer IP for the configurator UI | `` |
| `configurator.service.loadBalancerSourceRanges`   | Loadbalancer client IP restriction range for the configurator UI | `[]` |
| `vscode.enabled`                  | Enable the optional [VS Code Server Sidecar](https://github.com/cdr/code-server) | `false` |
| `vscode.image.repository`         | Image repository | `codercom/code-server` |
| `vscode.image.tag`                | Image tag | `3.1.1`|
| `vscode.image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `vscode.hassConfig`               | Base path of the home assistant configuration files | `/config` |
| `vscode.vscodePath`               | Base path of the VS Code configuration files | `/config/.vscode` |
| `vscode.password`                 | If this is set, will require a password to access the VS Code Server UI | `` |
| `vscode.extraEnv`                 | Extra ENV vars to pass to the configuration UI | `{}` |
| `vscode.ingress.enabled`          | Enables Ingress for the VS Code UI | `false` |
| `vscode.ingress.annotations`      | Ingress annotations for the VS Code UI | `{}` |
| `vscode.ingress.hosts`            | Ingress accepted hostnames for the VS Code UI | `chart-example.local` |
| `vscode.ingress.tls`              | Ingress TLS configuration for the VS Code UI | `[]` |
| `vscode.resources`                | CPU/Memory resource requests/limits for the VS Code UI | `{}` |
| `vscode.securityContext`          | Security context to be added to hass-vscode pods for the VS Code UI | `{}` |
| `vscode.service.type`             | Kubernetes service type for the VS Code UI | `ClusterIP` |
| `vscode.service.port`             | Kubernetes port where the vscode UI is exposed| `80` |
| `vscode.service.nodePort`         | nodePort to listen on for the VS Code UI | `` |
| `vscode.service.annotations`      | Service annotations for the VS Code UI | `{}` |
| `vscode.service.labels`           | Service labels to use for the VS Code UI | `{}` |
| `vscode.service.clusterIP`        | Cluster IP for the VS Code UI | `` |
| `vscode.service.externalIPs`      | External IPs for the VS Code UI | `[]` |
| `vscode.service.loadBalancerIP`   | Loadbalancer IP for the VS Code UI | `` |
| `vscode.service.loadBalancerSourceRanges`   | Loadbalancer client IP restriction range for the VS Code UI | `[]` |
| `appdaemon.enabled`                  | Enable the optional [Appdaemon Sidecar](https://appdaemon.readthedocs.io/en/latest/) | `false` |
| `appdaemon.image.repository`         | Image repository | `acockburn/appdaemon` |
| `appdaemon.image.tag`                | Image tag | `3.0.5`|
| `appdaemon.image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `appdaemon.haToken`                  | Home Assistant API token - you need to generate it in your Home Assistant profile and then copy here | `` |
| `appdaemon.extraEnv`                 | Extra ENV vars to pass to the AppDaemon container | `{}` |
| `appdaemon.ingress.enabled`          | Enables Ingress for the AppDaemon UI | `false` |
| `appdaemon.ingress.annotations`      | Ingress annotations for the AppDaemon UI | `{}` |
| `appdaemon.ingress.hosts`            | Ingress accepted hostnames for the AppDaemonUI | `appdaemon.local` |
| `appdaemon.ingress.tls`              | Ingress TLS configuration for the AppDaemon UI | `[]` |
| `appdaemon.resources`                | CPU/Memory resource requests/limits for the AppDaemon | `{}` |
| `appdaemon.securityContext`          | Security context to be added to hass-appdaemon container | `{}` |
| `appdaemon.service.type`             | Kubernetes service type for the AppDaemon UI | `ClusterIP` |
| `appdaemon.service.port`             | Kubernetes port where the AppDaemon UI is exposed| `5050` |
| `appdaemon.service.nodePort`         | nodePort to listen on for the AppDaemon UI | `` |
| `appdaemon.service.annotations`      | Service annotations for the AppDaemon UI | `{}` |
| `appdaemon.service.labels`           | Service labels to use for the AppDaemon UI | `{}` |
| `appdaemon.service.clusterIP`        | Cluster IP for the AppDaemon UI | `` |
| `appdaemon.service.externalIPs`      | External IPs for the AppDaemon UI | `[]` |
| `appdaemon.service.loadBalancerIP`   | Loadbalancer IP for the AppDaemon UI | `` |
| `appdaemon.service.loadBalancerSourceRanges`   | Loadbalancer client IP restriction range for the VS Code UI | `[]` |
| `resources`                | CPU/Memory resource requests/limits or the home-assistant GUI | `{}` |
| `nodeSelector`             | Node labels for pod assignment or the home-assistant GUI | `{}` |
| `tolerations`              | Toleration labels for pod assignment or the home-assistant GUI | `[]` |
| `affinity`                 | Affinity settings for pod assignment or the home-assistant GUI | `{}` |
| `podAnnotations`            | Key-value pairs to add as pod annotations  | `{}` |
| `extraVolumes`            | Any extra volumes to define for the pod  | `{}` |
| `extraVolumeMounts`       | Any extra volumes mounts to define for each container of the pod  | `{}` |
| `monitoring.enabled`                          | Enables Monitoring support | `false` |
| `monitoring.serviceMonitor.enabled`           | Setup a ServiceMonitor to configure scraping | `false` |
| `monitoring.serviceMonitor.namespace`         | Set the namespace the ServiceMonitor should be deployed | `false` |
| `monitoring.serviceMonitor.interval`          | Set how frequently Prometheus should scrape | `30` |
| `monitoring.serviceMonitor.labels`            | Set labels for the ServiceMonitor, use this to define your scrape label for Prometheus Operator | `{}` |
| `monitoring.serviceMonitor.bearerTokenFile`   | Set bearerTokenFile for home-assistant auth (use long lived access tokens) | `nil` |
| `monitoring.serviceMonitor.bearerTokenSecret` | Set bearerTokenSecret for home-assistant auth (use long lived access tokens) | `nil` |




Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
  --set configurator.hassApiPassword="$HASS_API_PASSWORD" \
    stable/home-assistant
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml stable/home-assistant
```

Read through the [values.yaml](values.yaml) file. It has several commented out suggested values.

## Configuring home assistant

Much of the home assistant configuration occurs inside the various files persisted to the `/config` directory.  This will require external access to the persistent storage location where the home assistant configuration data is stored.  Because this may be a limitation, there are two options built-in to this chart:

### Configurator UI

[Home Assistant Configurator UI](https://github.com/danielperna84/hass-configurator) is added as an optional sidecar container to Home Assistant with access to the home assistant configuration for easy in-browser editing and manipulation of Home Assistant.

### VS Code Server

[VS Code Server](https://github.com/cdr/code-server) is added as an optional sidecar container to Home Assistant with access to the home assistant configuration for easy in-browser editing and manipulation of Home Assistant.  If using this, it is possible to manually install the [Home Assistant Config Helper Extension](https://github.com/keesschollaart81/vscode-home-assistant) in order to have a deeper integration with Home Assistant within VS Code while editing the configuration files.

### AppDaemon
[AppDaemon](https://www.home-assistant.io/docs/ecosystem/appdaemon/) is added as an optional sidecar container to Home Assistant with access to the home assistant configuration `/config/appdaemon`. This allows downloading apps with [HACS](https://github.com/hacs/integration)
[Home Assistant Configurator UI](https://github.com/danielperna84/hass-configurator) is added as an optional sidecar container to Home Assistant with access to the home assistant configuration for easy in-browser editing and manipulation of Home Assistant.

## Git sync secret

In order to sync the home assistant from a git repo, you have to store a ssh key as a kubernetes git secret
```console
kubectl create secret generic git-creds --from-file=id_rsa=git/k8s_id_rsa --from-file=known_hosts=git/known_hosts --from-file=id_rsa.pub=git/k8s_id_rsa.pub
```
