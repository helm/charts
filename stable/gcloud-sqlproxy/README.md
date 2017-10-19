# GCP SQL Proxy

[sql-proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy) The Cloud SQL Proxy provides secure access to your Cloud SQL Postgres/MySQL instances without having to whitelist IP addresses or configure SSL.

Accessing your Cloud SQL instance using the Cloud SQL Proxy offers these advantages:

* Secure connections: The proxy automatically encrypts traffic to and from the database; SSL certificates are used to verify client and server identities.
* Easier connection management: The proxy handles authentication with Google Cloud SQL, removing the need to provide static IP addresses of your GKE/GCE Kubernetes nodes.

## Introduction

This chart creates a Google Cloud Endpoints deployment and service on a Kubernetes cluster using the Helm package manager.
You need to enable Cloud SQL Administration API and create a service account for the proxy as per these [instructions](https://cloud.google.com/sql/docs/postgres/connect-container-engine).

## Prerequisites

- Kubernetes cluster on Google Container Engine (GKE)
- Kubernetes cluster on Google Compute Engine (GCE)
- Cloud SQL Administration API enabled
- GCP Service account for the proxy.

## Installing the Chart

Install from remote URL with the release name `pg-sqlproxy` into namespace `sqlproxy`, set GCP service account and SQL instance and port:

```console
$ helm upgrade pg-sqlproxy stable/gcloud-sqlproxy --namespace sqlproxy \
  --set serviceAccountKey="$(cat service-account.json | base64)",cloudsql.instance="PROJECT:REGION:INSTANCE",cloudsql.port="5432" -i
```

Replace Postgres/MySQL host with: if access is from the same namespace with `pg-sqlproxy-gcloud-sqlproxy` or if it is from a different namespace with `pg-sqlproxy-gcloud-sqlproxy.sqlproxy`, the rest database connections settings do not have to be changed.

> **Tip**: List all releases using `helm list`
> **Tip**: If you encounter a YAML parse error on on `gcloud-sqlproxy/templates/secrets.yaml`, you might need to set `-w 0` option to `base64` command.
> **Tip**: If you are using a MySQL instance, you may want to replace `pg-sqlproxy` with `mysql-sqlproxy` and `5432` with `3306`.

## Uninstalling the Chart

To uninstall/delete the `my-release-name` deployment:

```console
$ helm delete my-release-name
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Drupal chart and their default values.

| Parameter                         | Description                            | Default                                                   |
| --------------------------------- | -------------------------------------- | --------------------------------------------------------- |
| `image`                           | SQLProxy image                         | `b.gcr.io/cloudsql-docker/gce-proxy`                      |
| `imageTag`                        | SQLProxy image tag                     | `1.09`                                                    |
| `imagePullPolicy`                 | Image pull policy                      | `IfNotPresent`                                            |
| `replicasCount`                   | Replicas count                         | `1`                                                       |
| `serviceAccountKey`               | Service account key JSON file          | Must be provided and base64 encoded                       |
| `cloudsql.instance`               | PostgreSQL/MySQL instance name         | `project:region:instance` must be provided                |
| `cloudsql.port`                   | PostgreSQL/MySQL instance port         | `5432`                                                    |
| `resources`                       | CPU/Memory resource requests/limits    | Memory: `100/150Mi`, CPU: `100/150m`                      |
| `nodeSelector`                    | Node Selector                          |                                                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/gcloud-sqlproxy
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Documentation

- [Cloud SQL Proxy for Postgres](https://cloud.google.com/sql/docs/postgres/sql-proxy)
- [Cloud SQL Proxy for MySQL](https://cloud.google.com/sql/docs/mysql/sql-proxy)
- [GKE samples](https://github.com/GoogleCloudPlatform/container-engine-samples/tree/master/cloudsql)
