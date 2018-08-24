# Rundeck Helm chart
This chart would install Rundeck in kubernetes cluster. Rundeck is open source software that helps you automate routine operational procedures in data center or cloud environments. For more details on Rundeck, please refer [Rundeck](http://rundeck.org).
Chart supports persistent shared store for storing rundeck project related files. It also supports external DB to store various jobs and their logs.
## Prerequisite
Kubernetes 1.9+

If external database is configured, then empty database should be available and DB related options inside values.yaml need to be configured accordingly.
## Installing the chart

```
helm install stable/rundeck
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

Option | Required | Description
--- | --- | ---
`env.SHARED_STORAGE` | Yes | Persistent volume path where rundeck projects and logs would reside                                                      
`env.DB_URL` | No | External DB Hostname.Only applicable for external DB
`env.DB_SCHEMA` | No | External DB schema/db name. Only applicable for external DB
`env.DB_USER` | No | External DB user name. Only applicable for external DB
`env.DB_PASS` | No | External DB password. Only applicable for external DB
`env.RD_URL` | Yes | Rundeck URL through which rundeck application can be accessed
`env.RD_USER` | Yes | Rundeck user which can be used to login into Rundeck UI, use rundeck
`env.RD_PASSWORD` | Yes | Rundeck password
`env.RD_PROJECT` | Yes | Default Project name under which jobs are created
`env.RUNDECK_INSTALL_DIR` | Yes | Directory where Rundeck would be installed
`env.RSA_KEY_DIR` | Yes | Directory for ssh key for passwordless remote server connection
`env.JAVA_OPTIONS` | Yes | Depending on the operating environment, java options can be set
`env.UID` | No | UID for the env.RD_USER if you do not want to run rundeck as root uid/gid. If not supplied, root would be assumed
`env.GID` | No | GID for the env.RD_USER if you do not want to run rundeck as root uid/gid. If not supplied, root would be assumed
`volumeClaim.accessMode` | No | Access Mode of requested PV/PVC. e.g ReadWriteOnce, ReadWriteMany etc.
`volumeClaim.storage` | No | Size of requested PV/PVC
`grails.auth` | Yes | true if mail server supports authorization for configuration of rundeck notifications
`grails.url` | Yes | Rundeck URL used to integrate with other application
`grails.mailhost` | No | Mail server IP/Hostname if notification is required
`grails.mailport` | No | Mail server port if notification is required
`grails.mailuser` | No | Mail server user if notification is required and grails.auth is true
`grails.mailpass` | No | Mail server password if notification is required and grails.auth is true
`grails.mailfrom` | No | Mail server from address if notification is required
`datasource.url` | Yes | Datasource URL. Default is internal in-memory h2 DB. External DB url can be used in conjuction with DB related options
`edgeNodes` | Yes | Key value pair with remote host ip/name and user name to connect using ssh for dispatching job to remote nodes
`livenessProbe.enabled` | Yes | Whether to enable liveness probe.
`livenessProbe.initialDelaySeconds` | Yes | Standard k8s liveness probe attribute initialDelaySeconds
`livenessProbe.periodSeconds` | Yes | Standard k8s liveness probe attribute periodSeconds
`livenessProbe.timeoutSeconds` | Yes | Standard k8s liveness probe attribute timeoutSeconds
`livenessProbe.failureThreshold` | Yes | Standard k8s liveness probe attribute failureThreshold
`livenessProbe.successThreshold` | Yes | Standard k8s liveness probe attribute successThreshold
`readinessProbe.enabled` | Yes | Whether to enable liveness probe.
`readinessProbe.initialDelaySeconds` | Yes | Standard k8s readiness probe attribute initialDelaySeconds
`readinessProbe.periodSeconds` | Yes | Standard k8s readiness probe attribute periodSeconds
`readinessProbe.timeoutSeconds` | Yes | Standard k8s readiness probe attribute timeoutSeconds
`readinessProbe.failureThreshold` | Yes | Standard k8s readiness probe attribute failureThreshold
`readinessProbe.successThreshold` | Yes | Standard k8s readiness probe attribute successThreshold
`secret.enabled` | No | if true, ssh secret needs to be provided. Same would be copied into container for communication with remote nodes
`keys.storage.type` | Yes | Storage preference type for ssh keys. Can be file or db. If "db" is set, then make sure to use external DB

