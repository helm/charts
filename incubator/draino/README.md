# Draino

Source: https://github.com/planetlabs/draino

"Draino automatically drains Kubernetes nodes based on labels and node conditions." For complete details regarding Draino, check out the official repository.

This builds a Helm chart to install Draino.

## Configuration

The following table lists the configurable parameters of the Draino chart and their default values.

| Parameter            | Description                                                         | Default                                                                           |
| ---------------------| --------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| `command`            | Command that runs in the `Pod` at startup.                          | `/draino`                                                                         |
| `args`               | Arguments to be appended to the startup `command`.                  | `["--debug", "--evict-daemonset-pods", "--evict-emptydir-pods", "KernelDeadlock"]`|
| `image.name`         | Name of Docker image to use.                                        | `planetlabs/draino`                                                               |
| `image.tag`          | Tag of Docker image to use.                                         | `latest`                                                                          |

## Usage

Draino allows passing in arguments when starting up. These should be added to `args`. For a full list of arguments, check out the repo [here](https://github.com/planetlabs/draino).

The arguments should end with the node conditions to be used. In this case, `KernelDeadlock` is provided as the basis.
