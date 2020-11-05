# incubator/raw

The `incubator/raw` chart takes a list of Kubernetes resources and
merges each resource with a default `metadata.labels` map and installs
the result.

The Kubernetes resources can be "raw" ones defined under the `resources` key, or "templated" ones defined under the `templates` key.

Some use cases for this chart include Helm-based installation and
maintenance of resources of kinds:
- LimitRange
- PriorityClass
- Secret

## Usage

### Raw resources

#### STEP 1: Create a yaml file containing your raw resources.

```
# raw-priority-classes.yaml

resources:

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: common-critical
    value: 100000000
    globalDefault: false
    description: "This priority class should only be used for critical priority common pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: common-high
    value: 90000000
    globalDefault: false
    description: "This priority class should only be used for high priority common pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: common-medium
    value: 80000000
    globalDefault: false
    description: "This priority class should only be used for medium priority common pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: common-low
    value: 70000000
    globalDefault: false
    description: "This priority class should only be used for low priority common pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: app-critical
    value: 100000
    globalDefault: false
    description: "This priority class should only be used for critical priority app pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: app-high
    value: 90000
    globalDefault: false
    description: "This priority class should only be used for high priority app pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: app-medium
    value: 80000
    globalDefault: true
    description: "This priority class should only be used for medium priority app pods."

  - apiVersion: scheduling.k8s.io/v1beta1
    kind: PriorityClass
    metadata:
      name: app-low
    value: 70000
    globalDefault: false
    description: "This priority class should only be used for low priority app pods."
```

#### STEP 2: Install your raw resources.

```
helm install --name raw-priority-classes incubator/raw -f raw-priority-classes.yaml
```

### Templated resources

#### STEP 1: Create a yaml file containing your templated resources.

```
# values.yaml

templates:
- |
  apiVersion: v1
  kind: Secret
  metadata:
    name: common-secret
  stringData:
    mykey: {{ .Values.mysecret }}
```

The yaml file containing `mysecret` should be encrypted with a tool like [helm-secrets](https://github.com/futuresimple/helm-secrets)

```
# secrets.yaml
mysecret: abc123
```

```
$ helm secrets enc secrets.yaml
```

#### STEP 2: Install your templated resources.

```
helm secrets install --name mysecret incubator/raw -f values.yaml -f secrets.yaml
```
