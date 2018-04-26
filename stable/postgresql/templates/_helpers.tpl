{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgresql.fullname" -}}
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
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "postgresql.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"extensions/v1beta1"
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"networking.k8s.io/v1"
{{- end -}}
{{- end -}}

{{/*
    generates a yaml secretKeyRef env structure and expects the following structure as input (dict):
    ```
    secretKeyRefs:
        <container-env-var-name>:
            name: <secret resource name> (optional, defaults to postgresql.fullname as secret resource name)
            key: <secret resource entry>
    ```
*/}}
{{- define "postgresql.secretKeyRefs" -}}
{{- $global := . -}}
{{- range $k, $v := .Values.secretKeyRefs }}
- name: {{ $k | upper | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ default (include "postgresql.fullname" $global) $v.name | quote }}
      key: {{ $v.key | quote }}
{{- end -}}
{{- end -}}
