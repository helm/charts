# Magic Namespace

**Magic Namespace** provides an easy, comprehensive option for cluster operators
to manage namespaces and observe good security practices in _multi-tenant,
RBAC-enabled_ Kubernetes clusters.

## Introduction

So you've got a multi-tenant cluster? Let's assume your cluster is RBAC-enabled.
If it isn't, _go fix that first_. You're playing with fire. Until you fix that,
you don't need Magic Namespace. Go fix it. We'll wait...

In a multi-tenant cluster, a cluster operator (someone with full, unrestricted
privileges across the entire cluster), will manage users, groups, service
accounts, roles, and user/group bindings to roles-- all to either permit or
prevent subjects from performing certain actions in different namespaces.

A common paradigm that has emerged is that _teams_ are given their own namespace
and some degree of latitude to administer that namespace, whilst not being
permitted to perform actions on _other teams'_ namespaces.

Now bring Helm/Tiller into the equation. In an RBAC-enabled cluster, Tiller is
so often granted the `cluster-admin` role-- which gives it "root" access to the
entire cluster. While such a Tiller may be suitable for use by a cluster
operator, it's _not_ suitable for use by other teams, as it presents them with
an easy avenue for escalating their privileges.

To compensate for this, a pattern that has emmerged to complement the
namespace-per-team pattern is the _tiller-per-namespace_ pattern. This has been
widely adopted in multi-tenant, RBAC-enabled clusters. Until now, cluster
operators have tended to create their own bespoke scripts for performing all
requisite setup to implement these patterns.

Magic Namespace takes the pain out of this setup. It offers cluster operators an
easy, comprehensive avenue for using _their_ Tiller to manage namespaces,
service accounts, _other Tillers_, and role bindings for their consituent
teams. Magic Namespace permits cluster operators to manage all of this using
familiar Helm-based workflows.

## How it Works

By default, Magic Namespace creates a service account for Tiller in the
designated namespace and binds it to the `admin` role for that namespace. It
also creates a deployment that utilizes this service account. This can be
disabled or configured further, but the default behavior is sensible. In fact,
the defaults _closes_ a variety of known Tiller-based attack vectors.

Magic Namespace also offers cluster operators to define additional service
accounts and role bindings for use within the namespace. _Typically, it would
be a good idea to define at least one role binding that grants a user or group
administrative privileges in the namespace._ Absent this, the namespace's own
Tiller will function, but no user (other than the cluster operator) will be
capable of interacting with it via Helm.

## Prerequisites

- A Kubernetes cluster with RBAC enabled

## Installing the Chart

