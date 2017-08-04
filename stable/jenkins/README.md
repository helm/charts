# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

Inspired by the awesome work of Carlos Sanchez <carlos@apache.org>

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/jenkins
```

# Configuration

The following tables list the configurable parameters of the Jenkins chart and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Jenkins Master

| Parameter                          | Description                          | Default           |
| ---------------------------------- | ------------------------------------ | ----------------- |
| `master.image.repository`          | Master image name                    | `jenkins/jenkins` |
| `master.image.tag`                 | Master image tag                     | `lts`             |
| `master.image.pullPolicy`          | Master image pull policy             | `Always`          |
| `master.resources.limits.cpu`      | Master limited cpu                   | `200m`            |
| `master.resources.limits.memory`   | Master limited memory                | `256Mi`           |
| `master.resources.requests.cpu`    | Master requested cpu                 | `200m`            |
| `master.resources.requests.memory` | Master requested memory              | `256Mi`           |
| `master.env`                       | Master environment variables         | `{}`              |
| `master.jmxPort`                   | Open a port, for JMX stats           | Not set           |
| `master.nodeSelector`              | Node labels for pod assignment       | `{}`              |
| `master.tolerations`               | Toleration labels for pod assignment | `{}`              |

## Jenkins Agent

| Parameter                         | Description                                     | Default              |
| --------------------------------- | ----------------------------------------------- | -------------------- |
| `agent.enabled`                   | Enable Kubernetes plugin jnlp-agent podTemplate | `true`               |
| `agent.privileged`                | Agent privileged container                      | `false`              |
| `agent.image.repository`          | Agent image name                                | `jenkins/jnlp-slave` |
| `agent.image.tag`                 | Agent image tag                                 | `latest`             |
| `agent.image.pullPolicy`          | Always pull agent container image before build  | `IfNotPresent`       |
| `agent.resources.limits.cpu`      | Agent requested cpu                             | `200m`               |
| `agent.resources.limits.memory`   | Agent requested memory                          | `256Mi`              |
| `agent.resources.requests.cpu`    | Agent requested cpu                             | `200m`               |
| `agent.resources.requests.memory` | Agent requested memory                          | `256Mi`              |
| `agent.volumes`                   | Additional volumes                              | `nil`                |

### Mounting volumes into your Agent pods

Your Jenkins Agents will run as pods, and it's possible to inject volumes where needed:

```yaml
agent:
  volumes:
  - type: Secret
    secretName: jenkins-mysecrets
    mountPath: /var/run/secrets/jenkins-mysecrets
```

The suported volume types are: `ConfigMap`, `EmptyDir`, `HostPath`, `Nfs`, `Pod`, `Secret`. Each type supports a different set of configurable attributes, defined by [the corresponding Java class](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/main/java/org/csanchez/jenkins/plugins/kubernetes/volumes).

## ConfigMap

| Parameter         | Description                         | Default                                                                      |
| ----------------- | ----------------------------------- | ---------------------------------------------------------------------------- |
| `customConfigMap` | Use a custom ConfigMap              | `false`                                                                      |
| `initScripts`     | List of Jenkins init scripts        | Not set                                                                      |
| `installPlugins`  | List of Jenkins plugins to install  | `kubernetes:0.11 workflow-aggregator:2.5 credentials-binding:1.11 git:3.2.0` |
| `scriptApproval`  | List of groovy functions to approve | Not set                                                                      |

### Custom ConfigMap

When creating a new chart with this chart as a dependency, CustomConfigMap can be used to override the default config.xml provided.
It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`. In the parent chart's values.yaml,
set the value to true and provide the file `templates/config.yaml` for your use case. If you start by copying `config.yaml` from this chart and
want to access values from this chart you must change all references from `.Values` to `.Values.jenkins`.

```
customConfigMap: true
```

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `persistence.volumes` and `persistence.mounts` parameters.

### Persistence Values

| Parameter                   | Description                     | Default         |
| --------------------------- | ------------------------------- | --------------- |
| `persistence.enabled`       | Enable the use of a Jenkins PVC | `true`          |
| `persistence.existingClaim` | Provide the name of a PVC       | `nil`           |
| `persistence.accessMode`    | The PVC access mode             | `ReadWriteOnce` |
| `persistence.size`          | The size of the PVC             | `8Gi`           |
| `persistence.storageClass`  | The storage class of the PV     | `nil`           |

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set persistence.existingClaim=PVC_NAME stable/jenkins
```

## Service

| Parameter                          | Description                  | Default     |
| ---------------------------------- | ---------------------------- | ----------- |
| `service.type`                     | k8s service type             | `ClusterIP` |
| `service.externalPort`             | k8s node port                | `80`        |
| `service.internalPort`             | Master listening port        | `8080`      |
| `service.loadBalancerSourceRanges` | Allowed inbound IP addresses | `0.0.0.0/0` |

## Ingress

| Parameter             | Description               | Default                   |
| --------------------- | ------------------------- | ------------------------- |
| `ingress.enabled`     | Ingress enabled           | `false`                   |
| `ingress.hosts`       | Ingress hosts             | `['chart-example.local']` |
| `ingress.annotations` | Ingress annotations       | `{}`                      |
| `ingress.tls`         | Ingress TLS configuration | `[]`                      |

## NetworkPolicy

| Parameter                 | Description              | Default              |
| ------------------------- | ------------------------ | -------------------- |
| `networkPolicy.enabled`   | NetworkPolicy enabled    | `false`              |
| `networkPolicy.apiVersion`| NetworkPolicy apiVersion | `extensions/v1beta1` |

To make use of the NetworkPolicy resources created by default,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin).

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

## RBAC

| Parameter     | Description                                                         | Default         |
| ------------- | ------------------------------------------------------------------- | --------------- |
| `rbac.create` | Create service account and ClusterRoleBinding for Kubernetes plugin | `false`         |

If running upon a cluster with RBAC enabled you will need to do the following:

* `helm install stable/jenkins --set rbac.install=true`
* Create a Jenkins credential of type Kubernetes service account with service account name provided in the `helm status` output.
* Under configure Jenkins -- Update the credentials config in the cloud section to use the service account credential you created in the step above.
