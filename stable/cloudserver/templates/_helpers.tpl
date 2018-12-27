{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cloudserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudserver.fullname" -}}
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
Create a default fully qualified name for the cloudserver data app.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cloudserver.localdata.fullname" -}}
{{- if .Values.localdata.fullnameOverride -}}
{{- .Values.localdata.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-localdata" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-localdata" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloudserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use for the api component
*/}}
{{- define "cloudserver.serviceAccountName.api" -}}
{{- if .Values.serviceAccounts.api.create -}}
    {{ default (include "cloudserver.fullname" .) .Values.serviceAccounts.api.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.api.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the localdata component
*/}}
{{- define "cloudserver.serviceAccountName.localdata" -}}
{{- if .Values.serviceAccounts.localdata.create -}}
    {{ default (include "cloudserver.localdata.fullname" .) .Values.serviceAccounts.localdata.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.localdata.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified mongodb-replicaset name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cloudserver.mongodb-replicaset.fullname" -}}
{{- $name := default "mongodb-replicaset" (index .Values "mongodb-replicaset" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the MongoDB URL. If MongoDB is installed as part of this chart, use k8s service discovery,
else use user-provided URL.
*/}}
{{- define "mongodb-replicaset.url" -}}
{{- if (index .Values "mongodb-replicaset" "enabled") -}}
{{- $count := (int (index .Values "mongodb-replicaset" "replicas")) -}}
{{- $release := .Release.Name -}}
{{- range $v := until $count }}{{ $release }}-mongodb-replicaset-{{ $v }}.{{ $release }}-mongodb-replicaset:27017{{ if ne $v (sub $count 1) }},{{- end -}}{{- end -}}
{{- else -}}
{{- index .Values "mongodb-replicaset" "url" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis-ha name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cloudserver.redis-ha.fullname" -}}
{{- $name := default "redis-ha" (index .Values "redis-ha" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the Redis-HA URL. If Redis-HA is installed as part of this chart, use k8s service discovery,
else use user-provided URL.
*/}}
{{- define "redis-ha.url" -}}
{{- if (index .Values "redis-ha" "enabled") -}}
{{- $count := (int (index .Values "redis-ha" "replicas")) -}}
{{- $release := .Release.Name -}}
{{- range $v := until $count }}{{ $release }}-redis-ha-server-{{ $v }}.{{ $release }}-redis-ha:26379{{ if ne $v (sub $count 1) }},{{- end -}}{{- end -}}
{{- else -}}
{{- index .Values "redis-ha" "url" -}}
{{- end -}}
{{- end -}}
