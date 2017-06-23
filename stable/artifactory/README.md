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
$ helm install --name artifactory --set artImage.repository=docker.bintray.io/jfrog/artifactory-oss stable/artifactory
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
$ helm install --name artifactory --namespace artifactory --set dbEnv.dbPass=12_hX34qwerQ2 stable/artifactory
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
| `replicaCount`            | Replica count for Artifactory deployment| `1`                                                |
| `imagePullPolicy`         | Container pull policy             | `IfNotPresent`                                           |
| `dbEnv.dbType`          | Database type                     | `postgresql`                                             |
| `dbEnv.dbName`          | Database name                     | `artifactory`                                            |
| `dbEnv.dbUser`          | Database username                 | `artifactory`                                            |
| `dbEnv.dbPass`          | Database password                 | `artXifactory1973`                                       |
| `dbName`          | Database name                     | `postgresql`                                                    |
| `dbImage.repository`          | Database container image                     | `docker.bintray.io/postgres`             |
| `dbImage.version`          | Database container image tag                     | `9.5.2`                                 |
| `dbService.name` | Database service name | `postgresql`   |
| `dbService.type` | Database service type | `ClusterIP`   |
| `dbService.externalPort` | Database service external port | `5432`   |
| `dbService.internalPort` | Database service internal port | `5432`   |
| `dbPersistence.mountPath` | Database persistence volume mount path | `"/var/lib/postgresql/data"`   |
| `dbPersistence.enabled` | Database persistence volume enabled | `true`   |
| `dbPersistence.accessMode` | Database persistence volume access mode | `ReadWriteOnce`   |
| `dbPersistence.size` | Database persistence volume size | `10Gi`   |
| `artName` | Artifactory name | `artifactory`   |
| `artName.art_replicaCount` | Artifactory replica count | `1`   |
| `artImage.repository`    | Container image                   | `docker.bintray.io/jfrog/artifactory-pro`                |
| `artImage.version`       | Container image tag               | `5.4.1`                                                  |
| `artService.name` | Artifactory service name              | `artifactory`                             |
| `artService.type`| Artifactory service type | `ClusterIP` |
| `artService.externalPort` | Artifactory service external port | `8081`   |
| `artService.internalPort` | Artifactory service internal port | `8081`   |
| `artPersistence.mountPath` | Artifactory persistence volume mount path | `"/var/opt/jfrog/artifactory"`   |
| `artPersistence.enabled` | Artifactory persistence volume enabled | `true`   |
| `artPersistence.accessMode` | Artifactory persistence volume access mode | `ReadWriteOnce`   |
| `artPersistence.size` | Artifactory persistence volume size | `20Gi`   |
| `nxName` | Nginx name | `nginx`   |
| `nxName.artReplicaCount` | Nginx replica count | `1`   |
| `nxImage.repository`    | Container image                   | `docker.bintray.io/jfrog/nginx-artifactory-pro`                |
| `nxImage.version`       | Container image tag               | `5.4.1`                                                  |
| `nxService.name` | Nginx service name              | `nginx`                             |
| `nxService.type`| Nginx service type | `LoadBalancer` |
| `nxService.externalPortHttp` | Nginx service external port | `80`   |
| `nxService.externalPortHttp` | Nginx service internal port | `80`   |
| `nxService.externalPortHttps` | Nginx service external port | `443`   |
| `nxService.externalPortHttps` | Nginx service internal port | `443`   |
| `nxEnv.artUrl` | Nginx Environment variable Artifactory URL | `"http://artifactory:8081/artifactory"`   |
| `nxEnv.ssl` | Nginx Environment enable ssl | `true`   |
| `nxPersistence.mountPath` | Nginx persistence volume mount path | `"/var/opt/jfrog/nginx"`   |
| `nxPersistence.enabled` | Nginx persistence volume enabled | `true`   |
| `nxPersistence.accessMode` | Nginx persistence volume access mode | `ReadWriteOnce`   |
| `nxPersistence.size` | Nginx persistence volume size | `5Gi`   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/
