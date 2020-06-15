{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "distribution.name" -}}
{{- default .Chart.Name .Values.distribution.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The distributor name
*/}}
{{- define "distributor.name" -}}
{{- default .Chart.Name .Values.distributor.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified distribution name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "distribution.fullname" -}}
{{- if .Values.distribution.fullnameOverride -}}
{{- .Values.distribution.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.distribution.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified distributor name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "distributor.fullname" -}}
{{- if .Values.distributor.fullnameOverride -}}
{{- .Values.distributor.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.distributor.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Set the final MongoDB connection URL
*/}}
{{- define "mongodb.url" -}}
{{- if .Values.global.mongoUrl -}}
{{- .Values.global.mongoUrl -}}
{{- else -}}
{{- $mongoDatabase :=  .Values.mongodb.mongodbDatabase -}}
{{- $mongoUser := .Values.mongodb.mongodbUsername -}}
{{- $mongoPassword := required "A valid .Values.mongodb.mongodbPassword entry required!" .Values.mongodb.mongodbPassword -}}
{{- printf "%s://%s:%s@%s-%s/%s" "mongodb" $mongoUser $mongoPassword .Release.Name "mongodb:27017" $mongoDatabase | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set the final MongoDB audit URL
*/}}
{{- define "mongodb.audit.url" -}}
{{- if .Values.global.mongoAuditUrl -}}
{{- .Values.global.mongoAuditUrl -}}
{{- else -}}
{{- $mongoUser := .Values.mongodb.mongodbUsername -}}
{{- $mongoPassword := required "A valid .Values.mongodb.mongodbPassword entry required!" .Values.mongodb.mongodbPassword -}}
{{- printf "%s://%s:%s@%s-%s/%s" "mongodb" $mongoUser $mongoPassword .Release.Name "mongodb:27017" "audit?maxpoolsize=500" | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set the final Redis connection URL
*/}}
{{- define "redis.url" -}}
{{- if .Values.global.redisUrl -}}
{{- .Values.global.redisUrl -}}
{{- else -}}
{{- $redisPassword := required "A valid .Values.redis.redisPassword entry required!" .Values.redis.redisPassword -}}
{{- $redisPort := .Values.redis.master.port -}}
{{- printf "%s://:%s@%s-%s:%g" "redis" $redisPassword .Release.Name "redis" $redisPort | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "distribution.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "distribution.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "distribution.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
