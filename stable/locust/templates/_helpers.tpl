{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "locust.fullname" -}}
{{- printf "%s-%s" .Release.Name "locust" | trunc 63 -}}
{{- end -}}

{{- define "locust.master-svc" -}}
{{- printf "%s-%s" .Release.Name "master-svc" | trunc 63 -}}
{{- end -}}

{{- define "locust.master" -}}
{{- printf "%s-%s" .Release.Name "master" | trunc 63 -}}
{{- end -}}

{{- define "locust.worker" -}}
{{- printf "%s-%s" .Release.Name "worker" | trunc 63 -}}
{{- end -}}

{{/*
Create fully qualified configmap name.
*/}}
{{- define "locust.worker-configmap" -}}
{{ if .Values.worker.config.configmapName }}
{{- printf .Values.worker.config.configmapName -}}
{{ else }}
{{- printf "%s-%s" .Release.Name "worker" -}}
{{ end }}
{{- end -}}
