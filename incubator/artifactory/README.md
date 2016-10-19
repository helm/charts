# JFrog Artifactory Helm Chart

## Prerequisites Details

* Kubernetes 1.3 with alpha APIs enabled
* Artifactory Pro trial license
* PV dynamic provisioning support on the underlying infrastructure

## Todo

* Implement Support of Reverse proxy for Docker Repo using Nginx
* Smarter upscaling/downscaling
* Solution for Mysql 

## Chart Details
This chart will do the following:

* Deploy Artifactory Pro

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/artifactory
```

## Deleting the Charts

Deletion of the PetSet doesn't cascade to deleting associated Pods and PVCs. To delete them:

```
$ kubectl delete pods -l release=my-release,type=data
$ kubectl delete pvcs -l release=my-release,type=data
```

## Configuration

The following tables lists the configurable parameters of the artifactory chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `Image`                   | Container image name              | `docker.bintray.io/jfrog/artifactory-pro`                |
| `ImageTag`                | Container image tag               | `4.13.2`                                                 |
| `ImagePullPolicy`         | Container pull policy             | `Always`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/