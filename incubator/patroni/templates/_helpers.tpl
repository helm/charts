
{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "patroni.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.Name | trunc 63 -}}
{{- end -}}
