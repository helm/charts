{{/* vim: set filetype=mustache: */}}

{{- define "check-version" -}}
{{- if not .Values.agents.image.doNotCheckTag -}}
{{- $version := .Values.agents.image.tag | toString | trimSuffix "-jmx" -}}
{{- $length := len (split "." $version) -}}
{{- if and (eq $length 1) (eq $version "6") -}}
{{- $version = "6.19.0" -}}
{{- end -}}
{{- if and (eq $length 1) (eq $version "7") -}}
{{- $version = "7.19.0" -}}
{{- end -}}
{{- if and (eq $length 1) (eq $version "latest") -}}
{{- $version = "7.19.0" -}}
{{- end -}}
{{- if not (semverCompare "^6.19.0-0 || ^7.19.0-0" $version) -}}
{{- fail "This version of the chart requires an agent image 7.19.0 or greater. If you want to force and skip this check, use `--set agents.image.doNotCheckTag=true`" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "datadog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
And depending on the resources the name is completed with an extension.
If release name contains chart name it will be used as a full name.
*/}}
{{- define "datadog.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "datadog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "datadog.apiSecretName" -}}
{{- $fullName := include "datadog.fullname" . -}}
{{- default $fullName .Values.datadog.apiKeyExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "datadog.appKeySecretName" -}}
{{- $fullName := printf "%s-appkey" (include "datadog.fullname" .) -}}
{{- default $fullName .Values.datadog.appKeyExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "clusterAgent.tokenSecretName" -}}
{{- if not .Values.clusterAgent.tokenExistingSecret -}}
{{- include "datadog.fullname" . -}}-cluster-agent
{{- else -}}
{{- .Values.clusterAgent.tokenExistingSecret -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for RBAC APIs.
*/}}
{{- define "rbac.apiVersion" -}}
{{- if semverCompare "^1.8-0" .Capabilities.KubeVersion.GitVersion -}}
"rbac.authorization.k8s.io/v1"
{{- else -}}
"rbac.authorization.k8s.io/v1beta1"
{{- end -}}
{{- end -}}

{{/*
Return the appropriate os label
*/}}
{{- define "label.os" -}}
{{- if semverCompare "^1.14-0" .Capabilities.KubeVersion.GitVersion -}}
kubernetes.io/os
{{- else -}}
beta.kubernetes.io/os
{{- end -}}
{{- end -}}

{{/*
Correct `clusterAgent.metricsProvider.service.port` if Kubernetes <= 1.15
*/}}
{{- define "clusterAgent.metricsProvider.port" -}}
{{- if semverCompare "^1.15-0" .Capabilities.KubeVersion.GitVersion -}}
{{- .Values.clusterAgent.metricsProvider.service.port -}}
{{- else -}}
443
{{- end -}}
{{- end -}}

{{/*
Return the container runtime socket
*/}}
{{- define "datadog.dockerOrCriSocketPath" -}}
{{- if eq .Values.targetSystem "linux" -}}
{{- .Values.datadog.dockerSocketPath | default .Values.datadog.criSocketPath | default "/var/run/docker.sock" -}}
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
\\.\pipe\docker_engine
{{- end -}}
{{- end -}}

{{/*
Return agent config path
*/}}
{{- define "datadog.confPath" -}}
{{- if eq .Values.targetSystem "linux" -}}
/etc/datadog-agent
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
C:/ProgramData/Datadog
{{- end -}}
{{- end -}}
