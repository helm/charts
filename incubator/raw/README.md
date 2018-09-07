# incubator/raw

The `incubator/raw` chart takes a list of raw Kubernetes resources and
merges each resource with a default `metadata.labels` map and installs
the result.

Some use cases for this chart include Helm-based installation and
maintenance of resources of kinds:
- LimitRange
- PriorityClass

## Usage

### STEP 1: Create a yaml file containing your raw resources.

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

### STEP 2: Install your raw resources.

```
helm install --name raw-priority-classes incubator/raw -f raw-priority-classes.yaml
```
