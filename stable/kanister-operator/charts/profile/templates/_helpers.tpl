{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "profile.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the profile to create
*/}}
{{- define "profile.profileName" -}}
{{- if .Values.defaultProfile -}}
    {{ .Values.defaultProfileName }}
{{- else -}}
    {{- required "If not creating a default profile, please provide a name for the profile by setting the parameter profileName" .Values.profileName -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "profile.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "profile.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "profile.helmLabels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ template "profile.chart" . }}
app: {{ template "profile.name" . }}
{{- end -}}
