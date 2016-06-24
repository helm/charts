{{/* vim: set filetype=mustache: */}}
{{/*
The commons templates provide basic implementations common to many Chart
templates.

*/}}

{{/*
fullname defines a suitably unique name for a resource by combining
the release name and the chart name.

Note that we truncate fullname at 24 characters so that it can be used inside
of a `metadata:name` field.

Usage: 'name: "{{template "fullname" .}}"'
*/}}
{{define "common.fullname"}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 24 -}}
{{end}}

{{define "common.chartref"}}{{printf "%s-%s" .Chart.Name .Chart.Version}}{{end}}

{{/*
The common labels that are frequently used in metadata.
*/}}
{{define "common.metadata.labels"}}
    app: {{template "common.fullname" .}}
    heritage: {{ .Release.Service | quote }}
    release: {{ .Release.Name | quote }}
    chart: {{template "common.chartref" . }}
{{end}}

{{/*
Define a hook.

This is to be used in a 'metadata:annotations' section.

This should be called as 'template "common.metadata.hook" "post-install"'
*/}}
{{- define "common.metadata.hook"}}
    "helm.sh/hook": {{printf "%s" . | quote}}
{{- end}}
