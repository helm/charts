{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dask.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create fully qualified names.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dask.scheduler-fullname" -}}
{{- $name := default .Chart.Name .Values.scheduler.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "." -}}
{{- end -}}

{{- define "dask.webui-fullname" -}}
{{- $name := default .Chart.Name .Values.webUI.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "." -}}
{{- end -}}

{{- define "dask.worker-fullname" -}}
{{- $name := default .Chart.Name .Values.worker.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "." -}}
{{- end -}}

{{- define "dask.jupyter-fullname" -}}
{{- $name := default .Chart.Name .Values.jupyter.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "." -}}
{{- end -}}
