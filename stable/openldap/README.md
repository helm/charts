# OpenLDAP Helm Chart

## Prerequisites Details
* Kubernetes 1.8+
* PV support on the underlying infrastructure

## Chart Details
This chart will do the following:

* Instantiate an instance of OpenLDAP server

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/openldap
```

## Configuration

We use the docker images provided by https://github.com/osixia/docker-openldap. The docker image is highly configurable and well documented. Please consult to documentation for the docker image for more information.

The following table lists the configurable parameters of the openldap chart and their default values.

| Parameter                          | Description                                                                                                                               | Default             |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `replicaCount`                     | Number of replicas                                                                                                                        | `1`                 |
| `strategy`                         | Deployment strategy                                                                                                                       | `{}`                |
| `image.repository`                 | Container image repository                                                                                                                | `osixia/openldap`   |
| `image.tag`                        | Container image tag                                                                                                                       | `1.1.10`            |
| `image.pullPolicy`                 | Container pull policy                                                                                                                     | `IfNotPresent`      |
| `extraLabels`                      | Labels to add to the Resources                                                                                                            | `{}`                |
| `podAnnotations`                   | Annotations to add to the pod                                                                                                             | `{}`                |
| `existingSecret`                   | Use an existing secret for admin and config user passwords                                                                                | `""`                |
| `service.annotations`              | Annotations to add to the service                                                                                                         | `{}`                |
| `service.clusterIP`                | IP address to assign to the service                                                                                                       | `nil`                |
| `service.externalIPs`              | Service external IP addresses                                                                                                             | `[]`                |
| `service.ldapPort`                 | External service port for LDAP                                                                                                            | `389`               |
| `service.loadBalancerIP`           | IP address to assign to load balancer (if supported)                                                                                      | `""`                |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)                                                                           | `[]`                |
| `service.sslLdapPort`              | External service port for SSL+LDAP                                                                                                        | `636`               |
| `service.type`                     | Service type                                                                                                                              | `ClusterIP`         |
| `env`                              | List of key value pairs as env variables to be sent to the docker image. See https://github.com/osixia/docker-openldap for available ones | `[see values.yaml]` |
| `logLevel`                         | Set the container log level. Valid values: `none`, `error`, `warning`, `info`, `debug`, `trace`                                           | `info`              |
| `tls.enabled`                      | Set to enable TLS/LDAPS - should also set `tls.secret`                                                                                    | `false`             |
| `tls.secret`                       | Secret containing TLS cert and key (eg, generated via cert-manager)                                                                       | `""`                |
| `tls.CA.enabled`                   | Set to enable custom CA crt file - should also set `tls.CA.secret`                                                                        | `false`             |
| `tls.CA.secret`                    | Secret containing CA certificate (ca.crt)                                                                                                 | `""`                |
| `adminPassword`                    | Password for admin user. Unset to auto-generate the password                                                                              | None                |
| `configPassword`                   | Password for config user. Unset to auto-generate the password                                                                             | None                |
| `customLdifFiles`                  | Custom ldif files to seed the LDAP server. List of filename -> data pairs                                                                 | None                |
| `persistence.enabled`              | Whether to use PersistentVolumes or not                                                                                                   | `false`             |
| `persistence.storageClass`         | Storage class for PersistentVolumes.                                                                                                      | `<unset>`           |
| `persistence.accessMode`           | Access mode for PersistentVolumes                                                                                                         | `ReadWriteOnce`     |
| `persistence.size`                 | PersistentVolumeClaim storage size                                                                                                        | `8Gi`               |
| `persistence.existingClaim`        | An Existing PVC name for openLDAPA volume                                                                                                 | None                |
| `resources`                        | Container resource requests and limits in yaml                                                                                            | `{}`                |
| `initResources`                    | initContainer resource requests and limits in yaml                                                                                        | `{}`                |
| `test.enabled`                     | Conditionally provision test resources                                                                                                    | `false`             |
| `test.image.repository`            | Test container image requires bats framework                                                                                              | `dduportal/bats`    |
| `test.image.tag`                   | Test container tag                                                                                                                        | `0.4.0`             |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/openldap
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Cleanup orphaned Persistent Volumes

Deleting the Deployment will not delete associated Persistent Volumes if persistence is enabled.

Do the following after deleting the chart release to clean up orphaned Persistent Volumes.

```bash
$ kubectl delete pvc -l release=${RELEASE-NAME}
```

## Custom Secret

`existingSecret` can be used to override the default secret.yaml provided

## Testing

Helm tests are included and they confirm connection to slapd.

```bash
helm install . --set test.enabled=true
helm test <RELEASE_NAME>
RUNNING: foolish-mouse-openldap-service-test-akmms
PASSED: foolish-mouse-openldap-service-test-akmms
```

It will confirm that we can do an ldapsearch with the default credentials
