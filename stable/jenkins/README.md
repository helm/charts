# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

Inspired by the awesome work of Carlos Sanchez <carlos@apache.org>

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/jenkins
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master

| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `Master.Name`                     | Jenkins master name                  | `jenkins-master`                                                             |
| `Master.Image`                    | Master image name                    | `jenkinsci/jenkins`                                                          |
| `Master.ImageTag`                 | Master image tag                     | `2.46.1`                                                                     |
| `Master.ImagePullPolicy`          | Master image pull policy             | `Always`                                                                     |
| `Master.ImagePullSecret`          | Master image pull secret             | Not set                                                                      |
| `Master.Component`                | k8s selector key                     | `jenkins-master`                                                             |
| `Master.UseSecurity`              | Use basic security                   | `true`                                                                       |
| `Master.AdminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin`                                  |
| `Master.Cpu`                      | Master requested cpu                 | `200m`                                                                       |
| `Master.Memory`                   | Master requested memory              | `256Mi`                                                                      |
| `Master.ServiceAnnotations`       | Service annotations                  | `{}`                                                                         |
| `Master.ServiceType`              | k8s service type                     | `LoadBalancer`                                                               |
| `Master.ServicePort`              | k8s service port                     | `8080`                                                                       |
| `Master.NodePort`                 | k8s node port                        | Not set                                                                      |
| `Master.ContainerPort`            | Master listening port                | `8080`                                                                       |
| `Master.SlaveListenerPort`        | Listening port for agents            | `50000`                                                                      |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                                                                  |
| `Master.LoadBalancerIP`           | Optional fixed external IP           | Not set                                                                      |
| `Master.JMXPort`                  | Open a port, for JMX stats           | Not set                                                                      |
| `Master.CustomConfigMap`          | Use a custom ConfigMap               | `false`                                                                      |
| `Master.Ingress.Annotations`      | Ingress annotations                  | `{}`                                                                         |
| `Master.Ingress.TLS`              | Ingress TLS configuration            | `[]`                                                                         |
| `Master.InitScripts`              | List of Jenkins init scripts         | Not set                                                                      |
| `Master.InstallPlugins`           | List of Jenkins plugins to install   | `kubernetes:0.11 workflow-aggregator:2.5 credentials-binding:1.11 git:3.2.0` |
| `Master.ScriptApproval`           | List of groovy functions to approve  | Not set                                                                      |
| `Master.NodeSelector`             | Node labels for pod assignment       | `{}`                                                                         |
| `Master.Tolerations`              | Toleration labels for pod assignment | `{}`                                                                         |
| `NetworkPolicy.Enabled`           | Enable creation of NetworkPolicy resources. | `false`                                                               |
| `NetworkPolicy.ApiVersion`        | NetworkPolicy ApiVersion             | `extensions/v1beta1`                                                         |
| `rbac.install`                    | Create service account and ClusterRoleBinding for Kubernetes plugin | `false`                                       |
| `rbac.apiVersion`                 | RBAC API version                     | `v1beta1`                                                                    |
| `rbac.roleRef`                    | Cluster role name to bind to         | `cluster-admin`                                                              |

### Jenkins Agent

| Parameter               | Description                                     | Default                |
| ----------------------- | ----------------------------------------------- | ---------------------- |
| `Agent.AlwaysPullImage` | Always pull agent container image before build  | `false`                |
| `Agent.Enabled`         | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `Agent.Image`           | Agent image name                                | `jenkinsci/jnlp-slave` |
| `Agent.ImagePullSecret` | Agent image pull secret                         | Not set                |
| `Agent.ImageTag`        | Agent image tag                                 | `2.62`                 |
| `Agent.Privileged`      | Agent privileged container                      | `false`                |
| `Agent.Cpu`             | Agent requested cpu                             | `200m`                 |
| `Agent.Memory`          | Agent requested memory                          | `256Mi`                |
| `Agent.volumes`         | Additional volumes                              | `nil`                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Mounting volumes into your Agent pods

Your Jenkins Agents will run as pods, and it's possible to inject volumes where needed:

```yaml
Agent:
  volumes:
  - type: Secret
    secretName: jenkins-mysecrets
    mountPath: /var/run/secrets/jenkins-mysecrets
```

The suported volume types are: `ConfigMap`, `EmptyDir`, `HostPath`, `Nfs`, `Pod`, `Secret`. Each type supports a different set of configurable attributes, defined by [the corresponding Java class](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/main/java/org/csanchez/jenkins/plugins/kubernetes/volumes).

## NetworkPolicy

To make use of the NetworkPolicy resources created by default,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin).

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"


Install helm chart with network policy enabled: 

    $ helm install stable/jenkins --set NetworkPolicy.Enabled=true

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

### Persistence Values

| Parameter                   | Description                     | Default         |
| --------------------------- | ------------------------------- | --------------- |
| `Persistence.Enabled`       | Enable the use of a Jenkins PVC | `true`          |
| `Persistence.ExistingClaim` | Provide the name of a PVC       | `nil`           |
| `Persistence.AccessMode`    | The PVC access mode             | `ReadWriteOnce` |
| `Persistence.Size`          | The size of the PVC             | `8Gi`           |
| `Persistence.volumes`       | Additional volumes              | `nil`           |
| `Persistence.mounts`        | Additional mounts               | `nil`           |


#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set Persistence.ExistingClaim=PVC_NAME stable/jenkins
```

## Custom ConfigMap

When creating a new parent chart with this chart as a dependency, the CustomConfigMap parameter can be used to override the default config.xml provided. It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`, by modifying the `apply_config.sh` section of in the parent charts values.yaml. To enable CustomConfigMap, in the parent charts values.yaml, set the value of the CustomConfigMap parameter to true and provide the file `templates/config.yaml` for your use case.

```yaml
# parentchartname/values.yaml contents
jenkins:
  Master:
    CustomConfigMap: true
```

If you start by copying `config.yaml` from this chart and want to access values from this chart you must change all references from `.Values` to `.Values.jenkins`.

Additionally, when copying the `config.yaml` from this chart for use in the
parent chart as a bassis for customization, it is necessary to change the name of the config map to match
what this chart (now acting as a subchart) expects, which is `<RELEASENAME>-CHARTNAME>`, where the chart name is expected to be `jenkins` in the subchart. However, when relying on the default `__helpers.tpl` provided name, the parent chart's generated configmap name  will not match and look like: `<RELEASENAME>-<PARENT_CHARTNAME>`. To fix this, update your parent charts `__helpers.tpl` or inline something to the effect of this into the name portion of your parent charts `templates/config.yaml`:

```yaml
# parentchartname/templates/config.yaml snippet
metadata:
  name: {{- printf " %s-%s" .Release.Name "jenkins\n" | trunc 63 | trimSuffix "-" -}}
```

:exclamation: **Warning!** when CustomConfigMap is set to true, the jenkins
master pod will be recreated on every `helm update` no matter if there is
a value or template change. This is necessary because
usually the pod restart is only done when the compiled templates/config.yaml
changes (see the sha256 annotation of it in
templates/jenkins-master-deployment.yaml). When running as a subchart, this
file never changes. Conditionally changing this to work off of
the parent charts compiled templates/config.yaml won't work either because the
subchart isn't aware of `.Values.jenkins` values, so the parent chart won't
compile from the subchart.


## RBAC

If running upon a cluster with RBAC enabled you will need to do the following:

* `helm install stable/jenkins --set rbac.install=true`
* Create a Jenkins credential of type Kubernetes service account with service account name provided in the `helm status` output.
* Under configure Jenkins -- Update the credentials config in the cloud section to use the service account credential you created in the step above.