To install the chart to create the `foo` namespace (if it doesn't already exist)
and useful resources (Tiller, service accounts, etc.) within that namespace:

```bash
$ helm install stable/magic-namespace --name foo --namespace foo
```

Typically, you will want to bind at least one user or group to the `admin` role
in this namespace. Here are steps to follow:

First, make a copy of the default `values.yaml`:

```bash
$ helm inspect values stable/magic-namespace > ~/my-values.yaml
```

Edit `~/my-values.yaml` accordingly. Here is a sample role binding:

```
...

roleBindings:
- name: admin-group-admin
  role:
    ## Valid values are "Role" or "ClusterRole"
    kind: ClusterRole
    name: admin
  subject:
    ## Valid values are "User", "Group", or "ServiceAccount"
    kind: Group
    name: <group>

...
```

Deploy as follows:

```bash
$ helm install stable/magic-namespace \
  --name foo \
  --namespace foo \
  --values ~/my-values.yaml
```

## Uninstalling the Chart

Deleting a release of a Magic Namespace will _not_ delete the namespace,
unless you have used the optional ```namespace``` setting. It will
only delete the Tiller, service accounts, role bindings, etc. from that
namespace. This is actually desirable behavior, as anything the team has
deployed within that namespace is likely to be unaffected, though further
deployments to and management of that namespace will not be possible by anyone
other than the cluster operator.

If you have used the ```namespace``` setting, deleting the release will cleanup
all releases deployed with the tiller in the Magic Namespace, along with the
namespace.  If other tillers, such as the one in ```kube-system``` have
deployed charts into the Magic Namespace, they will get orphaned when the namespace is
removed, but they can still be removed with the standard ```helm delete <name> --purge``` command.

```bash
$ helm delete foo --purge
```

## Configuration

The following table lists the most common, useful, and interesting configuration
parameters of the Magic Namespace chart and their default values. Please
reference the default `values.yaml` to understand further options.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tiller.enabled` | Whether to include a Tiller in the namespace | `true` |
| `tiller.replicaCount` | The number of Tiller replicas to run | `1` |
| `tiller.image.repository` | The Docker image to use for Tiller, minus version/label | `gcr.io/kubernetes-helm/tiller` |
| `tiller.image.tag` | The specific version/label of the Docker image used for Tiller | `v2.8.1` |
| `tiller.image.pullPolicy` | The pull policy to utilize when pulling Tiller images from a Docker repsoitory | `IfNotPresent` |
| `tiller.maxHistory` | The maximum number of releases Tiller should remember. A value of `0` is interpreted as no limit. | `0` |
| `tiller.role.type` | Identify the kind of role (`Role` or `ClusterRole`) that will be referenced in the role binding for Tiller's service account. There is seldom any reason to override this. | `ClusterRole` |
| `tiller.role.type` | Identify the name of the `Role` or `ClusterRole` that will be referenced in the role binding for Tiller's service account. There is seldom any reason to override this. | `admin` |
| `tiller.includeService` | This deploys a service resource for Tiller. This is not generally needed. Please understand the security implications of this before overriding the default. | `false` |
| `tiller.onlyListenOnLocalhost` | This prevents Tiller from binding to `0.0.0.0`. This is generally advisable to close known Tiller-based attack vectors. Please understand the security implications of this before overriding the default. | `true` |
| `tiller.storage` | The storage driver for Tiller to use. One of `configmap`, `memory`, or `secret` | `configmap` |
| `tiller.tls.enabled` | Whether to enable TLS encryption between Helm and Tiller. Specify either `tiller.tls.secretName` to mount an existing secret, or `tiller.tls.ca`, `tiller.tls.cert` and `tiller.tls.key` to create a secret from Base64 provided values | `false` |
| `tiller.tls.verify` | Whether to verify a remote Tiller certificate. | `true` |
| `tiller.tls.secretName` | Mount an existing TLS secret into the Tiller container. The secret must include data keys: `ca.crt`, `tls.crt` and `tls.key` | `nil` |
| `tiller.tls.ca` | Base64 encoded string to mount ca.crt into the Tiller container. This value requires `tiller.tls.cert` and `tiller.tls.key` to also be set. | `nil` |
| `tiller.tls.cert` | Base64 encoded string to mount tls.cert into the Tiller container. This value requires `tiller.tls.ca and `tiller.tls.key` to also be set. | `nil` |
| `tiller.tls.key` | Base64 encoded string to mount tls.key into the Tiller container. This value requires `tiller.tls.ca` and `tiller.tls.cert` to also be set. | `nil` |
| `serviceAccounts` | An optional array of names of additional service account to create | `nil` |
| `roleBindings` | An optional array of objects that define role bindings | `nil` |
| `roleBindings[n].role.kind` | Identify the kind of role (`Role` or `ClusterRole`) to be used in the role binding | |
| `roleBindings[n].role.name` | Identify the name of the role to be used in the role binding | |
| `roleBindings[n].subject.kind` | Identify the kind of subject (`User`, `Group`, or `ServiceAccount` ) to be used in the role binding | |
| `roleBindings[n].subject.name` | Identify the name of the subject to be used in the role binding | |
| `namespace` | Specify a namespace to be created and used, overriding the one on the command line | |
| `namespaceAttributes.annotations` | Specify annotations to be attached to the namespace | |
| `namespaceAttributes.lables` | Specify labels to be attached to the namespace | |
