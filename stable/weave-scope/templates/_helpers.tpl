{{/* Weave Scope default labels */}}
{{- define "scope_labels" }}
source-app: weave-scope
weave-cloud-component: scope
weave-scope-component: app
{{- end }}

{{/* Weave Scope default annotations */}}
{{- define "scope_annotations" }}
cloud.weave.works/launcher-info: |-
  { 
    "server-version": "master-c3b4969",
    "original-request": {
      "url": "/k8s/v1.6/scope.yaml",
    },
    "email-address": "support@weave.works"
  }
{{- end }}

{{/* Weave Scope component resources spec */}}
{{- define "scope_resources" }}
{{- if .Values.resources }}
resources:
  {{- if .Values.resources.limits }}
  limits:
    {{- if .Values.resources.limits.cpu }}
    cpu: {{ .Values.resources.limits.cpu }}
    {{- end }}
    {{- if .Values.resources.limits.memory }}
    memory: {{ .Values.resources.limits.memory }}
    {{- end }}
  {{- end }}
  {{- if .Values.resources.requests }}
  requests:
    {{- if .Values.resources.requests.cpu }}
    cpu: {{ .Values.resources.requests.cpu }}
    {{- end }}
    {{- if .Values.resources.requests.memory }}
    memory: {{ .Values.resources.requests.memory }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- end -}}
