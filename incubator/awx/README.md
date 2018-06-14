# AWX

AWX provides a web-based user interface, REST API, and task engine built on top of Ansible.


## TL;DR

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install -n awx incubator/awx
```


## Introduction

This chart bootstraps a [AWX](https://github.com/ansible/awx) Deployment on a [Kubernetes](https://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager. It provisions a fully featured AWX installation.
For more information on AWX and its capabilities, see its [documentation](https://docs.ansible.com/ansible-tower/index.html) and [Docker Hub repository](https://hub.docker.com/u/ansible/).


## Installing the Chart

To install the chart with the release name `awx`:

```console
$ helm install -n awx incubator/awx
```


## Uninstalling the Chart

To uninstall/delete the `awx` deployment:

```console
$ helm delete awx
```


## Configuration

The following table lists the configurable parameters of the AWX chart and their default values.

Parameter | Description | Default
--- | --- | ---
`app` | AWX app name | `awx`
`secret_key` | AWX secret key | `aabbcc`
`dbImage` | DB image and tag | `postgres:9.6.2`
`dbUser` | DB username | `awx`
`dbPassword` | DB user password | `awxpass`
`dbDatabaseName` | DB name | `awx`
`dbPort` | DB port | `5432`
`dbPersistence.accessMode` | DB PV access mode. If you select file storage(NAS), you must set "ReadWriteMany". If you select block storage(ISCSI), you must set "ReadWriteOnce". It is based on IBM Cloud. | `ReadWriteOnce`
`dbPersistence.size` | DB PV size. You can set at least 20GB. It is based on IBM Cloud. | `20Gi`
`dbPersistence.mountPath` | DB PV mount path. | `/var/lib/postgresql/data`
`dbPersistence.subPath` | DB PV sub-path (with DB file). | `/pgdata`
`dbPersistence.billingType` | DB PV hourly payment method. It is charged in the IBM Cloud. | `hourly`
`dbPersistence.annotations` | DB PV Storage-Class selection. Storage class is defined as follows: "ibmc-(block or file)-(bronze or silver or gold)". | `ibmc-block-bronze`
`queueImage` | Queue image and tag | `rabbitmq:3`
`queueUser` | Queue username | `guest`
`queuePassword` | Queue user password | `guest`
`queueNodePort` | Queue node port | `5672`
`queueVhost` | Queue application vhost | `awx`
`cacheImage` | Cache image and tag | `memcached:alpine`
`cachePort` | Cache port | `11211`
`taskImage` | Awx-task image and tag | `ansible/awx_task:latest`
`taskCommand` | Command to be executed at awx-task runtime. | `["/bin/sh", "-c", "echo 'root::0:0:root:/root:/bin/bash' >> /etc/passwd;su -c 'pip install softlayer pywinrm'"]`
`webImage` | Web image and tag | `ansible/awx_web:latest`
`webService.type` | Set it to "NodePort". To change to "LoadBalancer" and "Ingress", you can set it after "Portable IP" is preassigned. It is based on IBM Cloud. | `NodePort`
`internalPort` | Set internal port | `80`
`externalPort` | Set external port | `8052`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name awx -f values.yaml awx
```