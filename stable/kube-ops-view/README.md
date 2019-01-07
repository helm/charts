# Kubernetes Operational View Helm Chart

[Kubernetes Operational View](https://github.com/hjacobs/kube-ops-view) provides a read-only system dashboard for multiple K8s clusters

## Installing the Chart

To install the chart with the release name my-release:

```console
$ helm install --name=my-release stable/kube-ops-view
```

The command deploys Kubernetes Operational View on the Kubernetes cluster in the default configuration.

## Accessing the UI

```console
$ kubectl proxy
```

## Using with Redis

```console
$ helm install --set redis.enabled=true --name=my-release stable/kube-ops-view
```

Assuming you used `my-release` for installation, you can now access the UI in your browser by opening http://localhost:8001/api/v1/proxy/namespaces/default/services/my-release-kube-ops-view/

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
