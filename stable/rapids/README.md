# <div align="left"><img src="img/rapids_logo.png" width="90px"/>&nbsp;cuDF - GPU DataFrames</div> Helm Chart

The [RAPIDS](https://rapids.ai) suite of open source software libraries gives
you the freedom to execute end-to-end data science and analytics pipelines
entirely on GPUs. RAPIDS is incubated by NVIDIA® based on years of accelerated
data science experience. RAPIDS relies on NVIDIA CUDA® primitives for low-level
compute optimization, and exposes GPU parallelism and high-bandwidth memory
speed through user-friendly Python interfaces.

- <https://rapids.ai>
- <https://jupyter.org/>
- <https://hub.docker.com/r/rapidsai/rapidsai/>

## Chart Details

This chart will deploy the following:

- Placeholder

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/rapids
```

Depending on how your cluster was setup, you may also need to specify
a namespace with the following flag: `--namespace my-namespace`.

## Default Configuration

The following tables list the configurable parameters of the RAPIDS chart and
their default values.

### Jupyter

**NOTE**: Only `latest` and platform specific builds seem to be up for RAPIDS.
Will this need to be addressed? Or will users have to choose version for
their machine?

| Parameter               | Description                      | Default                  |
|-------------------------|----------------------------------|--------------------------|
| `jupyter.name`          | Jupyter name                     | `jupyter`                |
| `jupyter.enabled`       | Include optional Jupyter server  | `true`                   |
| `jupyter.image`         | Container image name             | `rapidsai/rapidsai`      |
| `jupyter.imageTag`      | Container image tag              | `latest` (0.5.1, 0.6?)   |
| `jupyter.replicas`      | k8s deployment replicas          | `1`                      |
| `jupyter.servicePort`   | k8s service port                 | `80`                     |
| `jupyter.resources`     | Container resources              | `{}`                     |

#### Jupyter Password

When launching the Jupyter server, you will be prompted for a password. The
default password set in [values.yaml](values.yaml) is `rapids`.

```yaml
jupyter:
  ...
  password: 'sha1:d67811ad02c2:f63bceaabf3724046ef5d5b512c217c2492c820d' # 'rapids'
```

To change this password, run `jupyter notebook password` in the command-line,
example below:

```bash
$ jupyter notebook password
Enter password: rapids 
Verify password: rapids 
[NotebookPasswordApp] Wrote hashed password to /home/rapids/.jupyter/jupyter_notebook_config.json

$ cat /home/rapids/.jupyter/jupyter_notebook_config.json
{
  "NotebookApp": {
    "password": "sha1:d67811ad02c2:f63bceaabf3724046ef5d5b512c217c2492c820d"
  }
}
```

Replace the `jupyter.password` field in [values.yaml](values.yaml) with the
hash generated for your new password.

## Custom Configuration

If you want to change the default parameters, you can do this in two ways.

### YAML Config Files

You can change the default parameterss in `values.yaml`, or create your own 
custom YAML config file, and specify this file when installing your chart with
the `-f` flag. Example:

```bash
helm install --name my-release -f values.yaml stable/rapids
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

The default `rapidsai/rapidsai` images have a standard Miniconda installation along
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

Note that the Jupyter and RAPIDS environments should have matching
software environments, at least where a user is likely to distribute that
functionality.
