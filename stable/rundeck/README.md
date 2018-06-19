# Rundeck Helm chart
This chart would install Rundeck in kubernetes cluster. Rundeck is open source software that helps you automate routine operational procedures in data center or cloud environments. For more details on Rundeck, please refer [Rundeck](http://rundeck.org).
Chart supports persistent shared store for storing rundeck project related files. It also supports external DB to store various jobs and their logs.
## Prerequisite
Kubernetes 1.9+
Secret with name **rundeck-ssh** should exist in the k8s cluster which should use private key for remote edge nodes passwordless connection.
```
kubectl create secret generic rundeck-ssh --from-file=id_rsa=<private key file name>
```
If external database is configured, then empty database should be available and DB related options inside values.yaml need to be configured accordingly.
## Installing the chart

```
helm install --name rundeck .
```

## Accessing Rundeck after installation
Once chart is installed with default values.yaml, Rundeck service can be accessed using below url. URL can be customized in values.yaml. Rundeck also exposes API endpoint which can be integrated with any application needing operational support provided by Rundeck using /api endpoint.
```
http://rundeck.default.svc.cluster.local
```

## Special Note
Chart can be run in minikube. We need to enable ingress and add minikube ip in host file(inside /etc/hosts in Linux and C:\Windows\System32\drivers\etc in Windows) of the environment where we want to access Rundeck UI endpoint through ingress.
```
192.168.99.100  rundeck.default.svc.cluster.local
```
## Options in values.yaml
Default Values are specified in values.yaml. They can be customized as per user needs.
```
| Option                  | Mandatory     | Description                                                                                                              |
| ------------------------|:-------------:| ------------------------------------------------------------------------------------------------------------------------:|
| env.SHARED_STORAGE      | Yes           | Persistent volume path where rundeck projects and logs would reside                                                      |
| env.DB_URL              | No            | External DB Hostname.Only applicable for external DB                                                                     |
| env.DB_SCHEMA           | No            | External DB schema/db name. Only applicable for external DB                                                              |
| env.DB_USER             | No            | External DB user name. Only applicable for external DB                                                                   |
| env.DB_PASS             | No            | External DB password. Only applicable for external DB                                                                    |
| env.RD_URL              | Yes           | Rundeck URL through which rundeck application can be accessed                                                            |
| env.RD_USER             | Yes           | Rundeck user which can be used to login into Rundeck UI, use rundeck                                                     |
| env.RD_PASSWORD         | Yes           | Rundeck password                                                                                                         |
| env.RD_PROJECT          | Yes           | Default Project name under which jobs are created                                                                        |
| env.RUNDECK_INSTALL_DIR | Yes           | Directory where Rundeck would be installed                                                                               |
| env.RSA_KEY_DIR         | Yes           | Directory for ssh key for passwordless remote server connection                                                          |
| env.JAVA_OPTIONS        | Yes           | Depending on the operating environment, java options can be set                                                          |
| env.UID                 | No            | UID for the env.RD_USER if you do not want to run rundeck as root uid/gid. If not supplied, root would be assumed        |
| env.GID                 | No            | GID for the env.RD_USER if you do not want to run rundeck as root uid/gid. If not supplied, root would be assumed        |
| volumeclaim.enabled     | No            | True if PV/PVC need to be created. Other volumeclaim options need to be provided if true. Can be false.                  |
| volumeclaim.accessmode  | No            | Access Mode of requested PV/PVC. e.g ReadWriteOnce, ReadWriteMany etc.                                                   |
| volumeclaim.storage     | No            | Size of requested PV/PVC                                                                                                 |
| volumeclaim.classname   | No            | Classname of requested PV/PVC                                                                                            |
| volumeclaim.path        | No            | PV path which would be mounted                                                                                           |
| storage.enabled         | Yes           | Always true. Shared storage is mandatory                                                                                 |
| storage.claimName       | Yes           | PVC claim name. Can resue existing PVC or use PV/PVC created using volumeclaim options.                                  |
| storage.mountPoint      | Yes           | Directory inside k8s pod which would mount persistent volume defined in storage.claimName                                |
| storage.remotePath      | Yes           | Directory name of PV server which would be mapped to storage.mountPoint                                                  |
| grails.auth             | Yes           | true if mail server supports authorization for configuration of rundeck notifications                                    |
| grails.url              | Yes           | Rundeck URL used to integrate with other application                                                                     |
| grails.mailhost         | No            | Mail server IP/Hostname if notification is required                                                                      |
| grails.mailport         | No            | Mail server port if notification is required                                                                             |
| grails.mailuser         | No            | Mail server user if notification is required and grails.auth is true                                                     |
| grails.mailpass         | No            | Mail server password if notification is required and grails.auth is true                                                 |
| grails.mailfrom         | No            | Mail server from address if notification is required                                                                     |
| datasource.url          | Yes           | Datasource URL. Default is internal in-memory h2 DB. External DB url can be used in conjuction with DB related options   |
| init.enabled            | No            | Mostly false unless any specific steps required as part of init container e.g. Creating a new directory inside NFS server|
| init.containers         | No            | Init container details, command, docker image  etc                                                                       |
| edgeNodes               | Yes           | Key value pair with remote host ip/name and user name to connect using ssh for dispatching job to remote nodes           |
| liveness.delay          | Yes           | Standard k8s liveness probe attribute initialDelaySeconds                                                                |
| liveness.period         | Yes           | Standard k8s liveness probe attribute periodSeconds                                                                      |
| liveness.timeout        | Yes           | Standard k8s liveness probe attribute timeoutSeconds                                                                     |
| readiness.delay         | Yes           | Standard k8s readiness probe attribute initialDelaySeconds                                                               |
| readiness.period        | Yes           | Standard k8s readiness probe attribute periodSeconds                                                                     |
| readiness.timeout       | Yes           | Standard k8s readiness probe attribute timtimeoutSecondseout                                                             |

```
