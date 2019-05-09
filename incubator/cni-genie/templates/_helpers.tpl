{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cni-genie.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cni-genie.fullname" -}}
{{- if .Values.nameOverride -}}
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
Create a default fully qualified plugin name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cni-genie.plugin.fullname" -}}
{{- if .Values.plugin.fullnameOverride -}}
{{- .Values.plugin.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "plugin" .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified policy name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cni-genie.policy.fullname" -}}
{{- if .Values.policy.fullnameOverride -}}
{{- .Values.policy.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "policy" .Values.nameOverride -}}
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
{{- define "cni-genie.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use for plugin
*/}}
{{- define "cni-genie.serviceAccountName.plugin" -}}
{{- if .Values.ServiceAccounts.plugin.create -}}
    {{ default (include "cni-genie.plugin.fullname" .) .Values.ServiceAccounts.plugin.name }}
{{- else -}}
    {{ default "default" .Values.ServiceAccounts.plugin.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for policy
*/}}
{{- define "cni-genie.serviceAccountName.policy" -}}
{{- if .Values.ServiceAccounts.policy.create -}}
    {{ default (include "cni-genie.policy.fullname" .) .Values.ServiceAccounts.policy.name }}
{{- else -}}
    {{ default "default" .Values.ServiceAccounts.policy.name }}
{{- end -}}
{{- end -}}

