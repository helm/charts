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
| app | Name used in resource metadata. | crate |
| crate.clusterName | Name of CrateDB cluster - [docs](https://crate.io/docs/crate/guide/en/latest/scaling/multi-node-setup.html#id3) | crate |
| crate.heapSize | Crate's heap size (in GiB) - [docs](https://crate.io/docs/crate/reference/en/4.0/config/environment.html) | 1 |
| crate.numberOfNodes | Number of pods (Crate nodes) | 1 |
| crate.recoverAfterNodes | See [docs](https://crate.io/docs/crate/guide/en/latest/scaling/multi-node-setup.html#gateway-configuration) | floor(crate.numberOfNodes/2) + 1 |
| http.cors.enabled | Whether CORS is enabled - [docs](https://crate.io/docs/crate/reference/en/4.0/config/node.html#cross-origin-resource-sharing-cors) | False |
| http.cors.allowOrigin | CORS origin to allow (if enabled) - [docs](https://crate.io/docs/crate/reference/en/4.0/config/node.html#cross-origin-resource-sharing-cors) | * |
| image.tag | Crate image tag (version) | 4.0.4 |
| persistentVolume.enabled | Whether to use a persistent volume (vs. memory) | true |
| persistentVolume.storageClass | Storage class of the PV (if enabled) | retain |
| persistentVolume.accessModes | Access modes of the PV (if enabled) | [ReadWriteOnce] |
| persistentVolume.size | Size of the PV (if enabled) | 10Gi |
| persistentVolume.annotations | Annotations of the PV (if enabled) | {} |
| resources.limits.cpu | Maximum CPU per pod | 1 |
| resources.limits.memory | Maximum memory per pod | crate.heapSize * 3 |
| resources.requests.cpu | Amount of CPU requested per pod | 500m |
| service.name | Name of K8s service created for CrateDB | crate |
| service.ports.ui | Port to use for admin UI | 4200 |
| service.ports.psql | Port to use for psql connections | 5432 |
| service.type | Type of K8s service created for CrateDB | ClusterIP |

NB: `resources.requests.memory` is not configurable: the minimum of `crate.heapSize * 2` is inferred.

## More info

You can read more about CrateDB in:

- [Official Docs](https://crate.io/docs/)
- [Docker Hub](https://hub.docker.com/_/crate/)
