# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins swarm plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin

Inspired by the awesome work of Carlos Sanchez <carlos@apache.org>

* https://hub.docker.com/r/csanchez/jenkins-swarm/
* https://hub.docker.com/r/csanchez/jenkins-swarm-slave/

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* 3 x Jenkins Slaves with HorizontalPodAutoscaler
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
| `Master.Name`         | Spark master name                | `jenkins-master`                                           |
| `Master.Image`        | Container image name             | `csanchez/jenkins-swarm`                         |
| `Master.ImageTag`     | Container image tag              | `latest`                                               |
| `Master.ImagePullPolicy`     | Container pull policy     | `Always`                                               |
| `Master.Replicas`     | k8s deployment replicas          | `1`                                                      |
| `Master.Component`    | k8s selector key                 | `jenkins-master`                                           |
| `Master.Cpu`          | container requested cpu          | `100m`                                                   |
| `Master.Memory`    |container requested memory                 | `512Mi`                                           |
| `Master.ServicePort`  | k8s service port                 | `8080`                                                   |
| `Master.ContainerPort`| Container listening port         | `8080`                                                   |
| `Master.SlaveListenerPort`| Container jekins slave listening port         | `50000`                                                   |

### Jenkins Slave

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Worker.Name`         | Spark worker name                | `jenkins-slave`                                           |
| `Worker.Image`        | Container image name             | `csanchez/jenkins-swarm-slave`                         |
| `Worker.ImageTag`     | Container image tag              | `1.5.1_v3`                                               |
| `Worker.Replicas`     | k8s hpa and deployment replicas  | `3`                                                      |
| `Worker.ReplicasMax`  | k8s hpa max replicas          | `10`                                                      |
| `Worker.Component`    | k8s selector key                 | `jenkins-slave`                                           |
| `Worker.Cpu`          | container requested cpu          | `200m`                                                   |
| `Worker.Memory`    |container requested memory                 | `256Mi`                                           |
| `Worker.ContainerPort`| Container listening port         | `800`                                                   |
| `Worker.CpuTargetPercentage`| k8s hpa cpu targetPercentage | `50`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml jenkins-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container.

As a placeholder, the chart mounts an [emptyDir](http://kubernetes.io/docs/user-guide/volumes/#emptydir) volume at this location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

For persistence of the data you should replace the `emptyDir` volume with a persistent [storage volume](http://kubernetes.io/docs/user-guide/volumes/), else the data will be lost if the Pod is shutdown.

# Todo
* Enable Docker-in-Docker or Docker-on-Docker support on the jenkins-slaves

# Limitations
* Non configurable jenkins DNS name for slave bootstrapping (k8s service hardcoded to jenkins)
