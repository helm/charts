{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nginx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nginx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a content configmap name
*/}}
{{- define "nginx.content" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 55 | trimSuffix "-" | printf "%s-content" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 55 | trimSuffix "-" | printf "%s-content" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 55 | trimSuffix "-" | printf "%s-content" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a configuration configmap name
*/}}
{{- define "nginx.config" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 56 | trimSuffix "-" | printf "%s-config" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 56 | trimSuffix "-" | printf "%s-config" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 56 | trimSuffix "-" | printf "%s-config" -}}
{{- end -}}
{{- end -}}
{{- end -}}

