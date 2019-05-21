{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "spinnaker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "spinnaker.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels for metadata.
*/}}
{{- define "spinnaker.standard-labels" -}}
app: {{ include "spinnaker.fullname" . | quote }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
{{- end -}}

{{/*
A set of common selector labels for resources.
*/}}
{{- define "spinnaker.standard-selector-labels" -}}
app: {{ include "spinnaker.fullname" . | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Create comma separated list of omitted namespaces in Kubernetes
*/}}
{{- define "omittedNameSpaces" -}}
{{- join "," .Values.kubeConfig.omittedNameSpaces }}
{{- end -}}

{{/*
Redis base URL for Spinnaker
*/}}
{{- define "spinnaker.redisBaseURL" -}}
{{- if .Values.redis.enabled }}
{{- printf "redis://:%s@%s-redis-master:6379" .Values.redis.password .Release.Name -}}
{{- else if .Values.redis.external.password }}
{{- printf "redis://:%s@%s:%s" .Values.redis.external.password .Values.redis.external.host (.Values.redis.external.port | toString) -}}
{{- else }}
{{- printf "redis://%s:%s" .Values.redis.external.host (.Values.redis.external.port | toString) -}}
{{- end }}
{{- end }}
