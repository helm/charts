# secrets

This chart is used to apply secrets. You can specify any number of secrets and any number of values inside a secret. This chart can come in handy when a public chart does not offer additional secrets. You have to use the following format to specify secrets:

```bash
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
| data          | data contains the list of key, pair values for secret values                                                      | `clientid: testid`                        | `clientid: testid`                        |
| type          | type of the secret                                                      | `Opaque`                        | `Opaque`                        |