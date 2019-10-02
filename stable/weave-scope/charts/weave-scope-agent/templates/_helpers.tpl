{{/* Helm standard labels */}}
{{- define "weave-scope-agent.helm_std_labels" }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
app: {{ template "toplevel.name" . }}
{{- end }}

{{/* Weave Scope default annotations */}}
{{- define "weave-scope-agent.annotations" }}
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
{{- define "weave-scope-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the top-level chart.
*/}}
{{- define "toplevel.name" -}}
{{- default (.Template.BasePath | split "/" )._0 .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.  We truncate at 63 chars.
*/}}
{{- define "weave-scope-agent.fullname" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified name that always uses the name of the top-level chart.
*/}}
{{- define "toplevel.fullname" -}}
{{- $name := default (.Template.BasePath | split "/" )._0 .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "weave-scope-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "weave-scope-agent.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the apiVersion of daemonset.
*/}}
{{- define "daemonset.apiVersion" -}}
{{- if semverCompare "<1.9-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}
