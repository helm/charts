{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "calico.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "calico.fullname" -}}
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
{{- define "calico.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account for calico
*/}}
{{- define "calico.serviceAccountName.calico" -}}
{{- if .Values.serviceAccount.calico.create -}}
    {{ default (print (include "calico.fullname" .) "-node") .Values.serviceAccount.calico.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.calico.name }}
{{- end -}}
{{- end -}}

{{- define "calico.serviceAccountName.calicoTest" -}}
{{- if .Values.serviceAccount.calico.create -}}
    {{ default (print (include "calico.fullname" .) "-test") .Values.serviceAccount.calico.nameTest }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.calico.nameTest }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account for typha autoscaler
*/}}
{{- define "calico.serviceAccountName.typhaCpha" -}}
{{- if .Values.serviceAccount.typhaCpha.create -}}
    {{ default (print (include "calico.fullname" .) "-typha-cpha") .Values.serviceAccount.typhaCpha.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.typhaCpha.name }}
{{- end -}}
{{- end -}}
