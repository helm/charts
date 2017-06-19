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
| `replicaCount`            | Replica count for Artifactory deployment| `1`                                                |
| `imagePullPolicy`         | Container pull policy             | `IfNotPresent`                                           |
| `db_env.db_type`          | Database type                     | `postgresql`                                             |
| `db_env.db_name`          | Database name                     | `artifactory`                                            |
| `db_env.db_user`          | Database username                 | `artifactory`                                            |
| `db_env.db_pass`          | Database password                 | `artXifactory1973`                                       |
| `db_name`          | Database name                     | `postgresql`                                                    |
| `db_image.repository`          | Database container image                     | `docker.bintray.io/postgres`             |
| `db_image.version`          | Database container image tag                     | `9.5.2`                                 |
| `db_service.name` | Database service name | `postgresql`   |
| `db_service.type` | Database service type | `ClusterIP`   |
| `db_service.externalPort` | Database service external port | `5432`   |
| `db_service.internalPort` | Database service internal port | `5432`   |
| `db_persistence.mountPath` | Database persistence volume mount path | `"/var/lib/postgresql/data"`   |
| `db_persistence.enabled` | Database persistence volume enabled | `true`   |
| `db_persistence.accessMode` | Database persistence volume access mode | `ReadWriteOnce`   |
| `db_persistence.size` | Database persistence volume size | `10Gi`   |
| `art_name` | Artifactory name | `artifactory`   |
| `art_name.art_replicaCount` | Artifactory replica count | `1`   |
| `art_image.repository`    | Container image                   | `docker.bintray.io/jfrog/artifactory-pro`                |
| `art_image.version`       | Container image tag               | `5.3.2`                                                  |
| `art_service.name` | Artifactory service name              | `artifactory`                             |
| `art_service.type`| Artifactory service type | `ClusterIP` |
| `art_service.externalPort` | Artifactory service external port | `8081`   |
| `art_service.internalPort` | Artifactory service internal port | `8081`   |
| `art_persistence.mountPath` | Artifactory persistence volume mount path | `"/var/opt/jfrog/artifactory"`   |
| `art_persistence.enabled` | Artifactory persistence volume enabled | `true`   |
| `art_persistence.accessMode` | Artifactory persistence volume access mode | `ReadWriteOnce`   |
| `art_persistence.size` | Artifactory persistence volume size | `20Gi`   |
| `nx_name` | Nginx name | `nginx`   |
| `nx_name.art_replicaCount` | Nginx replica count | `1`   |
| `nx_image.repository`    | Container image                   | `docker.bintray.io/jfrog/nginx-artifactory-pro`                |
| `nx_image.version`       | Container image tag               | `5.3.2`                                                  |
| `nx_service.name` | Nginx service name              | `nginx`                             |
| `nx_service.type`| Nginx service type | `LoadBalancer` |
| `nx_service.externalPortHttp` | Nginx service external port | `80`   |
| `nx_service.externalPortHttp` | Nginx service internal port | `80`   |
| `nx_service.externalPortHttps` | Nginx service external port | `443`   |
| `nx_service.externalPortHttps` | Nginx service internal port | `443`   |
| `nx_env.art_url` | Nginx Environment variable Artifactory URL | `"http://artifactory:8081/artifactory"`   |
| `nx_env.ssl` | Nginx Environment enable ssl | `true`   |
| `nx_persistence.mountPath` | Nginx persistence volume mount path | `"/var/opt/jfrog/nginx"`   |
| `nx_persistence.enabled` | Nginx persistence volume enabled | `true`   |
| `nx_persistence.accessMode` | Nginx persistence volume access mode | `ReadWriteOnce`   |
| `nx_persistence.size` | Nginx persistence volume size | `5Gi`   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/
