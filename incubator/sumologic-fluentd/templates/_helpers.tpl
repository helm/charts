{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 64 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 64 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 64 -}}
{{- end -}}

{{/*
A uniquely named secret, which includes the install time
*/}}
{{- define "fullname-secrets" -}}
{{- printf "%s-secrets-%d" (include "fullname" .) .Release.Time.Seconds -}}
{{- end -}}
