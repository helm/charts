{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sparkoperator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
 {{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sparkoperator.fullname" -}}
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
{{- define "sparkoperator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
 {{/*
Create the name of the service account to use
*/}}
{{- define "sparkoperator.serviceAccountName" -}}
{{- if .Values.serviceAccounts.sparkoperator.create -}}
    {{ default (include "sparkoperator.fullname" .) .Values.serviceAccounts.sparkoperator.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.sparkoperator.name }}
{{- end -}}
{{- end -}}
{{- define "spark.serviceAccountName" -}}
{{- if .Values.serviceAccounts.spark.create -}}
    {{ $sparkServiceaccount := printf "%s-%s" .Release.Name "spark" }}
    {{ default $sparkServiceaccount .Values.serviceAccounts.spark.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.spark.name }}
{{- end -}}
{{- end -}}
