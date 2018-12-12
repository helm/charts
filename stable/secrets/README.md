# secrets

This chart is used to apply secrets. You can specify any number of secrets and any number of values inside a secret. This chart can come in handy when a public chart does not offer additional secrets. You have to use the following format to specify secrets:

```yaml
- name: someName
      values:
        - key: hello
          value: world
        - key: key2
          value: value2
      type: someType
- name: secret2
      values:
        - key: someKey
          value: someValue
```

For installing the chart, run the following command:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/secrets -f values.yaml --namespace <namespace-name> --name <name>
```

## Usage

The following quickstart let's you set up secret:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| name          | name of the secret                                                      | `test`                        | `test`                        |
| data          | data contains the list of key value pairs. Values are base64 encrypted.                                                       | `clientid: testid`                        | `clientid: testid`                        |
| type          | type of the secret                                                      | `Opaque`                        | `Opaque`                        |
| labels          | label for secrets                                                      | `app: app-name`                        | `app: app-name`                        |

## Example

Secrets chart is used to create secrets for other charts which does not support creation of additional secrets.
For example, we need additional secret for database credentials being used in [keycloak](https://github.com/helm/charts/tree/master/stable/keycloak) chart but there is no support for creation of additional secrets. Below are the steps, that explain how to achieve this using secrets chart.

- Update the `values.yaml` file to create a secret.

```yaml
Secrets:
  - name: keycloak-secrets
    labels:
      app: keycloak
    data:
        db.user: testuser
        db.password: testpassword
    type: Opaque
```

- Deploy the secrets chart. This will create a secret with name `keycloak-secrets` containing your database credentials.
- Now, to use this secret in keycloak, update the [values.yaml](https://github.com/helm/charts/blob/master/stable/keycloak/values.yaml) with following values

```yaml
existingSecret: "keycloak-secrets"
existingSecretKey: db.password
```

- Deploy the [keycloak](https://github.com/helm/charts/tree/master/stable/keycloak) chart and we can see that keycloak is using database credentials from our secret.