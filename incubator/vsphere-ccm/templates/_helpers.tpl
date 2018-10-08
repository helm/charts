{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "ccm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec)
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ccm.fullname" -}}
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
Create a fully qualified daemondset name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ccm.daemonset.name" -}}
{{- $nameGlobalOverride := printf "%s-daemonset" (include "ccm.fullname" .) -}}
{{- if .Values.daemonset.fullnameOverride -}}
{{- printf "%s" .Values.daemonset.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $nameGlobalOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "api.binding" -}}
{{- printf ":%.0f" .Values.ccm.service.endpointPort | trunc 63 | trimSuffix "-" -}}
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
