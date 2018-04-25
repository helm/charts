# Tomcat

[Tomcat](http://tomcat.apache.org) is is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies.

## Introduction

This chart creates a [tomcat application server](http://tomcat.apache.org) Deployment, plus http Services for the server.
The chart offers an optimization for application updates running in a servlet container-type engines like tomcat and [Jboss](http://jbossas.jboss.org). The chart uses the WAR, EAR, and other deployable components outside of the Servlet engine as sidecar container so application upgrades requires the sidecar container image only to be updated and not the Servlet engine as if both would run at the same image. 


## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled

## Provider-specific Prerequisites


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/tomcat
```

This command deploys a tomcat dedicated server with sane defaults.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the tomcat chart and their default values.

Parameter                  	| Description                        	| Default
------------------------------- | ------------------------------------- | ----------------------------------------------------------
`image.webarchive.repository`   | Sidecar image source repository name  | `ananwaresystems/webarchive`
`image.webarchive.tag`          | `webarchive` release tag.             | `1.0`
`image.tomcat.repository`       | Tomact image source repository name   | `ananwaresystems/tomcat`
`image.tomcat.tag`          	| `tomcat` release tag.                 | `7.0`
`image.pullPolicy`         	| Image pull policy                  	| `IfNotPresent`
`deploy.directory`		| Webarchive deployment directory	| `/root/apache-tomcat-7.0.42-v2/webapps`
`service.host.port`             | Tomcat host port                      | `8001`
`service.frontend.port`         | Frontend port                         | `8080`
`service.frontend.type`         | k8s service Frontend type             | `LoadBalancer`
`service.frontend.selector.app` | k8s service app selector              | `tomcat`
`service.frontend.selector.tier`| k8s service tier selector             | `frontend`
`resources`                	| CPU/Memory resource requests/limits	| `{}`
`NodeSelector.key`        	| Node affinity node label key       	| `{}`
`NodeSelector.value`        	| Node affinity node label value       	| `{}`
`Tolerations.key`        	| Node tolerations node label key       | `{}`
`Tolerations.value`        	| Node tolerations node label value     | `{}`

Refer to [values.yaml](values.yaml) for the full run-down on defaults. These are a mixture of Kubernetes and tomcat-related directives that map to environment variables. 

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set Values.someval=My Server,ImageTag=1.0 \
    stable/tomcat
```

The above command deploys Tomcat dedicated with a server name of `My Server` and docker-tomcat image version `1.0`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/stable
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

## Credits

[Java Web Application with Tomcat and Sidecar Container](https://github.com/kubernetes/examples/tree/master/staging/javaweb-tomcat-sidecar)
