# CrateDB Helm Chart

Deploy a cluster of CrateDB instances on K8S with this chart.

The `templates` directory contains the definition of the service and the statefulset.

The `values.yml` file contains the default values you can tweak for the `crate.yml` template.

Install this chart from this folder using `helm install .`.
You may want to adjust first your preferred number of nodes in `values.yml`.

## Configuration

The following table lists the configurable parameters of the CrateDB chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| crate.clusterName | Name of CrateDB cluster. See [docs](https://crate.io/docs/crate/guide/en/4.0/scaling/multi-node-setup.html#id3) | crate |
| crate.crateHeapSize | See [docs](https://crate.io/docs/crate/reference/en/4.0/config/environment.html) | 1g |
| crate.numberOfNodes | The number of instances to deploy. Also the number of expected nodes in the cluster formation | 1 |
| crate.recoverAfterNodes | See [docs](https://crate.io/docs/crate/guide/en/4.0/scaling/multi-node-setup.html#gateway-configuration) | floor(crate.numberOfNodes/2) + 1 |
| http.cors.enabled | Whether CORS is enabled. See [docs](https://crate.io/docs/crate/reference/en/4.0/config/node.html#cross-origin-resource-sharing-cors) | False |
| http.cors.allowOrigin | CORS origin to allow (if enabled). See [docs](https://crate.io/docs/crate/reference/en/4.0/config/node.html#cross-origin-resource-sharing-cors) | * |
| image.tag | Container image tag (version) | 4.0.4 |
| service.name | Name of K8S service created for CrateDB | crate |
| service.ports.ui | Port to use for admin UI | 4200 |
| service.ports.psql | Port to use for psql connections | 5432 |
| service.type | Type of K8S service created for CrateDB | ClusterIP |

## More info

You can read more about CrateDB in:

- [Official Docs](https://crate.io/docs/)
- [Docker Hub](https://hub.docker.com/_/crate/)
