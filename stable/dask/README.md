# Dask Helm Chart

Dask allows distributed computation in Python.

-  https://dask.pydata.org
-  http://jupyter.org/


## Chart Details

This chart will deploy the following:

-   1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer
-   3 x Dask workers that connect to the scheduler
-   1 x Jupyter notebook with port 80 exposed on an external LoadBalancer
-   All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/dask
```

## Configuration

The following tables lists the configurable parameters of the Dask chart and their default values.

### Dask scheduler

| Parameter                  | Description              | Default          |
| -------------------------- | -------------------------| -----------------|
| `scheduler.name`           | Dask scheduler name      | `scheduler`      |
| `scheduler.image`          | Container image name     | `daskdev/dask`   |
| `scheduler.imageTag`       | Container image tag      | `latest`         |
| `scheduler.replicas`       | k8s deployment replicas  | `1`              |
| `scheduler.component`      | k8s selector key         | `dask-scheduler` |
| `scheduler.resources`      | Container resources      | `{}`             |

### Dask webUI

| Parameter             | Description       | Default   |
|-----------------------|-------------------|-----------|
| `webUI.name`          | Dask webui name   | `webui`   |
| `webUI.servicePort`   | k8s service port  | `80`      |

### Dask worker

| Parameter                    | Description                      | Default        |
| -----------------------      | ---------------------------------| ---------------|
| `worker.name`                | Dask worker name                 | `worker`       |
| `worker.image`               | Container image name             | `daskdev/dask` |
| `worker.imageTag`            | Container image tag              | `0.17.1`       |
| `worker.replicas`            | k8s hpa and deployment replicas  | `3`            |
| `worker.component`           | k8s selector key                 | `dask-worker`  |
| `worker.resources`           | Container resources              | `{}`           |
| `worker.pipPackages`         | Extra pip packages to install    | ``             |
| `worker.aptPackages`         | Extra apt packages to install    | ``             |
| `worker.condaPackages`       | Extra conda packages to install  | ``             |
|

### jupyter

| Parameter               | Description                      | Default                  |
|-------------------------|----------------------------------|--------------------------|
| `jupyter.name`          | jupyter name                     | `jupyter`                |
| `jupyter.image`         | Container image name             | `daskdev/dask-notebook`  |
| `jupyter.imageTag`      | Container image tag              | `0.17.1`                 |
| `jupyter.replicas`      | k8s deployment replicas          | `1`                      |
| `jupyter.component`     | k8s selector key                 | `jupyter`                |
| `jupyter.servicePort`   | k8s service port                 | `80`                     |
| `jupyter.resources`     | Container resources              | `{}`                     |
| `jupyter.pipPackages`   | Extra pip packages to install    | ``                       |
| `jupyter.aptPackages`   | Extra apt packages to install    | ``                       |
| `jupyter.condaPackages` | Extra conda packages to install  | ``                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dask
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Extra Packages

You can install extra packages in your Jupyter notebook and Dask workers by
using the  `apt/pip/condaPackages` variables.  These should match for any
Python libraries that are likely to be called on the workers (like numpy,
pandas, and so on).  These variables only work when using Docker images that
extend the default images `daskdev/dask` and `daskdev/dask-notebook`.
