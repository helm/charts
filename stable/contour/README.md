# Contour

[Contour](https://github.com/heptio/contour) is an Ingress controller for Kubernetes that works by deploying the Envoy proxy as a reverse proxy and load balancer. Unlike other Ingress controllers, Contour supports dynamic configuration updates out of the box while maintaining a lightweight profile.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release .
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```
## Upgrading the Chart

```bash
$ helm upgrade --install my-release .
```


## Configuration

The default configuration values for this chart are listed in `values.yaml`.

| Parameter                             | Description                                                  | Default                                           |
|---------------------------------------|-------------------------------------                         |---------------------------------------------------|
| `deployment.replicas`                 | Number of replica sets                                       | 2                                                 |
| `contour.image.repository`            | Repository for contour container image                       | gcr.io/heptio-images/contour                      |
| `contour.image.tag`                   | Contour image tag                                            | master                                            |
| `contour.image.pullPolicy`            | Image pull policy                                            | Always                                            |
| `contour.command`                     | Command for contour pod                                      | contour                                           |
| `contour.args`                        | Contour run command arguments                                | `[]`                                              |
| `contour.annotations`                 | Annotations to enable prometheus monitoring                  | `{}`                                              |
| `envoy.image.repository`              | Repository for envoy container image                         | docker.io/envoyproxy/envoy-alpine                 |
| `envoy.image.tag`                     | Envoy image tag                                              | v1.6.0                                            |
| `envoy.image.pullPolicy`              | Image pull policy                                            | IfNotPresent                                      |
| `envoy.command`                       | Command for envoy pod                                        | envoy                                             |
| `envoy.args`                          | Envoy run command arguments                                  | `[]`                                              |
| `envoy.container.name`                | Envoy container name                                         | envoy                                             |
| `initcontainer.name`                  | Envoy initconfig container name                              | envoy-initconfg                                   |
| `initcontainer.command`               | Envoy init container command                                 | envoy                                             |
| `initcontainer.args`                  | Envoy init container command arguments                       | `[]`                                              |
| `service.annotations`                 | Service annotations                                          | `{}`                                              |
| `service.externalHttpPort`            | Service external http port                                   | 80                                                |
| `service.externalHttpsPort`           | Service external https port                                  | 443                                               |
| `service.internalHttpPort`            | Service internal http port                                   | 8080                                              |
| `service.internalHttpsPort`           | Service internal https port                                  | 8443                                              |
| `service.protocol`                    | Service Protocol                                             | TCP                                               |
| `service.loadBalancerType`            | Service Load Balancer type                                   | LoadBalancer                                      |
| `rbac.create`                         | Create rbac role for contour                                 | true                                              |
| `serviceAccount.create`               | Create service account for contour                           | true                                              |
| `serviceAccount.name`                 | Service account name                                         |                                                   |
| `hpa.create`                          | Create hpa for contour                                       | false                                             |
| `hpa.minReplicas`                     | Autoscaling minimum replicaset count                         | 2                                                 |
| `hpa.maxReplicas`                     | Autoscaling maximum replicaset count                         | 15                                                |
| `hpa.targetCPUUtilizationPercentage`  | Threshold cpu usage                                          | 70                                                |
| `resources.limit.cpu`                 | Vertical scaling cpu limit                                   | 400m                                              |
| `resources.requests.cpu`              | Vertical scaling cpu requests                                | 200m                                              |


## Example workload

Start Minikube by running the below command:
```
minikube start
```

Install tiller
```
helm init
```
Install or upgrade contour
```
helm upgrade --install contour --namespace contour --set service.loadBalancerType=ClusterIP .
```

If you don't have an application ready to run with Contour, you can explore with [kuard](https://github.com/kubernetes-up-and-running/kuard).

```
kubectl apply -f https://j.hept.io/contour-kuard-example
```

This example specifies a default backend for all hosts, so that you can test your Contour install. It's recommended for exploration and testing only, however, because it responds to all requests regardless of the incoming DNS that is mapped. You probably want to run with specific Ingress rules for specific hostnames.

Access your cluster

```
$ kubectl get -n  service contour -o wide
```

Access Kuard application
```
minikube ssh
curl <CLUSTER-IP>
```
