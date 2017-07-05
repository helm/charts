{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified store name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "store.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.store.backend | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "store.endpoint" -}}
{{- printf "http://%s-%s:2379" .Release.Name .Values.store.backend -}}
{{- end -}}


{{- define "keeper.fullname" -}}
{{- $serviceName := default "keeper" .Values.keeper.nameOverride -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name $serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sentinel.fullname" -}}
{{- $serviceName := default "sentinel" .Values.sentinel.nameOverride -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name $serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "proxy.fullname" -}}
{{- $serviceName := default "proxy" .Values.proxy.nameOverride -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name $serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
