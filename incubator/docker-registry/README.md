# docker-registry Helm Chart

* Installs the [docker-registry cluster addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/registry).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/docker-registry
```

## Configuration

| Parameter               | Description                            | Default             |
|-------------------------|----------------------------------------|---------------------|
| `svcName`               | Service name                           | docker-registry     |
| `nodePort`              | Port from the range 30000-32000        | 30400               |
| `initialLoad`           | Load tarball with saved registry       | false               |
| `replicas`              | Number of replicas                     | 1                   |
| `distro`                | Used to as a part of tarball file name | \<blank>            |
| `branch`                | Used to as a part of tarball file name | \<blank>            |
| `initImage`             | Image to use for init container        | centos              |
| `initImageVersion`      | Image version for init container       | latest              |
| `registryImage`         | Registry image to use                  | registry            |
| `registryImageVersion`  | Registry image version to use          | 2                   |
| `tarballURL`            | URL to tarball location                | \<blank>            |

## Usage

When docker registry is running, you can push and pull containers by using following commands:

To push local docker container to the registry:
```bash
$ docker tag {local docker container ID} 127.0.0.1:{node_port}/{local docker image name}
$ docker push 127.0.0.1:{node_port}/{local docker image name}
```

To pull a container from the registry:
```bash
$ docker pull 127.0.0.1:{node_port}/{container name}
```
