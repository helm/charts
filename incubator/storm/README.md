## Storm
[Apache Storm](http://storm.apache.org/) is a free and open source distributed realtime computation system. Storm makes it easy to reliably process unbounded streams of data, doing for realtime processing what Hadoop did for batch processing. Storm is simple, can be used with any programming language, and is a lot of fun to use!

### Prerequisites

This example assumes you have a Kubernetes cluster installed and
running, and that you have installed the ```kubectl``` command line
tool somewhere in your path. Please see the [getting
started](https://kubernetes.io/docs/tutorials/kubernetes-basics/) for installation
instructions for your platform.

### Installing the Chart

To install the chart with the release name `my-storm`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-storm incubator/storm
```

## Configuration

The following table lists the configurable parameters of the Storm chart and their default values.

### Nimbus
| Parameter                         | Description                 | Default             |
| --------------------------------- | --------------------------- | ------------------- |
| `nimbus.replicaCount`             | Number of replicas          | 1                   |
| `nimbus.image.repository`         | Container image name        | storm               |
| `nimbus.image.tag`                | Container image version     | 1.1.1               |
| `nimbus.image.pullPolicy`         | The default pull policy     | IfNotPresent        |
| `nimbus.service.name`             | Service name                | nimbus              |
| `nimbus.service.type`             | Service Type                | ClusterIP           |
| `nimbus.service.port`             | Service Port                | 6627                |
| `nimbus.resources.limits.cpu`     | Compute resources           | 100m                |

### Supervisor
| Parameter                         | Description                 | Default             |
| --------------------------------- | --------------------------- | ------------------- |
| `supervisor.replicaCount`         | Number of replicas          | 3                   |
| `supervisor.image.repository`     | Container image name        | storm               |
| `supervisor.image.tag`            | Container image version     | 1.1.1               |
| `supervisor.image.pullPolicy`     | The default pull policy     | IfNotPresent        |
| `supervisor.service.name`         | Service Name                | supervisor          |
| `supervisor.service.port`         | Service Port                | 6700                |
| `supervisor.resources.limits.cpu` | Compute Resouces            | 200m                |  

### User Interface   
| Parameter                         | Description                 | Default             |
| --------------------------------- | --------------------------- | ------------------- |                      
| `ui.enabled`                      | Enable the UI               | true                |
| `ui.replicaCount`                 | Number of replicas          | 1                   |
| `ui.image.repository`             | Container image name        | storm               |
| `ui.image.tag`                    | UI image version            | 1.1.1               |
| `ui.image.pullPolicy`             | The default pull policy     | IfNotPresent        |
| `ui.service.type`                 | UI Service Type             | ClusterIP           |
| `ui.service.name`                 | UI service name             | ui                  |
| `ui.service.port`                 | UI service port             | 8080                |
| `ui.resources.limits.cpu`         | Compute resources           | 100m                |

### Zookeeper
| Parameter                         | Description                 | Default             |
| --------------------------------- | --------------------------- | ------------------- |
| `zookeeper.enabled`               | Enable Zookeeper            | true                |
| `zookeeper.service.name`          | Service name                | zookeeper           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/storm
```

> **Tip**: You can use the default [values.yaml](values.yaml)
