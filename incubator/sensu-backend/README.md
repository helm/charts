# Helm Chart for Installing Sensu 2 Backend

[Sensu](https://sensu.io) is the open source monitoring event pipeline built to reduce operator burden and make developers and business owners happy. Started in 2011, Sensu’s flexible approach solves the challenges of monitoring hybrid-cloud and containerized infrastructures with scalable, automated workflows and integrations with tools you already use.

[Sensu 2.0](https://docs.sensu.io/sensu-core/2.0/) is a new platform, written in Go and designed from the ground up to be more portable, easier and faster to deploy, and (even more) friendly to containerized and ephemeral environments. But above all, it was designed to support the features and functionality you’ve come to know and love about Sensu.

## Introduction

This chart installs the Sensu 2 Backend.

## Prerequisites

- Kubernetes 1.10+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release .
```

The command deploys a Sensu 2.0 Backend server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Percona chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `image.repository`         | Sensu 2.0 image Repo.                 | `sensu/sensu`                                        |
| `image.tag`                 | Sensu 2.0 image tag.                 | `2.0.0-beta.3` |
| `image.pullPolicy`          | Image pull policy                  | `IfNotPresent` |
| `persistence.enabled`      | Create a volume to store data      | false                                                       |
| `persistence.size`         | Size of persistent volume claim    | 8Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |

see `values.yaml` for a full list of Parameters and default settings.

## Persistence

By default, an emptyDir volume is mounted at /var/lib/sensu location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

You can change the values.yaml to enable persistence and use a PersistentVolumeClaim instead.

## Demonstration

Deploy Sensu 2.0 Backend:

```bash
$ helm install -n example .
NAME:   example
LAST DEPLOYED: Thu Aug 23 14:10:48 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                          DATA  AGE
example-sensu-backend-config  2     1s

==> v1/Service
NAME                             TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)   AGE
example-sensu-backend-api        ClusterIP  10.100.200.165  <none>       8080/TCP  1s
example-sensu-backend-dashboard  ClusterIP  10.100.200.74   <none>       3000/TCP  1s
example-sensu-backend-ws         ClusterIP  10.100.200.64   <none>       8081/TCP  1s

==> v1/Deployment
NAME                   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
example-sensu-backend  1        1        1           0          1s

==> v1/Pod(related)
NAME                                    READY  STATUS             RESTARTS  AGE
example-sensu-backend-68cc64ff47-mcsv6  0/2    ContainerCreating  0         1s


NOTES:
1. Get the application URL by running these commands:
  kubectl port-forward svc/test-sensu-backend-dashboard 3000:3000
  or
  kubectl port-forward svc/test-sensu-backend-api 8080:8080
```

Port forward for the API and configure `sensuctl`:

```bash
$ kubectl port-forward svc/example-sensu-backend-dashboard 3000:3000 &
$ kubectl port-forward svc/example-sensu-backend-api 8080:8080 &
$ sensuctl configure
? Sensu Backend URL: http://127.0.0.1:8080
? Username: admin
? Password: P@ssw0rd!
? Organization: default
? Environment: default
? Preferred output format: tabular
$ sensuctl  entity list
                    ID                     Class    OS                     Subscriptions                             Last Seen
 ──────────────────────────────────────── ─────── ─────── ─────────────────────────────────────────────── ───────────────────────────────
  example-sensu-backend-68cc64ff47-mcsv6   agent   linux   entity:example-sensu-backend-68cc64ff47-mcsv6   2018-08-23 14:16:31 -0500 CDT
```

Access Sensu Dashboard via your favorite browser:  http://127.0.0.1:3000.  You'll see the basic sensu dashboard and one entity should be visible, the backend server itself.