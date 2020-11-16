# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Kubernetes Operational View Helm Chart

[Kubernetes Operational View](https://github.com/hjacobs/kube-ops-view) provides a read-only system dashboard for multiple K8s clusters

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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

## Variables
| Parameter                              | Description                                                                      | Default                                           |
| -------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------- |
| `env`                                  | Pass environment variables to the pod ([more info](https://github.com/hjacobs/kube-ops-view#configuration)) | `{}` |
