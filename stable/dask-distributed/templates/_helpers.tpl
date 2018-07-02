{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dask-distributed.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create fully qualified names.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dask-distributed.scheduler-fullname" -}}
{{- $name := default .Chart.Name .Values.scheduler.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "dask-distributed.webui-fullname" -}}
{{- $name := default .Chart.Name .Values.webUI.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "dask-distributed.worker-fullname" -}}
{{- $name := default .Chart.Name .Values.worker.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{- define "dask-distributed.jupyter-fullname" -}}
{{- $name := default .Chart.Name .Values.jupyter.name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}
