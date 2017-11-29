Crunchy Data Statefulset Helm Example
=======

[PostgreSQL](https://postgresql.org) is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness.


TL;DR;
------

```console
$ helm install basic --name basic
```

Introduction
------------

This is an example of running the Crunchy PostgreSQL containers using the Helm project! More examples of the Crunchy Containers for PostgreSQL can be found at the [GitHub repository](https://github.com/CrunchyData/crunchy-containers).

This example deploys a statefulset named *pgset*.  The statefulset
is a new feature in Kubernetes as of version 1.5.  Statefulsets have
replaced PetSets going forward.

This example creates 2 PostgreSQL containers to form the set.  At
startup, each container will examine its hostname to determine
if it is the first container within the set of containers.

The first container is determined by the hostname suffix assigned
by Kube to the pod.  This is an ordinal value starting with *0*.

If a container sees that it has an ordinal value of *0*, it will
update the container labels to add a new label of:

```console
name=$PG_PRIMARY_HOST
```

In this example, PG_PRIMARY_HOST is specified as *pgset-primary*.

By default, the containers specify a value of *name=pgset-replica*

There are 2 services that end user applications will use to
access the PostgreSQL cluster, one service (pgset-primary) routes to the primary
container and the other (pgset-replica) to the replica containers.

```console
$ kubectl get service
NAME            CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes      10.96.0.1       <none>        443/TCP    22h
pgset           None            <none>        5432/TCP   1h
pgset-primary    10.97.168.138   <none>        5432/TCP   1h
pgset-replica   10.97.218.221   <none>        5432/TCP   1h
```

Installing the Chart
--------------------

The chart can be installed as follows:

```console
$ helm install statefulset --name statefulset
```

The command deploys both primary and replica pods on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

Using the Chart
----------------------

You can access the primary database as follows:

```console
$ psql -h pgset-primary -U postgres postgres
```

You can access the replica databases as follows:

```console
$ psql -h pgset-replica -U postgres postgres
```

You can scale the number of containers using this command, this will
essentially create an additional replica database:

```console
$ kubectl scale statefulset pgset-primary --replicas=3
```

Uninstalling the Chart
----------------------

To uninstall/delete the `statefulset` deployment:

```console
$ helm del --purge statefulset
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Configuration
-------------

See `values.yaml` for configuration notes. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install basic --name basic \
  --set Image.tag=centos7-10.0-1.6.0
```

The above command changes the image tag of the container from the default of `centos7-9.6.5-1.6.0` to `centos7-10.0-1.6.0`.

> **Tip**: You can use the default [values.yaml](values.yaml)

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `Name`                 | Name of release.                 | `pgset`                                        |
| `.container.port`        | The port used for the primary container      | `5432`                                                      |
| `.container.name.primary`        | Name for the primary container      | `pgset-primary`                                                      |
| `.container.name.replica`        | Name for the replica container      | `pgset-replica`                                                      |
| `.container.serviceAccount`        | Name for the service account to be used      | `pgset-sa`                                                      |
| `.credentials.primary`                | Password for the primary user    | `password`                                                      |
| `.credentials.root`            | Password for the root user        | `password`                                                      |
| `.credentials.user`            | Password for the standard user   | `password`                                                      |
| `.serviceType`      | The type of service      | `ClusterIP`               
| `.image.repository` | The repository on DockerHub where the images are found.    | `crunchydata`                                           |
| `.image.container` | The container to be pulled from the repository.    | `crunchy-postgres`                                                    |
| `.image.tag` | The image tag to be used.    | `centos7-9.6.5-1.6.0`                                                    |
| `.pv.storage` | Size of persistent volume     | 400M                                                    |
| `.pv.name` | Name of persistent volume    | `pgset-pv`                                                    |
| `.pvc.name` | Name of persistent volume    | `pgset-pvc`                                                    |
| `.resources.cpu` | Defines a limit for CPU    | `200m`                                                    |
| `.resources.memory` | Defines a limit for memory    | `512Mi`                                                    |

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install statefulset --name statefulset  \
  -f values.yaml
```

Legal Notices
-------------

Copyright © 2017 Crunchy Data Solutions, Inc.

CRUNCHY DATA SOLUTIONS, INC. PROVIDES THIS GUIDE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF NON INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.

Crunchy, Crunchy Data Solutions, Inc. and the Crunchy Hippo Logo are trademarks of Crunchy Data Solutions, Inc.
