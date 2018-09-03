## PostgREST

[PostgREST](https://postgrest.org/) is a standalone web server that turns your
PostgreSQL database directly into a RESTful API. The structural constraints and
permissions in the database determine the API endpoints and operations.

Using PostgREST is an alternative to manual CRUD programming. Custom API
servers suffer problems. Writing business logic often duplicates, ignores or
hobbles database structure. Object-relational mapping is a leaky abstraction
leading to slow imperative code. The PostgREST philosophy establishes a single
declarative source of truth: the data itself.

## TL;DR;

```bash
$ helm install incubator/postgrest
```

## Introduction

This chart bootstraps PostgREST using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/postgrest
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

### General Configuration Parameters

The following table lists the configurable parameters of PostgREST and their
default values. A complete description of the paremeters is available in the
[documentation](https://postgrest.org/en/stable/install.html#configuration).

| Parameter              | Description                                                   | Default                                     |
| ----------             | -------------------                                           | -------------------                         |
| image.repository       | PostgREST image                                               | `postgrest/postgrest`                       |
| image.tag              | PostgREST image version                                       | `v0.5.1`                                    |
| image.pullPolicy       | Image pull policy                                             | `IfNotPresent`                              |
| replicaCount           | PostgREST instance count                                      | `1`                                         |
| service                | PostgREST and service port                                    | 3000                                        |
| pgrst_db_uri           | standard connection PostgreSQL URI format                     | "postgres://postgres@postgres-svc/postgres" |
| pgrst_db_schema        | database schema                                               | "postgres"                                  |
| pgrst_db_anon_role     | database role to use when executing commands                  | "postgres"                                  |
| pgrst_db_pool          | number of connections to keep open                            |                                             |
| pgrst_server_host      | where to bind thw web server                                  |                                             |
| pgrst_server_proxy_uri | URL used within the OpenAPI self-documentation                |                                             |
| pgrst_jwt_secret       | JSON Web Key (JWK) used to decode                             |                                             |
| pgrst_secret_is_base64 | the value derived from jwt-secret will be treated as a base64 |                                             |
| pgrst_jwt_aud          | JWT audience claim                                            |                                             |
| pgrst_max_rows         | hard limit to the number of rows                              |                                             |
| pgrst_pre_request      | procedure to call right after switching roles                 |                                             |
| pgrst_role_claim_key   | JSPath DSL that specifies the location of the role            |                                             |
