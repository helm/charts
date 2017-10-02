{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{ define "kubernetes-dashboard.name" }}{{ default "kubernetes-dashboard" .Values.nameOverride | trunc 63 }}{{ end }}

{{/*
Create a default fully qualified app name.

We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{ define "kubernetes-dashboard.fullname" }}
{{- $name := default "kubernetes-dashboard" .Values.nameOverride -}}
{{ printf "%s-%s" .Release.Name $name | trunc 63 -}}
{{ end }}
