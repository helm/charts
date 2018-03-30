# Chart Review Guidelines

Anyone is welcome to review pull requests. Besides our [technical requirements](https://github.com/kubernetes/charts/blob/master/CONTRIBUTING.md#technical-requirements) and [best practices](https://github.com/kubernetes/helm/tree/master/docs/chart_best_practices), here's an overview of process and review guidelines.

## Process

The process to get a pull request merged is fairly simple. First, all required tests need to pass and the contributor needs to have a signed CLA. See [Charts Testing](https://github.com/kubernetes/charts/blob/master/test/README.md) for details on our CI system and how you can provide custom values for testing. If there is a problem with some part of the test, such as a timeout issue, please contact one of the charts repository maintainers by commenting `cc @kubernetes/charts-maintainers`.

The charts repository uses the OWNERS files to provide merge access. If a chart has an OWNERS file, an approver listed in that file can approve the pull request. If the chart does not have an OWNERS file, an approver in the OWNERS file at the root of the repository can approve the pull request.

To approve the pull request, an approver needs to leave a comment of `/lgtm` on the pull request. Once this is in place some tags (`lgtm` and `approved`) will be added to the pull request and a bot will come along and perform the merge.

Note, if a reviewer who is not an approver in an OWNERS file leaves a comment of `/lgtm` a `lgtm` label will be added but a merge will not happen.

## Immutability

Chart releases must be immutable. Any change to a chart warrants a chart version bump even if it is only changes to the documentation.

## Chart Metadata

The `Chart.yaml` should be as complete as possible. The following fields are mandatory:

* name (same as chart's directory)
* home
* version
* appVersion
* description
* maintainers (name should be Github username)

## Dependencies

Stable charts should not depend on charts in incubator.

## Names and Labels

Resources and labels should follow some conventions. The standard resource metadata should be this:

```yaml
name: {{ template "myapp.fullname" . }}
labels:
  app: {{ template "myapp.name" . }}
  chart: {{ template "myapp.chart" . }}
  release: {{ .Release.Name }}
  heritage: {{ .Release.Service }}
```

Note that templates have to be namespaced. With Helm 2.7+, `helm create` does this out-of-the-box. The `app` label should use the `name` template, not `fullname` as is still the case with older charts.

Label selectors for services must have both `app` and `release` labels.

```yaml
selector:
  app: {{ template "myapp.name" . }}
  release: {{ .Release.Name }}
```

If a chart has multiple components, a `component` label should be added (e. g. `component: server`). The resource name should get the component as suffix (e. g. `name: {{ template "myapp.fullname" . }}-server`). The `component` label must be added to label selectors as well.

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
      claimName: {{ .Values.persistence.existingClaim | default (include "fullname" .) }}
  {{- else }}
    emptyDir: {}
  {{- end -}}
```

* Example pvc.yaml

```yaml
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ template "fullname" . }}
  labels:
    app: {{ template "name" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
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

## Documentation

`README.md` and `NOTES.txt` are mandatory. `README.md` should contain a table listing all configuration options. `NOTES.txt` should provide accurate and useful information how the chart can be used/accessed.

## Compatibility

We officially support compatibility with the current and the previous minor version of Kubernetes. Generated resources should use the latest possible API versions compatible with these versions. For extended backwards compatibility conditional logic based on capabilities may be used (see [built-in objects](https://github.com/kubernetes/helm/blob/master/docs/chart_template_guide/builtin_objects.md)).

## Kubernetes Native Workloads.

While reviewing Charts that contain workloads such as [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) the below points should be considered.  These are to be seen as best practices rather than strict enforcement.

1. Any workload that are stateless and long running (servers) in nature are to be created as Deployments.  Deployments in turn create ReplicaSets.
2. Unless there is a compelling reason, ReplicaSets or ReplicationControllers should be avoided as workload types.
3. Workloads that are stateful in nature such as databases, key-value stores, message queues, in-memory caches are to be created as StatefulSets
4. It is recommended that Deployments and StatefulSets configure their workloads with a [Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) for high availability.
5. For workloads such as databases, KV stores, etc., that replicate data, it is recommended to configure interpod anti-affinity.
6. It is recommended to have a default workload update strategy configured that is suitable for this chart.
7. Batch workloads are to be created using Jobs.
8. It is best to always create workloads with the latest supported [api version](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/) as older version are either deprecated or soon to be deprecated.
9. It is generally not advisable to provide hard [resource limits](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#resource-requests-and-limits-of-pod-and-container) to workloads and leave it configurable unless the workload requires such quantity bare minimum to function.
10. As much as possible complex pre-app setups are configured using [init contianers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

More [configuration](https://kubernetes.io/docs/concepts/configuration/overview/) best practices.
