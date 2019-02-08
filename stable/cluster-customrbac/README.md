# Kubernetes Custom RBAC Chart

Helm chart to manage custom
[RBAC permissions](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
of a Kubernetes cluster.

## TL;DR;

Create `<your_config_file.yaml>` based on `values.yaml`.
For example:

```yaml
customrbac:
  rolebindings:
  - rolekind: clusterrole
    rolename: cluster-admin
    bindings:
    - namespace: kube-system
      subjects:
        users:
        - elon.musk@example.com
        - neo@example.com
```

then run:

```bash
$ helm install stable/cluster-customrbac -f <your_config_file.yaml>
```

## Chart Details
This chart allows to manage custom [RBAC permissions](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
of a Kubernetes cluster in a simplified manner.
Through the use of standard-format Helm configuration files, one can define custom RBAC permissions that
will be created in the cluster.

Advantages in using the chart:
- Streamlined RBAC configuration through a simplified YAML format
- Definition of all `roles`, `rolebindings`, `clusterroles` and `clusterrolebindings` using a single configuration file or one file per type of entity, instead of having to create one Kubernetes YAML file for **each** instance of **each** entity (which can lead to dozens or hundreds of files).
- Greatly simplified way to modify RBAC permissions through use of HELM (e.g., removal of existing RBAC permissions by simply removing entries in the configuration file and re-deploying the chart)

## Prerequisites

- RBAC must be enabled in your Kubernetes cluster.
- You must create an RBAC configuration file to feed into the chart

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/cluster-customrbac -f <your_config_file.yaml>
```

The command deploys the RBAC permissions as specified in `<your_config_file.yaml>`.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes the Kubernetes RBAC entities that were created by the deployment.

If you so wish, you can manage different sets of RBAC permissions through different configurations and releases of this same chart.

## Configuration

Configuration should be specified from within one or more YAML files and fed into the chart using the -f flag.
Please see the `values.yaml` file for how to setup your own configuration file.
You can choose to split the configuration into multiple YAML files; for example, you could choose to use
one file for `rolebindings` definitions, and a different one for `roles` definitions. Basically, each of the
four types of configuration could be in its own file (`roles`, `rolebindings`, `clusterroles` and `clusterrolebindings`).
However, all the configuration of a single of the four types must be in the same configuration file; this is because
HELM does not allow to separate the elements of an array into different files.

For more information please refer to the Kubernetes documentation for
[RBAC permissions.](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

