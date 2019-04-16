{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "thanos.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "thanos.fullname" -}}
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


{{- define "thanos.common.metaLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "thanos.chart" $ | quote  }}
{{- end -}}

{{- define "thanos.common.matchLabels" -}}
app.kubernetes.io/name: {{ include "thanos.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{- define "thanos.query.labels" -}}
{{ include "thanos.query.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.query.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.queryLayer.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}

{{- define "thanos.rule.labels" -}}
{{ include "thanos.rule.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.rule.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.ruleLayer.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}

{{- define "thanos.store.labels" -}}
{{ include "thanos.store.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.store.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.storeLayer.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}

{{- define "thanos.compact.labels" -}}
{{ include "thanos.compact.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.compact.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.compactLayer.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}

{{- define "thanos.sidecar.labels" -}}
{{ include "thanos.sidecar.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.sidecar.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.sidecarLayer.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}

{{- define "thanos.ingress.labels" -}}
{{ include "thanos.ingress.matchLabels" . }}
{{ include "thanos.common.metaLabels" . }}
{{- end -}}

{{- define "thanos.ingress.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.ingress.component | quote }}
{{ include "thanos.common.matchLabels" . }}
{{- end -}}






{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "thanos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
