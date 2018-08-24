{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kube-consul-register.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-consul-register.fullname" -}}
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
{{- define "kube-consul-register.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get ConfigMap name
*/}}
{{- define "kube-consul-register.configMapName" -}}
{{- if .Values.configMap.create -}}
{{- $fullname := include "kube-consul-register.fullname" . -}}
{{- printf "%s/%s" .Release.Namespace $fullname -}}
{{- else -}}
{{- $configMapName := required "configMap.name is required" .Values.configMap.name -}}
{{- printf "%s" $configMapName -}}
{{- end -}}
{{- end -}}


{{/*
Get ServiceAccount name
*/}}
{{- define "kube-consul-register.serviceAccountName" -}}
{{- if .Values.rbac.create -}}
{{- $fullname := include "kube-consul-register.fullname" . -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- $serviceAccountName := required "serviceAccountName is required" .Values.rbac.serviceAccountName -}}
{{- printf "%s" $serviceAccountName -}}
{{- end -}}
{{- end -}}
