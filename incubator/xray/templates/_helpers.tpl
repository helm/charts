{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "xray.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The xray-analysis name
*/}}
{{- define "xray-analysis.name" -}}
{{- default .Chart.Name .Values.analysis.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The xray-indexer name
*/}}
{{- define "xray-indexer.name" -}}
{{- default .Chart.Name .Values.indexer.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The xray-persist name
*/}}
{{- define "xray-persist.name" -}}
{{- default .Chart.Name .Values.persist.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The xray-server name
*/}}
{{- define "xray-server.name" -}}
{{- default .Chart.Name .Values.server.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xray.fullname" -}}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xray-analysis.fullname" -}}
{{- if .Values.analysis.fullnameOverride -}}
{{- .Values.analysis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.analysis.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xray-indexer.fullname" -}}
{{- if .Values.indexer.fullnameOverride -}}
{{- .Values.indexer.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.indexer.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xray-persist.fullname" -}}
{{- if .Values.persist.fullnameOverride -}}
{{- .Values.persist.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.persist.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xray-server.fullname" -}}
{{- if .Values.server.fullnameOverride -}}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.server.name -}}
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
{{- define "xray.mongodb.url" -}}
{{- if .Values.global.mongoUrl -}}
{{- .Values.global.mongoUrl -}}
{{- else -}}
{{- $mongoDatabase := .Values.mongodb.mongodbDatabase -}}
{{- $mongoUser := .Values.mongodb.mongodbUsername -}}
{{- $mongoPassword := default (randAlphaNum 10) .Values.mongodb.mongodbPassword -}}
{{- printf "%s//%s:%s@%s-%s%s%s" "mongodb" $mongoUser $mongoPassword .Release.Name "mongodb:27017?authSource=" $mongoDatabase "&authMechanism=SCRAM-SHA-1" -}}
{{- end -}}
{{- end -}}

{{/*
Set the final PostgreSQL connection URL
*/}}
{{- define "xray.postgresql.url" -}}
{{- if .Values.global.postgresqlUrl -}}
{{- .Values.global.postgresqlUrl -}}
{{- else -}}
{{- $postgresDatabase := .Values.postgresql.postgresDatabase -}}
{{- $postgresUser := .Values.postgresql.postgresUser -}}
{{- $postgresPassword := default (randAlphaNum 10) .Values.postgresql.postgresPassword -}}
{{- printf "%s://%s:%s@%s-%s/%s%s" "postgres" $postgresUser $postgresPassword .Release.Name "postgresql:5432" $postgresDatabase "?sslmode=disable" -}}
{{- end -}}
{{- end -}}

{{/*
Set the final RabbitMQ connection URL
*/}}
{{- define "xray.rabbitmq.url" -}}
{{- if .Values.global.mqBaseUrl -}}
{{- .Values.global.mqBaseUrl -}}
{{- else -}}
{{- $rabbitmqUser := (index .Values "rabbitmq-ha" "rabbitmqUsername") -}}
{{- $rabbitmqPassword := default (randAlphaNum 10) (index .Values "rabbitmq-ha" "rabbitmqPassword") -}}
{{- printf "%s://%s:%s@%s-%s" "amqp" $rabbitmqUser $rabbitmqPassword .Release.Name "rabbitmq-ha:5672/" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "xray.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}