# JFrog Artifactory Helm Chart

## Prerequisites Details

* Artifactory Pro trial license [get one from here](https://www.jfrog.com/artifactory/free-trial/)

## Chart Details
This chart will do the following:

* Deploy Artifactory-oss
* Deploy Artifactory-Pro

## Installing the Chart

To install the chart with the release name `artifactory`:

```bash
$ helm install --name artifactory stable/artifactory
```

### Deploying Artifactory OSS
You can deploy Artifactory OSS by using the same instructions as provided for the Pro.
**NOTE:** The Artifactory OSS does not use Nginx, so your Artifactory's Kubernetes service exposes Tomcat's port 8081 as port 80.

By default it will run Artifactory-pro to run Artifactory-oss comment nginx configuration in value.yaml and use following command:
Remove `nginx-deployment.yaml`, `nginx-pvc.yaml` and `nginx-service.yaml` and change art_service.externalPort to 80 in [values.yaml](values.yaml) before running command to install Artifactory-oss.
```bash
$ helm install --name artifactory --set art_image.repository=docker.bintray.io/jfrog/artifactory-oss stable/artifactory
```

### Accessing Artifactory
**NOTE:** It might take a few minutes for Artifactory's public IP to become available.
Follow the instructions outputted by the install command to get the Artifactory IP to access it.

### Updating Artifactory
Once you have a new chart version, you can update your deployment with
```bash
$ helm upgrade artifactory --namespace artifactory stable/artifactory
```

This will apply any configuration changes on your existing deployment.

### Customizing Database password
You can override the specified database password (set in [values.yaml](values.yaml)), by passing it as a parameter in the install command line
```bash
$ helm install --name artifactory --namespace artifactory --set db_env.db_pass=12_hX34qwerQ2 stable/artifactory
```

You can customise other parameters in the same way, by passing them on `helm install` command line.

### Deleting Artifactory
```bash
$ helm delete --purge artifactory
```

This will completely delete your Artifactory Pro deployment.  
**IMPORTANT:** This will also delete your data volumes. You will loose all data!

## Configuration

The following tables lists the configurable parameters of the artifactory chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `art_image.version`       | Container image tag               | `5.3.2`                                                 |
| `ImagePullPolicy`         | Container pull policy             | `IfNotPresent`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/
