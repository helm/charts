# Chart Review Guidelines

Anyone is welcome to review pull requests. Besides our [technical requirements](https://github.com/helm/charts/blob/master/CONTRIBUTING.md#technical-requirements) and [best practices](https://github.com/helm/helm/tree/master/docs/chart_best_practices), here's an overview of process and review guidelines.

## Process

The process to get a pull request merged is fairly simple. First, all required tests need to pass and the contributor needs to have a signed [DCO](https://www.helm.sh/blog/helm-dco/index.html). See [Charts Testing](https://github.com/helm/charts/blob/master/test/README.md) for details on our CI system and how you can provide custom values for testing. If there is a problem with some part of the test, such as a timeout issue, please contact one of the charts repository maintainers by commenting `cc @helm/charts-maintainers`.

The charts repository uses the OWNERS files to provide merge access. If a chart has an OWNERS file, an approver listed in that file can approve the pull request. If the chart does not have an OWNERS file, an approver in the OWNERS file at the root of the repository can approve the pull request.

To approve the pull request, an approver needs to leave a comment of `/lgtm` on the pull request. Once this is in place some tags (`lgtm` and `approved`) will be added to the pull request and a bot will come along and perform the merge.

Note, if a reviewer who is not an approver in an OWNERS file leaves a comment of `/lgtm` a `lgtm` label will be added but a merge will not happen.

## Immutability

Chart releases must be immutable. Any change to a chart warrants a chart version bump even if it is only changed to the documentation.

## Versioning

The chart `version` should follow [semver](https://semver.org/).

Stable charts should start at `1.0.0` (for maintainability don't create new PRs for stable charts only to meet these criteria, but when reviewing PRs take the opportunity to ensure that this is met).

Any breaking (backwards incompatible) changes to a chart should:

1. Bump the MAJOR version
2. In the README, under a section called "Upgrading", describe the manual steps necessary to upgrade to the new (specified) MAJOR version

## Chart Metadata

The `Chart.yaml` should be as complete as possible. The following fields are mandatory:

* name (same as chart's directory)
* home
* version
* appVersion
* description
* maintainers (name should be Github username)

## Dependencies

Stable charts should not depend on charts in the incubator.

## Names and Labels

### Metadata
Resources and labels should follow some conventions. The standard resource metadata (`metadata.labels` and `spec.template.metadata.labels`) should be this:

```yaml
name: {{ include "myapp.fullname" . }}
labels:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/managed-by: {{ .Release.Service }}
  helm.sh/chart: {{ include "myapp.chart" . }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added (e. g. `app.kubernetes.io/component: server`). The resource name should get the component as suffix (e. g. `name: {{ include "myapp.fullname" . }}-server`).

Note that templates have to be namespaced. With Helm 2.7+, `helm create` does this out-of-the-box. The `app.kubernetes.io/name` label should use the `name` template, not `fullname` as is still the case with older charts.

### Deployments, StatefulSets, DaemonSets Selectors

`spec.selector.matchLabels` must be specified should follow some conventions. The standard selector should be this:

```yaml
selector:
  matchLabels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `component` label should be added to the selector (see above).

`spec.selector.matchLabels` defined in `Deployments`/`StatefulSets`/`DaemonSets` `>=v1/beta2` **must not** contain `helm.sh/chart` label or any label containing a version of the chart, because the selector is immutable.
The chart label string contains the version, so if it is specified, whenever the Chart.yaml version changes, Helm's attempt to change this immutable field would cause the upgrade to fail.

#### Fixing Selectors

##### For Deployments, StatefulSets, DaemonSets apps/v1beta1 or extensions/v1beta1

- If it does not specify `spec.selector.matchLabels`, set it
- Remove `helm.sh/chart` label in `spec.selector.matchLabels` if it exists
- Bump patch version of the Chart

##### For Deployments, StatefulSets, DaemonSets >=apps/v1beta2

- Remove `helm.sh/chart` label in `spec.selector.matchLabels` if it exists
- Bump major version of the Chart as it is a breaking change

### Service Selectors

Label selectors for services must have both `app.kubernetes.io/name` and `app.kubernetes.io/instance` labels.

```yaml
selector:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added to the selector (see above).

### Persistence Labels

### StatefulSet

In case of a `Statefulset`, `spec.volumeClaimTemplates.metadata.labels` must have both `app.kubernetes.io/name` and `app.kubernetes.io/instance` labels, and **must not** contain `helm.sh/chart` label or any label containing a version of the chart, because `spec.volumeClaimTemplates` is immutable.

```yaml
labels:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added to the selector (see above).

### PersistentVolumeClaim

In case of a `PersistentVolumeClaim`, unless special needs, `matchLabels` should not be specified
because it would prevent automatic `PersistentVolume` provisioning.

## Formatting

* Yaml file should be indented with two spaces.
* List indentation style should be consistent.
* There should be a single space after `{{` and before `}}`.

## Configuration

* Docker images should be configurable. Image tags should use stable versions.

```yaml
image:
  repository: myapp
  tag: 1.2.3
  pullPolicy: IfNotPresent
```

* The use of the `default` function should be avoided if possible in favor of defaults in `values.yaml`.
* It is usually best to not specify defaults for resources and to just provide sensible values that are commented out as a recommendation, especially when resources are rather high. This makes it easier to test charts on small clusters or Minikube. Setting resources should generally be a conscious choice of the user.

## Persistence

* Persistence should be enabled by default
* PVCs should support specifying an existing claim
* Storage class should be empty by default so that the default storage class is used
* All options should be shown in README.md
* Example persistence section in values.yaml:

```yaml
persistence:
  enabled: true
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  storageClass: ""
  accessMode: ReadWriteOnce
  size: 10Gi
  # existingClaim: ""
```

* Example pod spec within a deployment:

```yaml
volumes:
  - name: data
  {{- if .Values.persistence.enabled }}
    persistentVolumeClaim:
      claimName: {{ .Values.persistence.existingClaim | default (include "myapp.fullname" .) }}
  {{- else }}
    emptyDir: {}
  {{- end -}}
```

* Example pvc.yaml:

```yaml
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
spec:
  accessModes:
    - {{ .Values.persistence.accessMode | quote }}
  resources:
    requests:
      storage: {{ .Values.persistence.size | quote }}
{{- if .Values.persistence.storageClass }}
{{- if (eq "-" .Values.persistence.storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .Values.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}
```

## AutoScaling / HorizontalPodAutoscaler

* Autoscaling should be disabled by default
* All options should be shown in README.md

* Example autoscaling section in values.yaml:

```yaml
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
  targetMemoryUtilizationPercentage: 50
```

* Example hpa.yaml:

```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
    app.kubernetes.io/component: "{{ .Values.name }}"
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "myapp.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
{{- end }}
```

## Ingress

* See the [Ingress resource documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/) for a broader concept overview
* Ingress should be disabled by default
* Example ingress section in values.yaml:

```yaml
ingress:
  enabled: false
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  path: /
  hosts:
    - chart-example.test
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.test
```

* Example ingress.yaml:

```yaml
{{- if .Values.ingress.enabled -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ include "myapp.fullname" }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
{{- with .Values.ingress.annotations }}
  annotations:
{{ toYaml . | indent 4 }}
{{- end }}
spec:
{{- if .Values.ingress.tls }}
  tls:
  {{- range .Values.ingress.tls }}
    - hosts:
      {{- range .hosts }}
        - {{ . | quote }}
      {{- end }}
      secretName: {{ .secretName }}
  {{- end }}
{{- end }}
  rules:
  {{- range .Values.ingress.hosts }}
    - host: {{ . | quote }}
      http:
        paths:
          - path: {{ .Values.ingress.path }}
            backend:
              serviceName: {{ include "myapp.fullname" }}
              servicePort: http
  {{- end }}
{{- end }}
```

* Example prepend logic for getting an application URL in NOTES.txt:

```
{{- if .Values.ingress.enabled }}
{{- range .Values.ingress.hosts }}
  http{{ if $.Values.ingress.tls }}s{{ end }}://{{ . }}{{ $.Values.ingress.path }}
{{- end }}
```

## Documentation

`README.md` and `NOTES.txt` are mandatory. `README.md` should contain a table listing all configuration options. `NOTES.txt` should provide accurate and useful information on how the chart can be used/accessed.

## Compatibility

We officially support compatibility with the current and the previous minor version of Kubernetes. Generated resources should use the latest possible API versions compatible with these versions. For extended backwards compatibility, conditional logic based on capabilities may be used (see [built-in objects](https://github.com/helm/helm/blob/master/docs/chart_template_guide/builtin_objects.md)).

## Kubernetes Native Workloads

While reviewing Charts that contain workloads such as [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) the below points should be considered.  These are to be seen as best practices rather than strict enforcement.

1. Any workload that is stateless and long-running (servers) in nature are to be created as Deployments.  Deployments, in turn, create ReplicaSets.
2. Unless there is a compelling reason, ReplicaSets or ReplicationControllers should be avoided as workload types.
3. Workloads that are stateful in nature such as databases, key-value stores, message queues, in-memory caches are to be created as StatefulSets
4. It is recommended that Deployments and StatefulSets configure their workloads with a [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) for high availability.
5. For workloads such as databases, KV stores, etc., that replicate data, it is recommended to configure interpod anti-affinity.
6. It is recommended to have a default workload update strategy configured that is suitable for this chart.
7. Batch workloads are to be created using Jobs.
8. It is best to always create workloads with the latest supported [api version](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/) as the older version are either deprecated or soon to be deprecated.
9. It is generally not advisable to provide hard [resource limits](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#resource-requests-and-limits-of-pod-and-container) to workloads and leave it configurable unless the workload requires such quantity bare minimum to function.
10. As much as possible complex pre-app setups are configured using [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

More [configuration](https://kubernetes.io/docs/concepts/configuration/overview/) best practices.


## Tests

This repository follows a [test procedure](https://github.com/helm/charts/blob/master/test/README.md). This allows the charts of this repository to be tested according to several rules (linting, semver checking, deployment testing, etc) for every Pull Request.

The `ci` directory of a given Chart allows testing different use cases, by allowing you to define different sets of values overriding `values.yaml`, one file per set. See the [documentation](https://github.com/helm/charts/blob/master/test/README.md#providing-custom-test-values) for more information.

This directory MUST exist with at least one test file in it.
