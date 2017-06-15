{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create fully qualified names.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scheduler-fullname" -}}
{{- $name := default .Chart.Name .Values.scheduler.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "webui-fullname" -}}
{{- $name := default .Chart.Name .Values.webUI.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "worker-fullname" -}}
{{- $name := default .Chart.Name .Values.worker.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "jupyter-fullname" -}}
{{- $name := default .Chart.Name .Values.jupyter.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}
