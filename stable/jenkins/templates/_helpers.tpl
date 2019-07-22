{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "jenkins.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "jenkins.master.slaveKubernetesNamespace" -}}
  {{- if .Values.master.slaveKubernetesNamespace -}}
    {{- .Values.master.slaveKubernetesNamespace -}}
  {{- else -}}
    {{- if .Values.namespaceOverride -}}
      {{- .Values.namespaceOverride -}}
    {{- else -}}
      {{- .Release.Namespace -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins.fullname" -}}
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

{{- define "jenkins.kubernetes-version" -}}
  {{- if .Values.master.installPlugins -}}
    {{- range .Values.master.installPlugins -}}
      {{ if hasPrefix "kubernetes:" . }}
        {{- $split := splitList ":" . }}
        {{- printf "%s" (index $split 1 ) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Generate private key for jenkins CLI
*/}}
{{- define "jenkins.gen-key" -}}
{{- if not .Values.master.adminSshKey -}}
{{- $key := genPrivateKey "rsa" -}}
jenkins-admin-private-key: {{ $key | b64enc | quote }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jenkins.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account for Jenkins agents to use
*/}}
{{- define "jenkins.serviceAccountAgentName" -}}
{{- if .Values.serviceAccountAgent.create -}}
    {{ default (printf "%s-%s" (include "jenkins.fullname" .) "agent") .Values.serviceAccountAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccountAgent.name }}
{{- end -}}
{{- end -}}
