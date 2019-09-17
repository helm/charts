{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "druid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "druid.fullname" -}}
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
{{- define "druid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified historical name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.historical.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.historical.name }}
{{- end -}}

{{/*
Create a default fully qualified middleManager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.middleManager.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.middleManager.name }}
{{- end -}}


{{/*
Create a default fully qualified broker name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.broker.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.broker.name }}
{{- end -}}

{{/*
Create a default fully qualified overlord name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.overlord.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.overlord.name }}
{{- end -}}

{{/*
Create a default fully qualified coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.coordinator.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.coordinator.name }}
{{- end -}}

