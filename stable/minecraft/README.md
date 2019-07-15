# Minecraft

[Minecraft](https://minecraft.net/en/) is a game about placing blocks and going on adventures.

## Introduction

This chart creates a single Minecraft Pod, plus Services for the Minecraft server and RCON.

## Prerequisites

- 512 MB of RAM
- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`, read the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula) run:

```bash
$ helm install --name my-release \
    --set minecraftServer.eula=true stable/minecraft
```

It is important to note that the deployment will not run correctly without specifying a Server Type.  For example...
```bash
$ helm install --name my-release \
    --set minecraftServer.type=VANILLA stable/minecraft
```
Acceptable values include the following - "FORGE", "SPIGOT", "BUKKIT", "PAPER", "FTB", "SPONGEVANILLA"

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

```bash
$ helm del --purge my-release

```
This command will delete the Kubernetes components, as well as remove the release name from Helm so that the release name can be re-used.

## Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults. These are a mixture of Kubernetes and Minecraft-related directives that map to environment variables in the [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server/) Docker image.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set minecraftServer.eula=true,minecraftServer.Difficulty=hard \
    stable/minecraft
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/minecraft
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server/) image stores the saved games and mods under /data.

By default a PersistentVolumeClaim is created and mounted for saves but not mods. In order to disable this functionality
you can change the values.yaml to disable persistence under the sub-sections under `persistence`.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*
