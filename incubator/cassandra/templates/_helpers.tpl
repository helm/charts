{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cassandra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 21 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 21 chars because Kubernetes name fields are limited to 24 (by the DNS naming spec)
and Statefulset will append -xx at the end of name.
*/}}
{{- define "cassandra.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 21 -}}
{{- end -}}
