{{/* vim: set filetype=mustache: */}}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "batch/v1beta1" -}}
"batch/v1beta1"
{{- else -}}
"batch/v2alpha1"
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "jaeger.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jaeger.fullname" -}}
{{- $name := default "jaeger" .Values.nameOverride -}}
{{- if ne .Chart.Name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified query name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jaeger.query.fullname" -}}
{{- $name := default "jaeger-query" .Values.queryNameOverride -}}
{{- if ne .Chart.Name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "jaeger.agent.service.name" -}}
{{- $name := default .Chart.Name .Values.agent.service.nameOverride -}}
{{- if .Values.agent.service.nameOverride }}
{{- printf "%s" .Values.agent.service.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{- define "cassandra.host" -}}
{{- if .Values.provisionDataStore.cassandra -}}
{{- printf "%s-%s" .Release.Name "cassandra" | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- .Values.storage.cassandra.host }}
{{- end -}}
{{- end -}}

{{- define "cassandra.contact_points" -}}
{{- $port := .Values.storage.cassandra.port | toString }}
{{- if .Values.provisionDataStore.cassandra -}}
{{- $host := printf "%s-%s" .Release.Name "cassandra" | trunc 63 | trimSuffix "-" -}}
{{- printf "%s:%s" $host $port }}
{{- else }}
{{- printf "%s:%s" .Values.storage.cassandra.host $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.client.url" -}}
{{- $port := .Values.storage.elasticsearch.port | toString -}}
{{- if .Values.provisionDataStore.elasticsearch -}}
{{- $host := printf "%s-%s-%s" .Release.Name "elasticsearch" "client" | trunc 63 | trimSuffix "-" -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme $host $port }}
{{- else }}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme .Values.storage.elasticsearch.host $port }}
{{- end -}}
{{- end -}}

{{- define "jaeger.collector.host-port" -}}
{{- if .Values.agent.collector.host }}
{{- printf "%s:%s" .Values.agent.collector.host (default .Values.collector.service.tchannelPort .Values.agent.collector.port | toString) }}
{{- else }}
{{- printf "%s-collector:%s" (include "jaeger.fullname" .) (default .Values.collector.service.tchannelPort .Values.agent.collector.port | toString) }}
{{- end -}}
{{- end -}}

{{- define "jaeger.hotrod.tracing.host" -}}
{{- $host := printf "%s-agent" (include "jaeger.agent.service.name" .) -}}
{{- default $host .Values.hotrod.tracing.host -}}
{{- end -}}
