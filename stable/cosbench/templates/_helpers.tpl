{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cosbench.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified controller name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cosbench.controller.fullname" -}}
{{- printf "%s-cosbench-controller" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified driver name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cosbench.driver.fullname" -}}
{{- printf "%s-cosbench-driver" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cosbench.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use for the controller component
*/}}
{{- define "cosbench.serviceAccountName.controller" -}}
{{- if .Values.serviceAccounts.controller.create -}}
    {{ default (include "cosbench.controller.fullname" .) .Values.serviceAccounts.controller.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.controller.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the driver component
*/}}
{{- define "cosbench.serviceAccountName.driver" -}}
{{- if .Values.serviceAccounts.driver.create -}}
    {{ default (include "cosbench.driver.fullname" .) .Values.serviceAccounts.driver.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.driver.name }}
{{- end -}}
{{- end -}}

{{/*
Create a comma seperated list of drivers
*/}}
{{- define "cosbench.driversList" -}}
{{- $count := (int .Values.driver.replicaCount) -}}
{{- $release := .Release.Name -}}
{{- range $v := until $count }}{{ $release }}-cosbench-driver-{{ $v }}.{{ $release }}-cosbench-driver{{ if ne $v (sub $count 1) }},{{- end -}}{{- end -}}
{{- end -}}
