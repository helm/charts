{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-postgres-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-postgres-exporter.fullname" -}}
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
{{- define "prometheus-postgres-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus-postgres-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "prometheus-postgres-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create datasource value either for DATA_SOURCE_URI or DATA_SOURCE_NAME environment variables
*/}}
{{- define "prometheus-postgres-exporter.data_source" -}}
{{- $default := .Values.config.datasource -}}
{{- if .Values.config.datasources -}}
  {{- $output := list -}}
  {{- range $ds := .Values.config.datasources -}}
    {{- $ds := merge $ds $default -}}
    {{- $userpass := printf "%s:%s" $ds.user $ds.password | trimSuffix ":" | trimPrefix ":" }}
    {{- if $userpass -}}{{- $userpass = printf "%s@" $userpass -}}{{- end -}}
    {{- $output = append $output (printf "postgresql://%s%s:%s/%s?sslmode=%s" $userpass $ds.host $ds.port $ds.database $ds.sslmode) -}}
  {{- end -}}
{{ $output | join "," }}
{{- else -}}
{{ printf "%s:%s/%s?sslmode=%s" .Values.config.datasource.host .Values.config.datasource.port .Values.config.datasource.database .Values.config.datasource.sslmode | quote }}
{{- end -}}
{{- end }}
