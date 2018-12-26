# rbac

This chart is used to apply rbac. This chart can come in handy when a public chart does not offer additional rbac. 

## Installing

For installing the chart, run the following commands:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/rbac -f values.yaml --namespace <namespace-name>
```

## Usage

The following quickstart let's you set up rbac chart:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| appName          | name of the application. Used in labels                                                     | `rbac`                                             | `rbac`                    |
| clusterRole.enabled          | Enable clusterRole                                          | `true`                                          | `false`                                 |
| clusterRole.name    | Name of clusterRole                                                 | `testClusterRole"`                | `testClusterRole`                        |
| clusterRole.labels        | label for clusterRole                                                         | `app: app-name`                         | `{}`                                        |
| clusterRole.rules        | rules for clusterRole                                                         | ``                         | ``                                        |
| clusterRoleBinding.enabled          | Enable clusterRoleBinding                                          | `true`                                          | `false`                                 |
| clusterRoleBinding.name    | Name of clusterRoleBinding                                                 | `testClusterRoleBinding`                | `testClusterRoleBinding`                        |
| clusterRoleBinding.labels        | label for clusterRoleBinding                                                         | `app: app-name`                         | `{}`                                        |
| clusterRoleBinding.clusterRoleName        | clusterRole name for clusterRoleBinding                                                        | `testClusterRole`                         | `testClusterRole`                                        |
| clusterRoleBinding.serviceAccountName        | serviceAccount name for clusterRoleBinding                                                         | `cluster-admin`                         | ``                                        |
| role.enabled          | Enable role                                          | `true`                                          | `true`                                 |
| role.name    | Name of role                                                 | `testRole"`                | `testRole`                        |
| role.labels        | label for role                                                         | `app: app-name`                         | `{}`                                        |
| role.rules        | rules for role                                                         | ``                         | ``                                        |
| roleBinding.enabled          | Enable roleBinding                                          | `true`                                          | `true`                                 |
| roleBinding.name    | Name of roleBinding                                                 | `testRoleBinding`                | `testRoleBinding`                        |
| roleBinding.labels        | label for roleBinding                                                         | `app: app-name`                         | `{}`                                        |
| roleBinding.roleName        | role name for roleBinding                                                        | `testRole`                         | `testRole`                                        |
| roleBinding.serviceAccountName        | serviceAccount name for roleBinding                                                         | `testAccount`                         | ``                                        |
| serviceAccount.create          | Option to create serviceAccount                                               | `true`                        | `true`                        |
| serviceAccount.name          | Name of serviceAccount                                               | `testAccount`                        | `testAccount`                        |
