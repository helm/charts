{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "yugabyte.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "yugabyte.fullname" -}}
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
Derive the memory hard limit for each POD based on the memory limit.
Since the memory is represented in <x>GBi, we use this function to convert that into bytes.
Multiplied by 870 since 0.85 * 1024 ~ 870 (floating calculations not supported)
*/}}
{{- define "yugabyte.memory_hard_limit" -}}
{{- printf "%d" .limits.memory | regexFind "\\d+" | mul 1024 | mul 1024 | mul 870 }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "yugabyte.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
