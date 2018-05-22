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
*/}}
{{- define "distribution.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
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
{{- $mongoDatabase :=  .Values.mongodb.db.name -}}
{{- if .Values.mongodb.mongodbUsername }}
{{- $mongoUser :=  .Values.mongodb.db.distributionUser -}}
{{- $mongoPassword :=  .Values.mongodb.db.distributionPassword -}}
{{- printf "%s://%s:%s@%s-%s/%s "  "mongodb" $mongoUser $mongoPassword .Release.Name "mongodb:27017" $mongoDatabase | b64enc | quote -}}
{{- else -}}
{{- printf "%s://%s-%s/%s" "mongodb" .Release.Name "mongodb:27017" $mongoDatabase | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set the final MongoDB audit URL
*/}}
{{- define "mongodb.audit.url" -}}
{{- if .Values.mongodb.mongodbUsername }}
{{- $mongoUser :=  .Values.mongodb.db.distributionUser -}}
{{- $mongoPassword :=  .Values.mongodb.db.distributionPassword -}}
{{- printf "%s://%s:%s@%s-%s/%s "  "mongodb" $mongoUser $mongoPassword .Release.Name "mongodb:27017" "audit?maxpoolsize=500" | b64enc | quote -}}
{{- else -}}
{{- printf "%s://%s-%s/%s" "mongodb" .Release.Name "mongodb:27017" "audit?maxpoolsize=500" | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set the final Redis connection URL
*/}}
{{- define "redis.url" -}}
{{- $redisPassword :=  .Values.redis.redisPassword -}}
{{- printf "%s://:%s@%s-%s" "redis" $redisPassword .Release.Name "redis:6379" | b64enc | quote -}}
{{- end -}}