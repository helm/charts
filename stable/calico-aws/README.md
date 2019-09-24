# Calico
This helm chart installs [Calico] (https://www.projectcalico.org) network policy engine to AWS EKS.
Please note that even though Project Calico supports many different configurations, this exact Helm Chart is made specifically to run Calico on AWS EKS.

It is based on example calico implementation from AWS:
https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.5/config/v1.5/calico.yaml

Calico engine allows to use [Kubernetes Network Policies] (https://kubernetes.io/docs/concepts/services-networking/network-policies/) on AWS EKS.

# Dependencies
* Kubernetes 1.13 or later (may run on earlier versions, but not tested)
* AWS EKS

# Running
You can run this Helm chart with default settings:
```
helm install --namespace kube-system .
```

This will create the following pods (together with other resources):
 - [Typha] (https://github.com/projectcalico/typha)
 - [Typha autoscaler] (https://github.com/kubernetes-incubator/cluster-proportional-autoscaler)
 - [Calico Node (Felix)] (https://github.com/projectcalico/node)

Uninstalling:
```
helm delete <release_name>
```

## Verify
Follow the steps listed in [Kubernetes Network Policies] (https://kubernetes.io/docs/concepts/services-networking/network-policies/) documentation to make sure service works as expected.

## Namespace
Default setup is using built in priorityclasses (_system-cluster-critical_ and _system-node-critical_) which are currently restricted to _kube-system_ namespace.
Follow [this github issue] (https://github.com/kubernetes/kubernetes/issues/76308) to see if anything has changed.

It is possible to run typha in a custom namespace, in this case you either need to create a custom priority class:
```
priorityClassNode:
  create: true
priorityClassCluster:
  create: true
```
Or set priorityClass name to null, to skip this setting completely:
```
priorityClassNode:
  name: null
priorityClassCluster:
  name: null
```

##

## Configuration
Please refer to these documents and sources for information on Typha, Calico and autoscaler configuration parameters:
- [Typha documentation] (https://docs.projectcalico.org/v3.7/reference/typha/configuration)
- [Typha source] (https://github.com/projectcalico/typha/blob/master/pkg/config/config_params.go)
- [Felix documentation] (https://docs.projectcalico.org/v3.7/reference/felix/configuration)
- [Felix source] (https://github.com/projectcalico/felix/blob/master/config/config_params.go)
- [Cluster propotional autoscaler] (https://github.com/kubernetes-incubator/cluster-proportional-autoscaler)

### Parameters
The following table summarizes chart configuration parameters.

| Parameter | Description | Default |
| ---       | ---         | ---     |
| `serviceAccount.calico.create` | Create a service account for Typha and Calico node | `true` |
| `serviceAccount.calico.name` | Provide a name of existing service account for Typha and Calico node (set `serviceAccount.calico.create` to `false`)| `null` |
| `serviceAccount.calico.automountToken` | Automount Service Account token into Pod | `true` |
| `serviceAccount.typhaCpha.create` | Create a service account for Typha autoscaler | `true` |
| `serviceAccount.typhaCpha.name` | Provide a name of existing service account for Typha autoscaler (set `serviceAccount.typhaCpha.create` to `false`)| `null` |
| `serviceAccount.typhaCpha.automountToken` | Automount Service Account token into Pod | `false` |
| `priorityClassNode.name` | Priority Class name for Calico Node, priority class must exist | `system-node-critical` |
| `priorityClassNode.create` | Create a custom priority class for Calico Node | `false` |
| `priorityClassNode.nameSuffix` | Name suffix for a custom priority class | `node-high` |
| `priorityClassNode.value` | Value for a custom priority class | `1001000` |
| `priorityClassNode.labels` | Custom priority class extra labels | `{}` |
| `priorityClassNode.annotations` | Custom priority class extra annotations | `{}` |
| `priorityClassCluster.name` | Priority Class name for Typha, priority class must exist | `system-cluster-critical` |
| `priorityClassCluster.create` | Create a custom priority class for Typha | `false` |
| `priorityClassCluster.nameSuffix` | Name suffix for a custom priority class | `node-high` |
| `priorityClassCluster.value` | Value for a custom priority class | `1000000` |
| `priorityClassCluster.labels` | Custom priority class extra labels | `{}` |
| `priorityClassCluster.annotations` | Custom priority class extra annotations | `{}` |
| `calicoNode.image.registry` | Override standard Docker image registry | `quay.io` |
| `calicoNode.image.name` | Override standard Docker image name | `calico/node` |
| `calicoNode.image.tag` | Override standard Docker image tag | `v3.3.6` |
| `calicoNode.image.pullPolicy` | Override standard Docker image pull policy | `IfNotPresent` |
| `calicoNode.image.pullSecrets` | Provide docker secret name to pull images. Must be an array: `["docker-secret"]` | `null` |
| `calicoNode.resources` | Resource configuration for Calico Node pods | `null` |
| `calicoNode.annotations` | Extra annotations for Calico Node Daemonset | `{}` |
| `calicoNode.labels` | Extra labels for Calico Node Daemonset | `{}` |
| `calicoNode.podAnnotations` | Extra annotations for Calico Node pods | `{}` |
| `calicoNode.podLabels` | Extra labels for Calico Node pods | `{}` |
| `calicoNode.linuxOnly` | Run node pods only on Linux instances. OpenSource Calico supports only Linux | `true` |
| `calicoNode.nodeSelector` | Node Selector configuration for Calico Node Daemonset | `null` |
| `calicoNode.affinity` | Affinity configuration for Calico Node Daemonset | `null` |
| `calicoNode.tolerations` | Tolerations configuration for Calico Node Daemonset | `null` |
| `calicoNode.prometheusScrapeAnnotations` | Add prometheus scrape annotations to Calico Node | `true` |
| `calicoNode.ports` | Port settings | see values.yaml |
| `calicoNode.env` | Environment variables for Calico Node pods. Format is `ENV_VAR_NAME: "VALUE"`. Processed as a template, dynamic parameters are accepted. | see values.yaml |
| `calicoNode.livenessProbe` | Liveness Probe for Calico Node pods. | see values.yaml |
| `calicoNode.readinessProbe` | Readiness Probe for Calico Node pods. | see values.yaml |
| `calicoNode.cert.create` | Create TLS certificate for Calico Node. Must provide cert parameters described below if set to `true` | `false` |
| `calicoNode.cert.clientCertContents` | Contents of TLS cert for Calico Node for Node <--> Typha communication. PEM format | `""` |
| `calicoNode.cert.clientKeyContents` | Contents of TLS cert key for Calico Node for Node <--> Typha communication. PEM format | `""` |
| `calicoNode.cert.clientCAContents` | Contents of TLS Typha CA cert for Calico Node for Node <--> Typha communication used. PEM format | `""` |
| `calicoNode.volumeMounts` | Custom volumeMounts for CalicoNode (may be used to mount existing certificates instead of creating) | `null` |
| `calicoNode.volumes` | Custom volumes for Calico Node (may be used to mount existing certificates instead of creating) | `null` |
| `typha.image.registry` | Override standard Docker image registry | `quay.io` |
| `typha.image.name` | Override standard Docker image name | `calico/typha` |
| `typha.image.tag` | Override standard Docker image tag | `v3.3.6` |
| `typha.image.pullPolicy` | Override standard Docker image pull policy | `IfNotPresent` |
| `typha.image.pullSecrets` | Provide docker secret name to pull images. Must be an array: `["docker-secret"]` | `null` |
| `typha.resources` | Resource configuration for Typha pods | `null` |
| `typha.annotations` | Extra annotations for Typha Deployment | `{}` |
| `typha.labels` | Extra labels for Typha Deployment | `{}` |
| `typha.podAnnotations` | Extra annotations for Typha pods | `{}` |
| `typha.podLabels` | Extra labels for Typha pods | `{}` |
| `typha.nodeSelector` | Node Selector configuration for Typha Deployment | `null` |
| `typha.affinity` | Affinity configuration for Typha Deployment | `null` |
| `typha.tolerations` | Tolerations configuration for Typha Deployment | `null` |
| `typha.prometheusScrapeAnnotations` | Add prometheus scrape annotations to Typha | `true` |
| `typha.ports` | Port settings | see values.yaml |
| `typha.env` | Environment variables for Typha pods. Format is `ENV_VAR_NAME: "VALUE"`. Processed as a template, dynamic parameters are accepted. | see values.yaml |
| `typha.livenessProbe` | Liveness Probe for Typha pods. | see values.yaml |
| `typha.readinessProbe` | Readiness Probe for Typha pods. | see values.yaml |
| `typha.serviceLabels` | Extra labels for Typha service. | `{}` |
| `typha.serviceAnnotations` | Extra annotations for Typha service. | `{}` |
| `typha.cert.create` | Create TLS certificate for Typha. Must provide cert parameters described below if set to `true` | `false` |
| `typha.cert.clientCertContents` | Contents of TLS cert for Typha for Node <--> Typha communication. PEM format | `""` |
| `typha.cert.clientKeyContents` | Contents of TLS cert key for Typha for Node <--> Typha communication. PEM format | `""` |
| `typha.cert.clientCAContents` | Contents of TLS Node CA cert for Typha for Node <--> Typha communication used. PEM format | `""` |
| `typha.volumeMounts` | Custom volumeMounts for Typha (may be used to mount existing certificates instead of creating) | `null` |
| `typha.volumes` | Custom volumes for Typha (may be used to mount existing certificates instead of creating) | `null` |
| `typhaCpha.image.registry` | Override standard Docker image registry | `k8s.gcr.io` |
| `typhaCpha.image.name` | Override standard Docker image name | `cluster-propotional-autoscaler-amd64` |
| `typhaCpha.image.tag` | Override standard Docker image tag | `1.1.2` |
| `typhaCpha.image.pullPolicy` | Override standard Docker image pull policy | `IfNotPresent` |
| `typhaCpha.image.pullSecrets` | Provide docker secret name to pull images. Must be an array: `["docker-secret"]` | `null` |
| `typhaCpha.replicas` | Number of autoscaler replicas | `1` |
| `typhaCpha.resources` | Resource configuration for Typha autoscaler pods | see values.yaml |
| `typhaCpha.annotations` | Extra annotations for Typha autoscaler Deployment | `{}` |
| `typhaCpha.labels` | Extra labels for Typha autoscaler Deployment | `{}` |
| `typhaCpha.podAnnotations` | Extra annotations for Typha autoscaler pods | `{}` |
| `typhaCpha.podLabels` | Extra labels for Typha autoscaler pods | `{}` |
| `typhaCpha.nodeSelector` | Node Selector configuration for Typha autoscaler Deployment | `null` |
| `typhaCpha.affinity` | Affinity configuration for Typha autoscaler Deployment | `null` |
| `typhaCpha.tolerations` | Tolerations configuration for Typha autoscaler Deployment | `null` |
| `typhaCpha.livenessProbe` | Liveness Probe for Typha autoscaler pods. | see values.yaml |
| `typhaCpha.readinessProbe` | Readiness Probe for Typha autoscaler pods. | see values.yaml |
| `typhaCpha.ladder` | Configuration for propotional autoscaler | see values.yaml |
| `typhaCpha.args` | Arguments, passed to propotional autoscaler, format: `argument: "value"`. Processed as template, dynamic values are allowed. | see values.yaml |

See `values.yaml` file for configuration notes. Specify parameters via helm `--set` flag:
```
helm install --namespace=kube-system --set serviceAccount.calico.name=foo .
```
Alternatively, create you own file with configuration overrides and supply it to helm:
```
helm install --namespace=kube-system -f value_overrides.yaml .
```
You can also add this chart to another chart as a dependency - add it to `requirements.yaml` file of a parent chart. More information [here] (https://helm.sh/docs/developing_charts/#chart-dependencies).
