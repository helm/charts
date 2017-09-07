# Mcrouter Helm Chart

Helm chart for [Mcrouter](https://github.com/facebook/mcrouter), a Memcached protocol router for scaling memcached deployments.

## Configuration

The following tables lists the configurable parameters of the consul chart and their default values.

| Parameter                     | Description                            | Default                                         |
| ----------------------------- | -------------------------------------- | ----------------------------------------------- |
| `image`                         | Container's image                      | `jamescarr/mcrouter` <br> Note: Third-party image as indicated in the [official documentation](https://github.com/facebook/mcrouter/wiki/mcrouter-installation). <br> It is recommended to build a new, up-to-date image based on the [official Dockerfile](https://github.com/facebook/mcrouter/blob/master/mcrouter/scripts/docker/Dockerfile) |
| `controller` | Controller used for deploying the Mcrouter pods. Possible values: `daemonset` or `statefulset` | `daemonset` |
| `daemonset.hostPort` | Host port used by the DaemonSet controller | `5000` |
| `mcrouterCommandParams.port`       | Port(s) to listen on (comma separated) | `5000`   |
| `mcrouterCommandParams.configFile` | The config file to use for the mcrouter command. If not provided, then `memcachedService.serviceName` and `memcachedService.replicaCount` must be provided | No value |
| `memcachedService.serviceName`  | Memcached service's name. If provided, then `memcachedService.replicaCount` must also be provided. If not provided, then `mcrouterCommandParams.configFile` must be provided | `memcached` |
| `memcachedService.replicaCount` | Number of Memcached pod replicas. If provided, then `memcachedService.serviceName` must also be provided. If not provided, then `mcrouterCommandParams.configFile` must be provided | `3` |
| `memcachedService.port`         | Memcached service's port         | `11211`     |
| `memcachedService.namespace`    | Memcached service's namespace    | `default`   |
| `resources.requests.cpu`    | CPU resource requests    | `100m`  |
| `resources.limits.cpu`      | CPU resource limits      | `256m`  |
| `resources.requests.memory` | Memory resource requests | `128Mi` |
| `resources.limits.memory`   | Memory resource limits   | `512Mi` |
| `statefulset.replicas` | Number of pod replicas used by the StatefulSet controller | `1` |
| `statefulset.antiAffinity` | Pod anti-affinity logic used by the StatefulSet controller. Possible values: `hard`, `soft` | `hard` |

## Controllers

This chart allows the use of two different controllers: DaemonSet (default) and StatefulSet.

If using the DaemonSet controller then each Mcrouter pods will connect to a port on their respective node' host (defaults to `5000`). Each of your application pods may then connect to the same port on their respective node. To access the node's name, you may expose that name via an environment variable with the `spec.nodeName` entry in your application's PodSpec as described in the Kubernetes [documentation](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/).

If using the StatefulSet controller then the service can be accessed by default on port `5000` on the following DNS name from within your cluster: `<release name>-mcrouter.<namespace>.svc.cluster.local`.

## Testing

Install the Memcached chart:

    helm install stable/memcached --name mycache --set replicaCount=3

Install the Mcrouter chart:

    helm install mcrouter-helm-chart/mcrouter --name=myproxy --set memcachedService.serviceName="mycache-memcached" --set memcachedService.replicaCount=3

Connect to one of the Mcrouter pods:

    MCROUTER_POD_IP=$(kubectl get pods -l app=myproxy-mcrouter -o jsonpath="{.items[0].status.podIP}")
    
    kubectl run -it --rm alpine --image=alpine --restart=Never telnet $MCROUTER_POD_IP 5000
    
    set mykey 0 0 5
    
    hello
    
    get mykey
    
    quit
