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
| `Master.Image`        | Master image name             | `gcr.io/kubernetes-charts-ci/jenkins-master-k8s`                         |
| `Master.ImageTag`     | Master image tag              | `v0.1.0`                                               |
| `Master.ImagePullPolicy`     | Master image pull policy     | `Always`                                               |
| `Master.Component`    | k8s selector key                 | `jenkins-master`                                           |
| `Master.Cpu`          | Master requested cpu          | `200m`                                                   |
| `Master.Memory`       | Master requested memory                 | `256Mi`                                           |
| `Master.ServicePort`  | k8s service port                 | `8080`                                                   |
| `Master.ContainerPort`| Master listening port         | `8080`                                                   |
| `Master.SlaveListenerPort`|  Listening port for agents        | `50000`                                                   |

### Jenkins Agent

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Agent.Image`        | Agent image name             | `jenkinsci/jnlp-slave`                         |
| `Agent.ImageTag`     | Agent image tag              | `2.52`                                               |                                                 |
| `Agent.Cpu`          | Agent requested cpu          | `200m`                                                   |
| `Agent.Memory`    | Agent requested memory                 | `256Mi`                                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml jenkins-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A Persistent Volume
Claim is used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

# Todo
* Enable Docker-in-Docker or Docker-on-Docker support on the Jenkins agents
