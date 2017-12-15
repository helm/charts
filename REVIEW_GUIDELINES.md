# Chart Review Guidelines

Anyone is welcome to review pull requests. Besides our [technical requirements](https://github.com/kubernetes/charts/blob/master/CONTRIBUTING.md#technical-requirements) and [best practices](https://github.com/kubernetes/helm/tree/master/docs/chart_best_practices), here's an overview of process and review guidelines.

## Process

The process to get a pull request merged is fairly simple. First, all required tests need to pass and the contributor needs to have a signed CLA. If there is a problem with some part of the test, such as a timeout issue, please contact one of the charts repository maintainers by commenting `cc @kubernetes/charts-maintainers`.

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
  chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
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

## Documentation

`README.md` and `NOTES.txt` are mandatory. `README.md` should contain a table listing all configuration options. `NOTES.txt` should provide accurate and useful information how the chart can be used/accessed.

## Compatibility

We officially support compatibility with the current and the previous minor version of Kubernetes. Generated resources should use the latest possible API versions compatible with these versions. For extended backwards compatibility conditional logic based on capalilities may be used (see [built-in objects](https://github.com/kubernetes/helm/blob/master/docs/chart_template_guide/builtin_objects.md)).
