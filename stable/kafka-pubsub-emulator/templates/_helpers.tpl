{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka-pubsub-emulator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka-pubsub-emulator.fullname" -}}
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
{{- define "kafka-pubsub-emulator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create bootsrapServers: if using kafka child chart build based on release name
*/}}
{{- define "kafka-pubsub-emulator.bootstrapServers" -}}
{{- if .Values.server.kafka.bootstrapServers -}}
    {{ toJson .Values.server.kafka.bootstrapServers }}
{{- else -}}
    {{- printf "[ \"RELEASE-kafka-0.RELEASE-kafka-headless:9092\", \"RELEASE-kafka-1.RELEASE-kafka-headless:9092\", \"RELEASE-kafka-2.RELEASE-kafka-headless:9092\" ]" | replace "RELEASE" .Release.Name -}}
{{- end -}}
{{- end -}}
