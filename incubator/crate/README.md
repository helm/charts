# CrateDB Helm Chart

Deploy a cluster of CrateDB instances on K8S with this chart.

The `templates` directory contains the definition of the service and the statefulset.

The `values.yml` file contains the default values you can tweak for the `crate.yml` template.

Install this chart from this folder using `helm install .`.
You may want to adjust first your preferred number of nodes in `values.yml`.

## Configuration

The following table lists the configurable parameters of the crateDB chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| crate.clusterName | Name of CrateDB cluster. See [docs](https://crate.io/docs/crate/guide/en/4.0.3/scaling/multi-node-setup.html#id3) | my-cluster |
| crate.crateHeapSize | See [docs](https://crate.io/docs/crate/reference/en/4.0.3/config/environment.html) | 1g |
| crate.recoverAfterNodes | See [docs](https://crate.io/docs/crate/guide/en/4.0.3/scaling/multi-node-setup.html#gateway-configuration) | 1 |
| crate.replicas | The number of instances to deploy. Also the number of expected nodes in the cluster formation | 1 |
| crate.recoverAfterTime | See [docs](https://crate.io/docs/crate/guide/en/4.0.3/scaling/multi-node-setup.html#gateway-configuration) | 5m |
| http.cors.enabled | Whether CORS is enabled. See [docs](https://crate.io/docs/crate/reference/en/4.0.3/config/node.html#cross-origin-resource-sharing-cors) | False |
| http.cors.allowOrigin | CORS origin to allow (if enabled). See [docs](https://crate.io/docs/crate/reference/en/4.0.3/config/node.html#cross-origin-resource-sharing-cors) | * |
| image.name | Container image name | crate |
| image.tag | Container image tag (version) | 4.0.3 |
| image.pullPolicy | Container pull policy | IfNotPresent |
| service.name | Name of K8S service created for CrateDB | crate |
| service.type | Type of K8S service created for CrateDB | ClusterIP |

## More info

You can read more about CrateDB in:

- [Official Docs](https://crate.io/docs/)
- [Docker Hub](https://hub.docker.com/_/crate/)
