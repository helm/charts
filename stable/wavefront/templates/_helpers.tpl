{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wavefront.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wavefront.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wavefront.fullname" -}}
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
Create a name for Wavefront Collector
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wavefront.collector.fullname" -}}
{{- printf "%s-collector" (include "wavefront.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a name for Wavefront Proxy
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wavefront.proxy.fullname" -}}
{{- printf "%s-proxy" (include "wavefront.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wavefront.collector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "wavefront.collector.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create template used as options for Wavefront sink in collector
*/}}
{{- define "wavefront.collector.sinkOptions" -}}
{{- printf "&clusterName=%s&includeLabels=%t&includeContainers=%t&prefix=%s" .Values.clusterName (default .Values.collector.includeLabels true) (default .Values.collector.includeContainers true) (default .Values.collector.prefix "kubernetes.") -}}
{{- end -}}

