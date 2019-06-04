{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for prometheus components
*/}}
{{- define "prometheus.common.matchLabels" -}}
app: {{ template "prometheus.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "prometheus.common.metaLabels" -}}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "prometheus.alertmanager.labels" -}}
{{ include "prometheus.alertmanager.matchLabels" . }}
{{ include "prometheus.common.metaLabels" . }}
{{- end -}}

{{- define "prometheus.alertmanager.matchLabels" -}}
component: {{ .Values.alertmanager.name | quote }}
{{ include "prometheus.common.matchLabels" . }}
{{- end -}}

{{- define "prometheus.kubeStateMetrics.labels" -}}
{{ include "prometheus.kubeStateMetrics.matchLabels" . }}
{{ include "prometheus.common.metaLabels" . }}
{{- end -}}

{{- define "prometheus.kubeStateMetrics.matchLabels" -}}
component: {{ .Values.kubeStateMetrics.name | quote }}
{{ include "prometheus.common.matchLabels" . }}
{{- end -}}

{{- define "prometheus.nodeExporter.labels" -}}
{{ include "prometheus.nodeExporter.matchLabels" . }}
{{ include "prometheus.common.metaLabels" . }}
{{- end -}}

{{- define "prometheus.nodeExporter.matchLabels" -}}
component: {{ .Values.nodeExporter.name | quote }}
{{ include "prometheus.common.matchLabels" . }}
{{- end -}}

{{- define "prometheus.pushgateway.labels" -}}
{{ include "prometheus.pushgateway.matchLabels" . }}
{{ include "prometheus.common.metaLabels" . }}
{{- end -}}

{{- define "prometheus.pushgateway.matchLabels" -}}
component: {{ .Values.pushgateway.name | quote }}
{{ include "prometheus.common.matchLabels" . }}
{{- end -}}

{{- define "prometheus.server.labels" -}}
{{ include "prometheus.server.matchLabels" . }}
{{ include "prometheus.common.metaLabels" . }}
{{- end -}}

{{- define "prometheus.server.matchLabels" -}}
component: {{ .Values.server.name | quote }}
{{ include "prometheus.common.matchLabels" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus.fullname" -}}
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
Create a fully qualified alertmanager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "prometheus.alertmanager.fullname" -}}
{{- if .Values.alertmanager.fullnameOverride -}}
{{- .Values.alertmanager.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.alertmanager.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.alertmanager.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified kube-state-metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus.kubeStateMetrics.fullname" -}}
{{- if .Values.kubeStateMetrics.fullnameOverride -}}
{{- .Values.kubeStateMetrics.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.kubeStateMetrics.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.kubeStateMetrics.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified node-exporter name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus.nodeExporter.fullname" -}}
{{- if .Values.nodeExporter.fullnameOverride -}}
{{- .Values.nodeExporter.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.nodeExporter.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.nodeExporter.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified Prometheus server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus.server.fullname" -}}
{{- if .Values.server.fullnameOverride -}}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified pushgateway name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus.pushgateway.fullname" -}}
{{- if .Values.pushgateway.fullnameOverride -}}
{{- .Values.pushgateway.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.pushgateway.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.pushgateway.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "prometheus.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the alertmanager component
*/}}
{{- define "prometheus.serviceAccountName.alertmanager" -}}
{{- if .Values.serviceAccounts.alertmanager.create -}}
    {{ default (include "prometheus.alertmanager.fullname" .) .Values.serviceAccounts.alertmanager.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.alertmanager.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the kubeStateMetrics component
*/}}
{{- define "prometheus.serviceAccountName.kubeStateMetrics" -}}
{{- if .Values.serviceAccounts.kubeStateMetrics.create -}}
    {{ default (include "prometheus.kubeStateMetrics.fullname" .) .Values.serviceAccounts.kubeStateMetrics.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.kubeStateMetrics.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the nodeExporter component
*/}}
{{- define "prometheus.serviceAccountName.nodeExporter" -}}
{{- if .Values.serviceAccounts.nodeExporter.create -}}
    {{ default (include "prometheus.nodeExporter.fullname" .) .Values.serviceAccounts.nodeExporter.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.nodeExporter.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the pushgateway component
*/}}
{{- define "prometheus.serviceAccountName.pushgateway" -}}
{{- if .Values.serviceAccounts.pushgateway.create -}}
    {{ default (include "prometheus.pushgateway.fullname" .) .Values.serviceAccounts.pushgateway.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.pushgateway.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the server component
*/}}
{{- define "prometheus.serviceAccountName.server" -}}
{{- if .Values.serviceAccounts.server.create -}}
    {{ default (include "prometheus.server.fullname" .) .Values.serviceAccounts.server.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.server.name }}
{{- end -}}
{{- end -}}
