{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "portus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "portus.fullname" -}}
{{- printf "%s-%s" .Release.Name "portus" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "registry.fullname" -}}
{{- printf "%s-%s" .Release.Name "registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.fullname" -}}
{{- printf "%s-%s" .Release.Name "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.svc" -}}
{{- printf "%s-%s" .Release.Name "minio-svc" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create fully qualified configmap names.
*/}}
{{- define "portus.configmap" -}}
{{- printf "%s-%s" .Release.Name "portus" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "registry.configmap" -}}
{{- printf "%s-%s" .Release.Name "registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create fully qualified secret names.
*/}}
{{- define "portus.secret" -}}
{{- printf "%s-%s" .Release.Name "portus" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "portus.secret-db" -}}
{{- printf "%s-%s" .Release.Name "portus-db" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "registry.secret" -}}
{{- printf "%s-%s" .Release.Name "registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
