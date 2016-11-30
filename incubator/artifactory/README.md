# JFrog Artifactory Helm Chart

## Prerequisites Details

* Artifactory Pro trial license [get one from here](https://www.jfrog.com/artifactory/free-trial/)

## Todo

* Implement Support of Reverse proxy for Docker Repo using Nginx
* Smarter upscaling/downscaling

## Chart Details
This chart will do the following:

* Deploy Artifactory-Pro

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/artifactory
```

## Deleting the Charts

Deletion of the PetSet doesn't cascade to deleting associated Pods and PVCs. To delete them:

```
 $ helm delete my-release
```

## Configuration

The following tables lists the configurable parameters of the artifactory chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `Image`                   | Container image name              | `docker.bintray.io/jfrog/artifactory-pro`                |
| `ImageTag`                | Container image tag               | `4.14.1`                                                 |
| `ImagePullPolicy`         | Container pull policy             | `Always`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/