# OpenAM Helm chart
This chart would install and configure OpenAM in kubernetes cluster. It would also create a default user to test integration between OpenAM and user application if configured so through values.yaml. 
OpenAM is an open source access management, entitlements and federation server platform. For more details on OpenAM, please refer [OpenAM](https://forgerock.org/).
Chart supports persistent volume for storing OpenAM configurations and Directory Data Source for embedded store. It also supports external Data Store by changing values.yaml configs.
## Prerequisite
Kubernetes 1.9+

If external data store is configured, same should be created and configured accordingly.

## Installing the chart

```
helm install --name openam .
```

## Accessing OpenAM UI after installation
Once chart is installed with default values.yaml, OpenAM GUI can be accessed using below url. URL can be customized in values.yaml. 
```
http://openam.default.svc.cluster.local
```

## Options in values.yaml
Default Values are specified in values.yaml. They can be customized as per user needs.
```
| Option                            | Mandatory| Description                                                                                                         |
| ----------------------------------|:--------:| -------------------------------------------------------------------------------------------------------------------:|
| env.BASE_DIR                      | Yes      | Persistent volume path where AM stores files and embedded configuration directory servers.                          |
| env.APP_USER                      | No       | Default user id to be created in OpenAM during setup. Optional. Will be added to unix environment                   |
| env.APP_USER_PWD                  | No       | Password for default user id . Optional. Will be added to unix environment                                          |
| env.AM_PWD                        | Yes      | Password of the AM administrator user amadmin, which must be at least 8 characters in length.                       |
| env.MAX_HEAP                      | No       | JVM Maximum Heap size. Optional. Default is 1g                                                                      |
| cookieDomain                      | Yes      | Name of the trusted DNS domain AM returns to a browser when it grants a session ID to a user.                       |
| server.url                        | Yes      | URL to the web container where you want AM to run                                                                   |
| volumeClaim.accessMode            | Yes      | Access Mode of requested PVC. e.g ReadWriteOnce, ReadWriteMany etc.                                                 |
| volumeClaim.storage               | Yes      | Size of requested PVC                                                                                               |
| directory.server                  | Yes      | Fully qualified domain name of the configuration store directory server host                                        |
| directory.ssl                     | Yes      | To use LDAP without SSL, set this to SIMPLE. To use LDAP with SSL, set this to SSL.                                 |
| directory.port                    | Yes      | LDAP or LDAPS port number for the configuration store directory server                                              |
| directory.adminPort               | Yes      | Administration port number for the configuration store directory server                                             |
| directory.jmxPort                 | No       | Java Management eXtension port number, such as 1689, used with the DS embedded configuration store                  |
| dataStore.type                    | Yes      | Type of the configuration data store. embedded means embedded DS store. dirServer means an external directory server|
| dataStore.rootSuffix              | Yes      | Root suffix distinguished name (DN) for the configuration store .                                                   |
| dataStore.dirMgrDN                | Yes      | Distinguished name of the directory manager of the configuration store, such as cn=Directory Manager                |
| dataStore.dirMgrPassword          | Yes      | Password for the directory manager of the configuration store                                                       |
| livenessProbe.enabled             | Yes      | Whether to enable liveness probe.                                                                                   |
| livenessProbe.initialDelaySeconds | Yes      | Standard k8s liveness probe attribute initialDelaySeconds                                                           |
| livenessProbe.periodSeconds       | Yes      | Standard k8s liveness probe attribute periodSeconds                                                                 |
| livenessProbe.timeoutSeconds      | Yes      | Standard k8s liveness probe attribute timeoutSeconds                                                                |
| livenessProbe.failureThreshold    | Yes      | Standard k8s liveness probe attribute failureThreshold                                                              |
| livenessProbe.successThreshold    | Yes      | Standard k8s liveness probe attribute successThreshold                                                              |
| readinessProbe.enabled            | Yes      | Whether to enable liveness probe.                                                                                   |
| readinessProbe.initialDelaySeconds| Yes      | Standard k8s readiness probe attribute initialDelaySeconds                                                          |
| readinessProbe.periodSeconds      | Yes      | Standard k8s readiness probe attribute periodSeconds                                                                |
| readinessProbe.timeoutSeconds     | Yes      | Standard k8s readiness probe attribute timeoutSeconds                                                               |
| readinessProbe.failureThreshold   | Yes      | Standard k8s readiness probe attribute failureThreshold                                                             |
| readinessProbe.successThreshold   | Yes      | Standard k8s readiness probe attribute successThreshold                                                             |

```
