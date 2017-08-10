# Dask Distributed Helm Chart

Dask Distributed allows distributed computation in Python the chart also includes a single user Jupyter Notebook.

* https://github.com/dask/distributed
* http://jupyter.org/

## Chart Details
This chart will do the following:

* 1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer
* 3 x Dask workers that connect to the scheduler
* 1 x Jupyter notebook with port 80 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/dask-distributed
```

## Configuration

The following tables lists the configurable parameters of the Dask chart and their default values.

### Dask scheduler

| Parameter                  | Description                        | Default                                                    |
| -------------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `scheduler.name`           | Dask master name                   | `dask-master`                                              |
| `scheduler.image`          | Container image name               | `dask2/dask`                                               |
| `scheduler.imageTag`       | Container image tag                | `latest`                                                   |
| `scheduler.replicas`       | k8s deployment replicas            | `1`                                                        |
| `scheduler.component`      | k8s selector key                   | `dask-scheduler`                                           |
| `scheduler.cpu`            | container requested cpu            | `500m`                                                     |
| `scheduler.containerPort`  | Container listening port           | `8786`                                                     |
| `scheduler.resources`      | Container resources                | `{}`                                                       |

### Dask webUI

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `webUI.name`          | Dask webui name                  | `dask-webui`                                             |
| `webUI.servicePort`   | k8s service port                 | `8787`                                                   |
| `webUI.containerPort` | Container listening port         | `8787`                                                   |

### Dask worker

| Parameter                    | Description                          | Default                                                    |
| -----------------------      | ------------------------------------ | ---------------------------------------------------------- |
| `worker.name`                | Dask worker name                     | `dask-worker`                                              |
| `worker.image`               | Container image name                 | `daskdev/dask`                                             |
| `worker.imageTag`            | Container image tag                  | `1.5.1_v3`                                                 |
| `worker.replicas`            | k8s hpa and deployment replicas      | `3`                                                        |
| `worker.replicasMax`         | k8s hpa max replicas                 | `10`                                                       |
| `worker.component`           | k8s selector key                     | `dask-worker`                                              |
| `worker.containerPort`       | Container listening port             | `7077`                                                     |
| `worker.resources`           | Container resources                  | `{}`                                                       |

### jupyter

|       Parameter         |           Description            |                         Default                          |
|-------------------------|----------------------------------|----------------------------------------------------------|
| `jupyter.name`          | jupyter name                     | `jupyter`                                                |
| `jupyter.image`         | Container image name             | `jupyter/base-notebook`                                  |
| `jupyter.imageTag`      | Container image tag              | `11be019e4079`                                           |
| `jupyter.replicas`      | k8s deployment replicas          | `1`                                                      |
| `jupyter.component`     | k8s selector key                 | `jupyter`                                                |
| `jupyter.servicePort`   | k8s service port                 | `80`                                                     |
| `jupyter.containerPort` | Container listening port         | `8888`                                                   |
| `jupyter.resources`     | Container resources              | `{}`                                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dask
```

> **Tip**: You can use the default [values.yaml](values.yaml)
