# Dask Distributed Helm Chart

Dask Distributed allows distributed computation in Python the chart also includes a single user Jupyter Notebook

* https://github.com/dask/distributed
* http://jupyter.org/

## Chart Details
This chart will do the following:

* 1 x Dask Scheduler with port 8786 (scheduler) and 8786 (webUI) exposed on an external LoadBalancer
* 3 x Dask Workers that connect to the scheduler
* 1 x Jupyter notebok with port 80 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/dask
```

## Configuration

The following tables lists the configurable parameters of the Dask chart and their default values.

### Dask Scheduler

| Parameter                  | Description                        | Default                                                    |
| -------------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Scheduler.Name`           | Dask master name                   | `dask-master`                                              |
| `Scheduler.Image`          | Container image name               | `dask2/dask`                                               |
| `Scheduler.ImageTag`       | Container image tag                | `latest`                                                   |
| `Scheduler.Replicas`       | k8s deployment replicas            | `1`                                                        |
| `Scheduler.Component`      | k8s selector key                   | `dask-scheduler`                                           |
| `Scheduler.Cpu`            | container requested cpu            | `500m`                                                     |
| `Scheduler.Memory`         | container requested memory         | `1024Mi`                                                   |
| `Scheduler.ServicePort`    | k8s service port                   | `8786`                                                     |
| `Scheduler.ContainerPort`  | Container listening port           | `8786`                                                     |

### Dask WebUI

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `WebUI.Name`          | Dask webui name                  | `dask-webui`                                             |
| `WebUI.ServicePort`   | k8s service port                 | `8787`                                                   |
| `WebUI.ContainerPort` | Container listening port         | `8787`                                                   |

### Dask Worker

| Parameter                    | Description                          | Default                                                    |
| -----------------------      | ------------------------------------ | ---------------------------------------------------------- |
| `Worker.Name`                | Dask worker name                     | `dask-worker`                                              |
| `Worker.Image`               | Container image name                 | `dask2/dask`                                               |
| `Worker.ImageTag`            | Container image tag                  | `1.5.1_v3`                                                 |
| `Worker.Replicas`            | k8s hpa and deployment replicas      | `3`                                                        |
| `Worker.ReplicasMax`         | k8s hpa max replicas                 | `10`                                                       |
| `Worker.Component`           | k8s selector key                     | `dask-worker`                                              |
| `Worker.Cpu`                 | container requested cpu              | `100m`                                                     |
| `Worker.Memory`              | container requested memory           | `1024Mi`                                                   |
| `Worker.ContainerPort`       | Container listening port             | `7077`                                                     |

### Jupyter

|       Parameter         |           Description            |                         Default                          |
|-------------------------|----------------------------------|----------------------------------------------------------|
| `Jupyter.Name`          | Jupyter name                     | `jupyter-controller`                                     |
| `Jupyter.Image`         | Container image name             | `jupyter/base-notebook`                                  |
| `Jupyter.ImageTag`      | Container image tag              | `11be019e4079`                                           |
| `Jupyter.Replicas`      | k8s deployment replicas          | `1`                                                      |
| `Jupyter.Component`     | k8s selector key                 | `jupyter`                                                |
| `Jupyter.Cpu`           | container requested cpu          | `100m`                                                   |
| `Jupyter.Memory`        | container requested memory       | `1024Mi`                                                 |
| `Jupyter.ServicePort`   | k8s service port                 | `80`                                                     |
| `Jupyter.ContainerPort` | Container listening port         | `8888`                                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dask
```

> **Tip**: You can use the default [values.yaml](values.yaml)
