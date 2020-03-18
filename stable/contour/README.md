# Contour

[Contour](https://github.com/heptio/contour) is an Ingress controller for Kubernetes that works by deploying the Envoy proxy as a reverse proxy and load balancer. Unlike other Ingress controllers, Contour supports dynamic configuration updates out of the box while maintaining a lightweight profile.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/contour
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```
## Upgrading the Chart
To upgrade the `my-release` deployment:

```bash
$ helm upgrade --install my-release stable/contour
```


## Configuration

The default configuration values for this chart are listed in `values.yaml`.

| Parameter                             | Description                                                          | Default                                           |
|---------------------------------------|-------------------------------------                                 |---------------------------------------------------|
| `contour.image.registry`             | Registry for the contour container image                                  | `gcr.io/heptio-images/contour`             |
| `contour.image.tag`                  | Contour image tag                                                     | `v0.15.0`                                  |
| `contour.image.pullPolicy`           | Image pull policy                                                     | `IfNotPresent`                             |
| `contour.replicas`                   | Replica count for the contour deployment                              | `2`                                        |
| `contour.resources`                   | 	Resource definitions for the contour pods                        | `{}`                                       |
| `customResourceDefinitions.create`   | Whether the release should install CRDs. Regardless of this value, Helm v3+ will install the CRDs if those are not present already. Use `--skip-crds` with `helm install` if you want to skip CRD creation                               | `true`
| `customResourceDefinitions.cleanup`   | Whether to remove installed CRD definitions and CRDs                | `false`                                    |
| `envoy.image.registry`                | Registry for envoy container image                         | `docker.io/envoyproxy/envoy-alpine`                 |
| `envoy.image.tag`                     | Envoy image tag                                              | `v1.11.1`                                           |
| `envoy.image.pullPolicy`              | Image pull policy                                            | `IfNotPresent`                                      |
| `envoy.resources`                     | 	Resource definitions for the envoy pods                | `{}` |
| `hpa.create`                          | Create hpa for contour                                               | `false`                                             |
| `hpa.minReplicas`                     | Autoscaling minimum replicaset count                                 | `2`                                                 |
| `hpa.maxReplicas`                     | Autoscaling maximum replicaset count                                 | `15`                                                |
| `hpa.targetCPUUtilizationPercentage`  | Threshold cpu usage                                                  | `70`        
| `init.image.registry`                | Registry for the contour init container image                         | `gcr.io/heptio-images/contour`                 |
| `init.image.tag`                     | Init image tag                                              | `v0.15.0`                                           |
| `init.image.pullPolicy`              | Image pull policy                                            | `IfNotPresent`                                      |                               |
| `init.resources`                     | 	Resource definitions for the init pods                | `{}` |
| `rbac.create`                        | Whether the release should create RBAC objects                         | `true`                                     |
| `serviceType`                        | The type of Service Contour will use                                  | `LoadBalancer`                                      |
| `service.nodePorts.http`             | Desired nodePort for service of type NodePort used for http requests  | nil `""` - will assign a dynamic node port |
| `service.nodePorts.https`            | Desired nodePort for service of type NodePort used for https requests | nil `""` - will assign a dynamic node port |
| `serviceAccounts.create`             | Whether the release should create Service Account objects              | `true`                                     |
## Project Contour CRDs

The CRDs are provisioned using crd-install hooks, rather than relying on a separate chart installation. If you already have these CRDs provisioned and don't want to remove them, you can disable the CRD creation by these hooks by passing `customResourceDefinitions.create=false` (not required if using Helm v3).

## Example workload

Start a cluster using [Kind](https://github.com/kubernetes-sigs/kind) by running the below command:
```
kind create cluster --name=kind
```
Ensure kubectl configuration is set to the newly created Kind cluster
```
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
```
Ensure tiller has permission to install (no recommended for production)
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
```
Install tiller
```
helm init --service-account tiller
```
Install or upgrade contour
```
helm upgrade --install contour --namespace contour --set service.loadBalancerType=ClusterIP .
```

If you don't have an application ready to run with Contour, you can explore with [kuard](https://github.com/kubernetes-up-and-running/kuard).

```
kubectl apply -f https://projectcontour.io/examples/kuard.yaml
```

This example specifies a default backend for all hosts, so that you can test your Contour install. It's recommended for exploration and testing only, however, because it responds to all requests regardless of the incoming DNS that is mapped. You probably want to run with specific Ingress rules for specific hostnames.

Get the Contour ClusterIP

```
$ CLUSTER_IP=$(kubectl -n contour get svc | grep contour | awk '{print $3}')
```

Access Kuard application via internal Contour Service ClusterIP
```
docker exec -ti kind-control-plane curl $CLUSTER_IP
```
