{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solr.fullname" -}}
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
Define the name of the headless service for solr
*/}}
{{- define "solr.headless-service-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "headless" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the client service for solr
*/}}
{{- define "solr.service-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "svc" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the solr exporter
*/}}
{{- define "solr.exporter-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper service
*/}}
{{- define "solr.zookeeper-name" -}}
{{- printf "%s-%s" .Release.Name "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper headless service
*/}}
{{- define "solr.zookeeper-service-name" -}}
{{ printf "%s-%s" (include "solr.zookeeper-name" .) "headless" | trunc 63 | trimSuffix "-"  }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "solr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the name of the solr PVC
*/}}
{{- define "solr.pvc-name" -}}
{{ printf "%s-%s" (include "solr.fullname" .) "pvc" | trunc 63 | trimSuffix "-"  }}
{{- end -}}

{{/*
  Define the name of the solr.xml configmap
*/}}
{{- define "solr.configmap-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "config-map" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the name of the custom script configmap
*/}}
{{- define "solr.custom-script.configmap-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "custom-script-config-map" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the labels that should be applied to all resources in the chart
*/}}
{{- define "solr.common.labels" -}}
app.kubernetes.io/name: {{ include "solr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "solr.chart" . }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "solr.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if or .Values.image.pullSecrets .Values.exporter.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.exporter.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.exporter.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.exporter.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}