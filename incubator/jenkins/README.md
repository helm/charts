# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

Inspired by the awesome work of Carlos Sanchez <carlos@apache.org>

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release jenkins-x.x.x.tgz
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Master.Name`         | Jenkins master name                | `jenkins-master`                                           |
| `Master.Image`        | Container image name             | `csanchez/jenkins-swarm`                         |
| `Master.ImageTag`     | Container image tag              | `latest`                                               |
| `Master.ImagePullPolicy`     | Container pull policy     | `Always`                                               |
| `Master.Component`    | k8s selector key                 | `jenkins-master`                                           |
| `Master.Cpu`          | container requested cpu          | `200m`                                                   |
| `Master.Memory`    |container requested memory                 | `512Mi`                                           |
| `Master.ServicePort`  | k8s service port                 | `8080`                                                   |
| `Master.ContainerPort`| Container listening port         | `8080`                                                   |
| `Master.SlaveListenerPort`| Container jekins slave listening port         | `50000`                                                   |

### Jenkins Agent

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Agent.Image`        | Container image name             | `csanchez/jenkins-swarm-slave`                         |
| `Agent.ImageTag`     | Container image tag              | `1.5.1_v3`                                               |                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml jenkins-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A Persistent Volume
Claim is used to keep the data across deployments. This is know to work in GCE, AWS, and minikube. 

# Todo
* Enable Docker-in-Docker or Docker-on-Docker support on the jenkins-slaves
