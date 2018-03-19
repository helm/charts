{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default etcd qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "etcd.fullname" -}}
{{- printf "%s-%s" .Release.Name "etcd" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default pachd qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "pachd.fullname" -}}
{{- printf "%s-%s" .Release.Name "pachd" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default dash qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dash.fullname" -}}
{{- printf "%s-%s" .Release.Name "dash" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default dash qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grpc.fullname" -}}
{{- printf "%s-%s" .Release.Name "grpc" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
