# Dask Helm Chart

Dask allows distributed computation in Python.

-  https://dask.pydata.org
-  http://jupyter.org/


## Chart Details

This chart will deploy the following:

-   1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer
-   3 x Dask workers that connect to the scheduler
-   1 x Jupyter notebook (optional) with port 80 exposed on an external LoadBalancer
-   All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/dask
```

## Configuration

The following tables list the configurable parameters of the Dask chart and their default values.

### Dask scheduler

| Parameter                  | Description              | Default          |
| -------------------------- | -------------------------| -----------------|
| `scheduler.name`           | Dask scheduler name      | `scheduler`      |
| `scheduler.image`          | Container image name     | `daskdev/dask`   |
| `scheduler.imageTag`       | Container image tag      | `1.1.0`         |
| `scheduler.replicas`       | k8s deployment replicas  | `1`              |
| `scheduler.tolerations`    | Tolerations              | `[]`             |
| `scheduler.nodeSelector`   | nodeSelector             | `{}`             |
| `scheduler.affinity`       | Container affinity       | `{}`             |

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
| `worker.imageTag`            | Container image tag              | `1.1.0`        |
| `worker.replicas`            | k8s hpa and deployment replicas  | `3`            |
| `worker.resources`           | Container resources              | `{}`           |
| `worker.tolerations`         | Tolerations                      | `[]`           |
| `worker.nodeSelector`        | nodeSelector                     | `{}`           |
| `worker.affinity`            | Container affinity               | `{}`           |
|

### jupyter

| Parameter               | Description                      | Default                  |
|-------------------------|----------------------------------|--------------------------|
| `jupyter.name`          | Jupyter name                     | `jupyter`                |
| `jupyter.enabled`       | Include optional Jupyter server  | `true`                   |
| `jupyter.image`         | Container image name             | `daskdev/dask-notebook`  |
| `jupyter.imageTag`      | Container image tag              | `1.1.0`                  |
| `jupyter.replicas`      | k8s deployment replicas          | `1`                      |
| `jupyter.servicePort`   | k8s service port                 | `80`                     |
| `jupyter.resources`     | Container resources              | `{}`                     |
| `jupyter.tolerations`   | Tolerations                      | `[]`                     |
| `jupyter.nodeSelector`  | nodeSelector                     | `{}`                     |
| `jupyter.affinity`      | Container affinity               | `{}`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dask
```

> **Tip**: You can use the default [values.yaml](values.yaml)


### Customizing Python Environment

The default `daskdev/dask` images have a standard Miniconda installation along
with some common packages like NumPy and Pandas.  You can install custom packages
with either Conda or Pip using optional environment variables.  This happens
when your container starts up.  Consider the following config.yaml file as an
example:

```yaml
jupyter:
  env:
    -  EXTRA_PIP_PACKAGES: s3fs git+https://github.com/user/repo.git --upgrade
    -  EXTRA_CONDA_PACKAGES: scipy matplotlib -c conda-forge

worker:
  env:
    -  EXTRA_PIP_PACKAGES: s3fs git+https://github.com/user/repo.git --upgrade
    -  EXTRA_CONDA_PACKAGES: scipy -c conda-forge
```

Note that the Jupyter and Dask worker environments should have matching
software environments, at least where a user is likely to distribute that
functionality.
