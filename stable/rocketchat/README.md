# Rocket.Chat

[Rocket.Chat](https://rocket.chat/) is free, unlimited and open source. Replace email, HipChat & Slack with the ultimate team chat software solution.

> **WARNING**: Upgrading to chart version 1.1.x or higher (Rocket.Chat 1.0+) might require extra steps to retain the MongoDB data. See [Upgrading to 1.1.0](###-To-1.1.0) for more details.

## TL;DR;

```console
$ helm install stable/rocketchat --set mongodb.mongodbPassword=$(echo -n $(openssl rand -base64 32)),mongodb.mongodbRootPassword=$(echo -n $(openssl rand -base64 32))
```

## Introduction

This chart bootstraps a [Rocket.Chat](https://rocket.chat/) Deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It provisions a fully featured Rocket.Chat installation.

In addition, this chart supports scaling of Rocket.Chat for increased server capacity and high availability.  For more information on Rocket.Chat and its capabilities, see its [documentation](https://rocket.chat/docs/).

## Prerequisites Details

The chart has an optional dependency on the [MongoDB](https://github.com/kubernetes/charts/tree/master/stable/mongodb) chart.
By default, the MongoDB chart requires PV support on underlying infrastructure (may be disabled).

## Installing the Chart

To install the chart with the release name `rocketchat`:

```console
$ helm install --name rocketchat stable/rocketchat
```

## Uninstalling the Chart

To uninstall/delete the `rocketchat` deployment:

```console
$ helm delete rocketchat
```

## Configuration

The following table lists the configurable parameters of the Rocket.Chat chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | Image repository | `docker.io/rocketchat/rocket.chat`
`image.tag` | Image tag | `1.3.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`host` | Hostname for Rocket.Chat. Also used for ingress (if enabled) | `""`
`replicaCount` | Number of replicas to run | `1`
`smtp.enabled` | Enable SMTP for sending mails | `false`
`smtp.username` | Username of the SMTP account | `""`
`smtp.password` | Password of the SMTP account | `""`
`smtp.host` | Hostname of the SMTP server | `""`
`smtp.port` | Port of the SMTP server | `587`
`extraEnv` | Extra environment variables for Rocket.Chat. Used with `tpl` function, so this needs to be a string | `""`
`podAntiAffinity` | Pod anti-affinity can prevent the scheduler from placing RocketChat replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. | `""` |
`podAntiAffinityTopologyKey` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example `failure-domain.beta.kubernetes.io/zone`| `kubernetes.io/hostname` |
| `affinity` | Assign custom affinity rules to the RocketChat instance https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ | `{}` |
`minAvailable` | Minimum number / percentage of pods that should remain scheduled | `1` |
`externalMongodbUrl` | MongoDB URL if using an externally provisioned MongoDB | `""`
`externalMongodbOplogUrl` | MongoDB OpLog URL if using an externally provisioned MongoDB. Required if `externalMongodbUrl` is set | `""`
`mongodb.enabled` | Enable or disable MongoDB dependency. Refer to the [stable/mongodb docs](https://github.com/helm/charts/tree/master/stable/mongodb#configuration) for more information | `true`
`persistence.enabled` | Enable persistence using a PVC. This is not necessary if you're using the default (and recommended) [GridFS](https://rocket.chat/docs/administrator-guides/file-upload/) file storage | `false`
`persistence.storageClass` | Storage class of the PVC to use | `""`
`persistence.accessMode` | Access mode of the PVC | `ReadWriteOnce`
`persistence.size` | Size of the PVC | `8Gi`
`resources` | Pod resource requests and limits | `{}`
`securityContext.enabled` | Enable security context for the pod | `true`
`securityContext.runAsUser` | User to run the pod as | `999`
`securityContext.fsGroup` | fs group to use for the pod | `999`
`serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true`
`serviceAccount.name` | Name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `""`
`ingress.enabled` | If `true`, an ingress is created | `false`
`ingress.annotations` | Annotations for the ingress | `{}`
`ingress.path` | Path of the ingress | `/`
`ingress.tls` | A list of [IngressTLS](https://kubernetes.io/docs/reference/federation/extensions/v1beta1/definitions/#_v1beta1_ingresstls) items | `[]`
`service.annotations` | Annotations for the Rocket.Chat service | `{}`
`service.labels` | Additional labels for the Rocket.Chat service | `{}`
`service.type` | The service type to use | `ClusterIP`
`service.port` | The service port | `80`
`service.nodePort` | The node port used if the service is of type `NodePort` | `""`
`podLabels` | Additional pod labels for the Rocket.Chat pods | `{}`
`podAnnotations` | Additional pod annotations for the Rocket.Chat pods | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name rocketchat -f values.yaml stable/rocketchat
```

### Database Setup

Rocket.Chat uses a MongoDB instance to presist its data.
By default, the [MongoDB](https://github.com/kubernetes/charts/tree/master/stable/mongodb) chart is deployed and a single MongoDB instance is created as the primary in a replicaset.  
Please refer to this chart for additional MongoDB configuration options.
If you are using chart defaults, make sure to set at least the `mongodb.mongodbRootPassword`, `mongodb.mongodbUsername` and `mongodb.mongodbPassword` values. 
> **WARNING**: The root credentials are used to connect to the MongoDB OpLog

#### Using an External Database

This chart supports using an existing MongoDB instance. Use the `` configuration options and disable MongoDB with `--set mongodb.enabled=false`

### Configuring Additional Environment Variables

```yaml
extraEnv: |
  - name: MONGO_OPTIONS
    value: '{"ssl": "true"}'
```

### Increasing Server Capacity and HA Setup

To increase the capacity of the server, you can scale up the number of Rocket.Chat server instances across available computing resources in your cluster, for example,

```bash
$ kubectl scale --replicas=3 deployment/rocketchat
```

By default, this chart creates one MongoDB instance as a Primary in a replicaset.  This is the minimum requirement to run Rocket.Chat 1.x+.    You can also scale up the capacity and availability of the MongoDB cluster independently.  Please see the [MongoDB chart](https://github.com/kubernetes/charts/tree/master/stable/mongodb) for configuration information.

For information on running Rocket.Chat in scaled configurations, see the [documentation](https://rocket.chat/docs/installation/docker-containers/high-availability-install/#guide-to-install-rocketchat-as-ha-with-mongodb-replicaset-as-backend) for more details.

## Upgrading

### To 1.1.0

Rocket.Chat version 1.x requires a MongoDB ReplicaSet to be configured. When using the dependent `stable/mongodb` chart (`mongodb.enabled=true`), enabling ReplicaSet will drop the PVC and create new ones. Make sure to backup your current MongoDB and restore it after the upgrade.

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is rocketchat:

```console
$ kubectl delete deployment rocketchat-rocketchat --cascade=false
```
