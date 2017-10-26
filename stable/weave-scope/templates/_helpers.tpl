{{/* Helm standard labels */}}
{{- define "weave-scope.helm_std_labels" }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
app: {{ template "weave-scope.name" . }}
{{- end }}

{{/* Weave Scope default annotations */}}
{{- define "weave-scope.annotations" }}
cloud.weave.works/launcher-info: |-
  { 
    "server-version": "master-4fe8efe",
    "original-request": {
      "url": "/k8s/v1.7/scope.yaml"
    },
    "email-address": "support@weave.works",
    "source-app": "weave-scope",
    "weave-cloud-component": "scope"
  }
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "weave-scope.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.  We truncate at 63 chars.
*/}}
{{- define "weave-scope.fullname" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


