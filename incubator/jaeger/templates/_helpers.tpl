{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jaeger.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jaeger.fullname" -}}
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
{{- define "jaeger.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the cassandra schema service account to use
*/}}
{{- define "jaeger.cassandraSchema.serviceAccountName" -}}
{{- if .Values.serviceAccounts.cassandraSchema.create -}}
    {{ default (printf "%s-cassandra-schema" (include "jaeger.fullname" .)) .Values.serviceAccounts.cassandraSchema.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.cassandraSchema.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the spark service account to use
*/}}
{{- define "jaeger.spark.serviceAccountName" -}}
{{- if .Values.serviceAccounts.spark.create -}}
    {{ default (printf "%s-spark" (include "jaeger.fullname" .)) .Values.serviceAccounts.spark.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.spark.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the hotrod service account to use
*/}}
{{- define "jaeger.hotrod.serviceAccountName" -}}
{{- if .Values.serviceAccounts.hotrod.create -}}
    {{ default (printf "%s-hotrod" (include "jaeger.fullname" .)) .Values.serviceAccounts.hotrod.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.hotrod.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the query service account to use
*/}}
{{- define "jaeger.query.serviceAccountName" -}}
{{- if .Values.serviceAccounts.query.create -}}
    {{ default (include "jaeger.query.name" .) .Values.serviceAccounts.query.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.query.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the agent service account to use
*/}}
{{- define "jaeger.agent.serviceAccountName" -}}
{{- if .Values.serviceAccounts.agent.create -}}
    {{ default (include "jaeger.agent.name" .) .Values.serviceAccounts.agent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.agent.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the collector service account to use
*/}}
{{- define "jaeger.collector.serviceAccountName" -}}
{{- if .Values.serviceAccounts.collector.create -}}
    {{ default (include "jaeger.collector.name" .) .Values.serviceAccounts.collector.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.collector.name }}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified query name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jaeger.query.name" -}}
{{- $nameGlobalOverride := printf "%s-query" (include "jaeger.fullname" .) -}}
{{- if .Values.query.fullnameOverride -}}
{{- printf "%s" .Values.query.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $nameGlobalOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified agent name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jaeger.agent.name" -}}
{{- $nameGlobalOverride := printf "%s-agent" (include "jaeger.fullname" .) -}}
{{- if .Values.agent.fullnameOverride -}}
{{- printf "%s" .Values.agent.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $nameGlobalOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified collector name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jaeger.collector.name" -}}
{{- $nameGlobalOverride := printf "%s-collector" (include "jaeger.fullname" .) -}}
{{- if .Values.collector.fullnameOverride -}}
{{- printf "%s" .Values.collector.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $nameGlobalOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "cassandra.host" -}}
{{- if .Values.provisionDataStore.cassandra -}}
{{- if .Values.storage.cassandra.nameOverride }}
{{- printf "%s" .Values.storage.cassandra.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name "cassandra" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else }}
{{- .Values.storage.cassandra.host }}
{{- end -}}
{{- end -}}

{{- define "cassandra.contact_points" -}}
{{- $port := .Values.storage.cassandra.port | toString }}
{{- if .Values.provisionDataStore.cassandra -}}
{{- if .Values.storage.cassandra.nameOverride }}
{{- $host := printf "%s" .Values.storage.cassandra.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- printf "%s:%s" $host $port }}
{{- else }}
{{- $host := printf "%s-%s" .Release.Name "cassandra" | trunc 63 | trimSuffix "-" -}}
{{- printf "%s:%s" $host $port }}
{{- end -}}
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
{{- if .Values.storage.elasticsearch.nameOverride }}
{{- $host := printf "%s" .Values.storage.elasticsearch.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme $host $port }}
{{- else }}
{{- $host := printf "%s-%s-%s" .Release.Name "elasticsearch" "client" | trunc 63 | trimSuffix "-" -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme $host $port }}
{{- end -}}
{{- else }}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme .Values.storage.elasticsearch.host $port }}
{{- end -}}
{{- end -}}

{{- define "jaeger.hotrod.tracing.host" -}}
{{- default (include "jaeger.agent.name" .) .Values.hotrod.tracing.host -}}
{{- end -}}

{{/*
Configure list of IP CIDRs allowed access to load balancer (if supported)
*/}}
{{- define "loadBalancerSourceRanges" -}}
{{- if .service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
  {{- range $cidr := .service.loadBalancerSourceRanges }}
    - {{ $cidr }}
  {{- end }}
{{- end }}
{{- end -}}
