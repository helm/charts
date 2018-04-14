# JFrog Artifactory Helm Chart

## Prerequisites Details

* Kubernetes 1.6+
* Artifactory Pro trial license [get one from here](https://www.jfrog.com/artifactory/free-trial/)

## Chart Details
This chart will do the following:

* Deploy Artifactory-Pro (or OSS if set custom image)
* Deploy a PostgreSQL database using the stable/postgresql chart
* Deploy an optional Nginx server
* Optionally expose Artifactory with Ingress [Ingress documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## Installing the Chart

To install the chart with the release name `artifactory`:

```bash
$ helm install --name artifactory stable/artifactory
```

### Deploying Artifactory OSS
By default it will run Artifactory-Pro to run Artifactory-Oss use following command:
```bash
$ helm install --name artifactory --set artifactory.image.repository=docker.bintray.io/jfrog/artifactory-oss stable/artifactory
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

### Artifactory memory and CPU resources
The Artifactory Helm chart comes with support for configured resource requests and limits to Artifactory, Nginx and PostgreSQL. By default, these settings are commented out.
It is **highly** recommended to set these so you have full control of the allocated resources and limits.
Artifactory java memory parameters can (and should) also be set to match the allocated resources with `artifactory.javaOpts.xms` and `artifactory.javaOpts.xmx`.
```bash
# Example of setting resource requests and limits to all pods (including passing java memory settings to Artifactory)
$ helm install --name artifactory \
               --set artifactory.resources.requests.cpu="500m" \
               --set artifactory.resources.limits.cpu="2" \
               --set artifactory.resources.requests.memory="1Gi" \
               --set artifactory.resources.limits.memory="4Gi" \
               --set artifactory.javaOpts.xms="1g" \
               --set artifactory.javaOpts.xmx="4g" \
               --set nginx.resources.requests.cpu="100m" \
               --set nginx.resources.limits.cpu="250m" \
               --set nginx.resources.requests.memory="250Mi" \
               --set nginx.resources.limits.memory="500Mi" \
               stable/artifactory
```
Get more details on configuring Artifactory in the [official documentation](https://www.jfrog.com/confluence/).


### Customizing Database password
You can override the specified database password (set in [values.yaml](values.yaml)), by passing it as a parameter in the install command line
```bash
$ helm install --name artifactory --namespace artifactory --set postgresql.postgresPassword=12_hX34qwerQ2 stable/artifactory
```

You can customise other parameters in the same way, by passing them on `helm install` command line.

### Deleting Artifactory
```bash
$ helm delete --purge artifactory
```
This will completely delete your Artifactory Pro deployment.  
**IMPORTANT:** This will also delete your data volumes. You will lose all data!


### Custom Docker registry for your images
If you need to pull your Docker images from a private registry, you need to create a
[Kubernetes Docker registry secret](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) and pass it to helm
```bash
# Create a Docker registry secret called 'regsecret'
$ kubectl create secret docker-registry regsecret --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```
Once created, you pass it to `helm`
```bash
$ helm install --name artifactory --set imagePullSecrets=regsecret stable/artifactory
```

## Configuration

The following table lists the configurable parameters of the artifactory chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `imagePullSecrets`        | Docker registry pull secret       |                                                          |
| `artifactory.name` | Artifactory name | `artifactory`   |
| `artifactory.replicaCount`            | Replica count for Artifactory deployment| `1`                                                |
| `artifactory.image.pullPolicy`         | Container pull policy             | `IfNotPresent`                                           |
| `artifactory.image.repository`    | Container image                   | `docker.bintray.io/jfrog/artifactory-pro`                |
| `artifactory.image.version`       | Container tag                     |  `5.10.1`                                         |
| `artifactory.service.name`| Artifactory service name to be set in Nginx configuration | `artifactory` |
| `artifactory.service.type`| Artifactory service type | `ClusterIP` |
| `artifactory.externalPort` | Artifactory service external port | `8081`   |
| `artifactory.internalPort` | Artifactory service internal port | `8081`   |
| `artifactory.persistence.mountPath` | Artifactory persistence volume mount path | `"/var/opt/jfrog/artifactory"`   |
| `artifactory.persistence.enabled` | Artifactory persistence volume enabled | `true`   |
| `artifactory.persistence.accessMode` | Artifactory persistence volume access mode | `ReadWriteOnce`   |
| `artifactory.persistence.size` | Artifactory persistence volume size | `20Gi`   |
| `artifactory.resources.requests.memory` | Artifactory initial memory request  |      |
| `artifactory.resources.requests.cpu`    | Artifactory initial cpu request     |      |
| `artifactory.resources.limits.memory`   | Artifactory memory limit            |      |
| `artifactory.resources.limits.cpu`      | Artifactory cpu limit               |      |
| `artifactory.javaOpts.xms`              | Artifactory java Xms size           |      |
| `artifactory.javaOpts.xmx`              | Artifactory java Xms size           |      |
| `artifactory.javaOpts.other`            | Artifactory additional java options |      |
| `ingress.enabled`           | If true, Artifactory Ingress will be created | `false` |
| `ingress.annotations`       | Artifactory Ingress annotations     | `{}` |
| `ingress.hosts`             | Artifactory Ingress hostnames       | `[]` |
| `ingress.tls`               | Artifactory Ingress TLS configuration (YAML) | `[]` |
| `nginx.name` | Nginx name | `nginx`   |
| `nginx.enabled` | Deploy nginx server | `true`   |
| `nginx.replicaCount` | Nginx replica count | `1`   |
| `nginx.image.repository`    | Container image                   | `docker.bintray.io/jfrog/nginx-artifactory-pro`                |
| `nginx.image.version`       | Container tag                     | `5.10.1`                                                |
| `nginx.image.pullPolicy`    | Container pull policy                   | `IfNotPresent`                |
| `nginx.service.type`| Nginx service type | `LoadBalancer` |
| `nginx.service.loadBalancerSourceRanges`| Nginx service array of IP CIDR ranges to whitelist (only when service type is LoadBalancer) |  |
| `nginx.loadBalancerIP`| Provide Static IP to to configure with Nginx |  |
| `nginx.externalPortHttp` | Nginx service external port | `80`   |
| `nginx.internalPortHttp` | Nginx service internal port | `80`   |
| `nginx.externalPortHttps` | Nginx service external port | `443`   |
| `nginx.internalPortHttps` | Nginx service internal port | `443`   |
| `nginx.tlsSecretName` |  SSL secret that will be used by the Nginx pod |    |
| `nginx.env.artUrl` | Nginx Environment variable Artifactory URL | `"http://artifactory:8081/artifactory"`   |
| `nginx.env.ssl` | Nginx Environment enable ssl | `true`   |
| `nginx.persistence.mountPath` | Nginx persistence volume mount path | `"/var/opt/jfrog/nginx"`   |
| `nginx.persistence.enabled` | Nginx persistence volume enabled | `true`   |
| `nginx.persistence.accessMode` | Nginx persistence volume access mode | `ReadWriteOnce`   |
| `nginx.persistence.size` | Nginx persistence volume size | `5Gi`   |
| `nginx.resources.requests.memory` | Nginx initial memory request  |     |
| `nginx.resources.requests.cpu`    | Nginx initial cpu request     |     |
| `nginx.resources.limits.memory`   | Nginx memory limit            |     |
| `nginx.resources.limits.cpu`      | Nginx cpu limit               |     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

### Ingress and TLS
To get Helm to create an ingress object with a hostname, add these two lines to your Helm command:
```
helm install --name artifactory \
  --set ingress.enabled=true \
  --set ingress.hosts[0]="artifactory.company.com" \
  --set artifactory.service.type=NodePort \
  --set nginx.enabled=false \
  stable/artifactory
```

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls artifactory-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the Artifactory Ingress TLS section of your custom `values.yaml` file:

```
  ingress:
    ## If true, Artifactory Ingress will be created
    ##
    enabled: true

    ## Artifactory Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - artifactory.domain.com
    annotations:
      kubernetes.io/tls-acme: "true"
    ## Artifactory Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: artifactory-tls
        hosts:
          - artifactory.domain.com
```

## Useful links
https://www.jfrog.com
https://www.jfrog.com/confluence/
