# Dask Helm Chart

Dask allows distributed computation in Python.

- <https://dask.org>
- <https://jupyter.org/>

## Chart Details

This chart will deploy the following:

- 1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer (default)
- 3 x Dask workers that connect to the scheduler
- 1 x Jupyter notebook (optional) with port 80 exposed on an external LoadBalancer (default)
- All using Kubernetes Deployments

> **Tip**: See the [Kubernetes Service Type Docs](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
> for the differences between ClusterIP, NodePort, and LoadBalancer.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/dask
```

Depending on how your cluster was setup, you may also need to specify
a namespace with the following flag: `--namespace my-namespace`.

## Default Configuration

The following tables list the configurable parameters of the Dask chart and
their default values.

### Dask scheduler

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `scheduler.name`         | Dask scheduler name     | `scheduler`    |
| `scheduler.image`        | Container image name    | `daskdev/dask` |
| `scheduler.imageTag`     | Container image tag     | `1.1.5`        |
| `scheduler.replicas`     | k8s deployment replicas | `1`            |
| `scheduler.tolerations`  | Tolerations             | `[]`           |
| `scheduler.nodeSelector` | nodeSelector            | `{}`           |
| `scheduler.affinity`     | Container affinity      | `{}`           |

### Dask webUI

| Parameter                   | Description                        | Default              |
| --------------------------- | ---------------------------------- | -------------------- |
| `webUI.name`                | Dask webui name                    | `webui`              |
| `webUI.servicePort`         | k8s service port                   | `80`                 |
| `webUI.ingress.enabled`     | Enable ingress controller resource | false                |
| `webUI.ingress.hostname`    | Ingress resource hostnames         | dask-ui.example.com  |
| `webUI.ingress.tls`         | Ingress TLS configuration          | false                |
| `webUI.ingress.secretName`  | Ingress TLS secret name            | `dask-scheduler-tls` |
| `webUI.ingress.annotations` | Ingress annotations configuration  | null                 |

### Dask worker

| Parameter             | Description                     | Default        |
| --------------------- | ------------------------------- | -------------- |
| `worker.name`         | Dask worker name                | `worker`       |
| `worker.image`        | Container image name            | `daskdev/dask` |
| `worker.imageTag`     | Container image tag             | `1.1.5`        |
| `worker.replicas`     | k8s hpa and deployment replicas | `3`            |
| `worker.resources`    | Container resources             | `{}`           |
| `worker.tolerations`  | Tolerations                     | `[]`           |
| `worker.nodeSelector` | nodeSelector                    | `{}`           |
| `worker.affinity`     | Container affinity              | `{}`           |

### Jupyter

| Parameter                     | Description                        | Default                 |
| ----------------------------- | ---------------------------------- | ----------------------- |
| `jupyter.name`                | Jupyter name                       | `jupyter`               |
| `jupyter.enabled`             | Include optional Jupyter server    | `true`                  |
| `jupyter.image`               | Container image name               | `daskdev/dask-notebook` |
| `jupyter.imageTag`            | Container image tag                | `1.1.5`                 |
| `jupyter.replicas`            | k8s deployment replicas            | `1`                     |
| `jupyter.servicePort`         | k8s service port                   | `80`                    |
| `jupyter.resources`           | Container resources                | `{}`                    |
| `jupyter.tolerations`         | Tolerations                        | `[]`                    |
| `jupyter.nodeSelector`        | nodeSelector                       | `{}`                    |
| `jupyter.affinity`            | Container affinity                 | `{}`                    |
| `jupyter.ingress.enabled`     | Enable ingress controller resource | false                   |
| `jupyter.ingress.hostname`    | Ingress resource hostnames         | dask-ui.example.com     |
| `jupyter.ingress.tls`         | Ingress TLS configuration          | false                   |
| `jupyter.ingress.secretName`  | Ingress TLS secret name            | `dask-jupyter-tls`      |
| `jupyter.ingress.annotations` | Ingress annotations configuration  | null                    |

#### Jupyter Password

When launching the Jupyter server, you will be prompted for a password. The
default password set in [values.yaml](values.yaml) is `dask`.

```yaml
jupyter:
  ...
  password: 'sha1:aae8550c0a44:9507d45e087d5ee481a5ce9f4f16f37a0867318c' # 'dask'
```

To change this password, run `jupyter notebook password` in the command-line,
example below:

```bash
$ jupyter notebook password
Enter password: dask
Verify password: dask
[NotebookPasswordApp] Wrote hashed password to /home/dask/.jupyter/jupyter_notebook_config.json

$ cat /home/dask/.jupyter/jupyter_notebook_config.json
{
  "NotebookApp": {
    "password": "sha1:aae8550c0a44:9507d45e087d5ee481a5ce9f4f16f37a0867318c"
  }
}
```

Replace the `jupyter.password` field in [values.yaml](values.yaml) with the
hash generated for your new password.

## Custom Configuration

If you want to change the default parameters, you can do this in two ways.

### YAML Config Files

You can change the default parameters in `values.yaml`, or create your own
custom YAML config file, and specify this file when installing your chart with
the `-f` flag. Example:

```bash
helm install --name my-release -f values.yaml stable/dask
```

> **Tip**: You can use the default [values.yaml](values.yaml) for reference

### Command-Line Arguments

If you want to change parameters for a specific install without changing
`values.yaml`, you can use the `--set key=value[,key=value]` flag when running
`helm install`, and it will override any default values. Example:

```bash
helm install --name my-release --set jupyter.enabled=false stable/dask
```

### Customizing Python Environment

The default `daskdev/dask` images have a standard Miniconda installation along
with some common packages like NumPy and Pandas. You can install custom packages
with either Conda or Pip using optional environment variables. This happens
when your container starts up.

> **Note**: The `IP:PORT` of this chart's services will not be accessible until
> extra packages finish installing. Expect to wait at least a minute for the
> Jupyter Server to be accessible if adding packages below, like `numba`. This
> time will vary depending on which extra packages you choose to install.

Consider the following YAML config as an example:

```yaml
jupyter:
  env:
    - name: EXTRA_CONDA_PACKAGES
      value: numba xarray -c conda-forge
    - name: EXTRA_PIP_PACKAGES
      value: s3fs dask-ml --upgrade

worker:
  env:
    - name: EXTRA_CONDA_PACKAGES
      value: numba xarray -c conda-forge
    - name: EXTRA_PIP_PACKAGES
      value: s3fs dask-ml --upgrade
```

> **Note**: The Jupyter and Dask-worker environments should have matching
> software environments, at least where a user is likely to distribute that
> functionality.
