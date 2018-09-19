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
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec)
*/}}
{{- define "jaeger.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
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

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.client.url" -}}
{{- $port := .Values.storage.elasticsearch.port | toString -}}
{{- if .Values.storage.elasticsearch.nameOverride }}
{{- $host := printf "%s" .Values.storage.elasticsearch.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme $host $port }}
{{- else }}
{{- $host := printf "%s-%s" "elasticsearch" "client" | trunc 63 | trimSuffix "-" -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme $host $port }}
{{- end -}}
{{- printf "%s://%s:%s" .Values.storage.elasticsearch.scheme .Values.storage.elasticsearch.host $port }}
{{- end -}}

{{- define "jaeger.collector.host-port" -}}
{{- if .Values.agent.collector.host }}
{{- printf "%s:%s" .Values.agent.collector.host (default .Values.collector.service.tchannelPort .Values.agent.collector.port | toString) }}
{{- else }}
{{- printf "%s:%s" (include "jaeger.collector.name" .) (default .Values.collector.service.tchannelPort .Values.agent.collector.port | toString) }}
{{- end -}}
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
