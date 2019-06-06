{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "storm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "storm.fullname" -}}
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
{{- define "storm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "storm.nimbus.name" -}}
{{- printf "%s-%s" (include "storm.name" .) .Values.nimbus.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified nimbus name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "storm.nimbus.fullname" -}}
{{- $name := default .Chart.Name .Values.nimbus.service.name -}}
{{- printf "%s-%s" (include "storm.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "storm.supervisor.name" -}}
{{- printf "%s-%s" (include "storm.name" .) .Values.supervisor.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified supervisor name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "storm.supervisor.fullname" -}}
{{- $name := default .Chart.Name .Values.supervisor.service.name -}}
{{- printf "%s-%s" (include "storm.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "storm.ui.name" -}}
{{- printf "%s-%s" (include "storm.name" .) .Values.ui.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified ui name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "storm.ui.fullname" -}}
{{- $name := default .Chart.Name .Values.ui.service.name -}}
{{- printf "%s-%s" (include "storm.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "storm.zookeeper.fullname" -}}
{{- $name := default .Values.zookeeper.service.name -}}
{{- printf "%s-%s" (include "storm.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "storm.logging.name" -}}
{{- printf "%s-logging" (include "storm.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Override the zookeeper service name for the zookeeper chart so that both charts reference the same zookeeper service name.
*/}}
{{- define "zookeeper.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}o
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name .Values.stormName $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}