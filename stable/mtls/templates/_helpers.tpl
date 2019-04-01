{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mtls.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mtls.fullname" -}}
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
{{- define "mtls.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Join a list into a comma separated string.
From: https://github.com/openstack/openstack-helm-infra/blob/bf069b231154e7b9d62dc6a7eb24debd7b1ca47a/helm-toolkit/templates/utils/_joinListWithComma.tpl
*/}}
{{- define "joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}


{{/*
abstract: |
  Converts a dictionary into an INI formatted file.
values: |
  sec1:
    key1: value1
    key2: value2
    key3:
      - value3a
      - value3b
      - value3b
usage: |
  {{ include "helm-toolkit.utils.joinListWithComma" .Values.test }}
return: |
  [sec1]
  key1 = value1
  key2 = value2
  key3 = value3a,value3b,value3c
*/}}
{{- define "toIni" -}}
{{- range $section, $details := . }}
[{{ $section }}]
{{- range $dkey, $dvalue := $details }}
{{ $dkey }} = {{ if eq (kindOf $dvalue) "slice" }}{{ include "joinListWithComma" $dvalue }}{{ else }}{{ $dvalue }}{{- end -}}
{{- end }}
{{- end }}
{{- end }}
