{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-dns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "external-dns.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "external-dns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "external-dns.labels" }}
app: {{ template "external-dns.name" . }}
heritage: {{.Release.Service }}
release: {{.Release.Name }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end }}

{{- define "external-dns.aws-credentials" }}
[default]
aws_access_key_id = {{ .Values.aws.accessKey }}
aws_secret_access_key = {{ .Values.aws.secretKey }}
{{ end }}


{{- define "external-dns.aws-config" }}
[profile default]
{{- if .Values.aws.roleArn }}
role_arn = {{ .Values.aws.roleArn }}
{{- end }}
region = {{ .Values.aws.region }}
source_profile = default
{{ end }}