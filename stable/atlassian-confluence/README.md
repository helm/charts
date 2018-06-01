# Atlassian Confluence

[Atlassian Confluence](https://www.atlassian.com/software/confluence) is an enterprise wiki collaboration platform.

This chart bootstraps a deployment with the [atlassian/confluence-server](https://bitbucket.org/atlassian/docker-atlassian-confluence-server) image on a Kubernetes cluster.


## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- At least 2GB Memory


## Getting Started

To install the chart with the release name `atlassian-confluence`:

```sh
helm install stable/atlassian-confluence --name atlassian-confluence
```

It takes a few minutes to bootstrap a Confluence server.
Then open your browser and you will see the [Confluence Setup Wizard](https://confluence.atlassian.com/doc/confluence-setup-guide-135691.html).
The wizard may freeze while database initialization. Hang tight.

To delete the release `atlassian-confluence`:

```sh
helm delete atlassian-confluence
```


## Configuration

The following table lists the configurable parameters of the chart and their default values.

Parameter | Description | Default
----------|-------------|--------
`confluence.reverseProxyHost` | Hostname of the server. | `confluence.example.com`
`confluence.reverseProxyPort` | Port of the server. | `443`
`confluence.reverseProxyScheme` | `http` or `https`. | `https`
`confluence.javaHeapSize` | JavaVM heap size passed as `-Xmx` and `-Xms`. | `1024m`
`confluence.javaMemoryOptions` | JavaVM memory options. | `-XX:MaxMetaSpaceSize=300m -XX:DirectMemorySize=10m`
`confluence.javaOptions` | JavaVM options. | ``
`synchrony.javaHeapSize` | JavaVM heap size for Synchrony. | `0m` (disable Synchrony)
`persistence.enabled` | Create a persistent volume to store data. | `true`
`persistence.size` | Size of a persistent volume. | `8Gi`
`persistence.storageClass` | Type of a persistent volume. | `nil`
`persistence.existingClaim` | Name of the existing persistent volume. | `nil`
`ingress.enabled` |	Enable ingress controller resource.	| `false`
`ingress.hosts`	| Hostnames. | `[]`
`resources.limits` | Pod resource limits. | `{}`
`resources.requests` | Pod resource requests. | `{}`
`nodeSelector` | Node labels for pod assignment | `{}`


### Resources Limits

It is highly recommended to set resources limits for the following reasons.

- Set memory request and limit to prevent containers suddenly die due to OOM killer.
- Set CPU limit to prevent other pods fail liveness probe and die.

You can calculate memory size by:

```
[resources.limits.memory] = [confluence.javaHeapSize] + 800MiB
```

Here is an example of resources limits:

```yaml
# values.yaml
confluence:
  javaHeapSize: 1024m
resources:
  limits:
    memory: 1800Mi
    cpu: 800m
  requests:
    memory: 1800Mi
    cpu: 0
```


### Persistence

Confluence stores data into both database and filesystem.
You can choose one of the following types in the setup wizard:

1. Use an embedded H2 database in the same volume.
1. Use an external database.

This chart creates a `PersistentVolumeClaim` with 8GB volume by default.
You can set size as follows:

```yaml
# values.yaml
persistence:
  size: 100Gi
```


### Synchrony (collaborative editing)

Confluence provides the collaborative editing feature.
It needs Synchrony which is a separate process executed by Confluence.
See [Administering Collaborative Editing](https://confluence.atlassian.com/doc/administering-collaborative-editing-858772086.html) for details.

Synchrony is disabled by default in this chart because it requires much memory.
You can enable it as follows:

```yaml
# values.yaml
synchrony:
  javaHeapSize: 1024m
```

Also you need to increase the memory request and limit.


## Upgrade Confluence

To upgrade to a more recent version of Confluence:

```sh
helm upgrade atlassian-confluence
```
