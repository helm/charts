# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

Inspired by the awesome work of Carlos Sanchez <carlos@apache.org>

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/jenkins
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master


| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `Master.Name`              | Jenkins master name                | `jenkins-master`                                           |
| `Master.Image`             | Master image name                  | `gcr.io/kubernetes-charts-ci/jenkins-master-k8s`           |
| `Master.ImageTag`          | Master image tag                   | `v0.1.0`                                                   |
| `Master.ImagePullPolicy`   | Master image pull policy           | `Always`                                                   |
| `Master.Component`         | k8s selector key                   | `jenkins-master`                                           |
| `Master.Cpu`               | Master requested cpu               | `200m`                                                     |
| `Master.Memory`            | Master requested memory            | `256Mi`                                                    |
| `Master.ServiceType`       | k8s service type                   | `LoadBalancer`                                             |
| `Master.ServicePort`       | k8s service port                   | `8080`                                                     |
| `Master.NodePort`          | k8s node port                      | Not set                                                    |
| `Master.ContainerPort`     | Master listening port              | `8080`                                                     |
| `Master.SlaveListenerPort` | Listening port for agents          | `50000`                                                    |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses| `0.0.0.0/0`                                                |
| `Master.CustomConfigMap`          | Use a custom ConfigMap             | `false`                                                    |
| `Master.Ingress.Annotations` | Ingress annotations       | `{}`                                                |
| `Master.Ingress.TLS` | Ingress TLS configuration       | `[]`                                                |
| `Master.InitScripts`       | List of Jenkins init scripts       | Not set                                                    |  

### Jenkins Agent

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Agent.Image`           | Agent image name                   | `jenkinsci/jnlp-slave`                                     |
| `Agent.ImageTag`        | Agent image tag                    | `2.52`                                                     |
| `Agent.Cpu`             | Agent requested cpu                | `200m`                                                     |
| `Agent.Memory`          | Agent requested memory             | `256Mi`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

### Persistence Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `Persistence.Enabled` | Enable the use of a Jenkins PVC | `true` |
| `Persistence.ExistingClaim` | Provide the name of a PVC | `nil` |
| `Persistence.AccessMode` | The PVC access mode | `ReadWriteOnce` |
| `Persistence.Size` | The size of the PVC | `8Gi` |
| `Persistence.volumes` | Additional volumes | `nil` |
| `Persistence.mounts` | Additional mounts | `nil` |


#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set Persistence.ExistingClaim=PVC_NAME stable/jenkins
```

## Custom ConfigMap

When creating a new chart with this chart as a dependency, CustomConfigMap can be used to override the default config.xml provided.
It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`. In the parent chart's values.yaml,
set the value to true and provide the file `templates/config.yaml` for your use case. If you start by copying `config.yaml` from this chart and
want to access values from this chart you must change all references from `.Values` to `.Values.jenkins`.

```
jenkins:
  Master:
    CustomConfigMap: true
```

# Todo
* Enable Docker-in-Docker or Docker-on-Docker support on the Jenkins agents
