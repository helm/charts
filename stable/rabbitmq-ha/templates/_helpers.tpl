{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq-ha.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rabbitmq-ha.fullname" -}}
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
{{- define "rabbitmq-ha.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "rabbitmq-ha.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "rabbitmq-ha.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Generate chart secret name
*/}}
{{- define "rabbitmq-ha.secretName" -}}
{{ default (include "rabbitmq-ha.fullname" .) .Values.existingSecret }}
{{- end -}}

{{/*
Generate chart ssl secret name
*/}}
{{- define "rabbitmq-ha.certSecretName" -}}
{{ default (print (include "rabbitmq-ha.fullname" .) "-cert") .Values.rabbitmqCert.existingSecret }}
{{- end -}}

{{/*
Defines a JSON file containing definitions of all broker objects (queues, exchanges, bindings, 
users, virtual hosts, permissions and parameters) to load by the management plugin.
*/}}
{{- define "rabbitmq-ha.definitions" -}}
{
  "global_parameters": [
{{ .Values.definitions.globalParameters | indent 4 }}
  ],
  "users": [
    {
      "name": {{ .Values.managementUsername | quote }},
      "password": {{ .Values.managementPassword | quote }},
      "tags": "management"
    },
    {
      "name": {{ .Values.rabbitmqUsername | quote }},
      "password": {{ .Values.rabbitmqPassword | quote }},
      "tags": "administrator"
    }{{- if .Values.definitions.users -}},
{{ .Values.definitions.users | indent 4 }}
{{- end }}
  ],
  "vhosts": [
    {
      "name": {{ .Values.rabbitmqVhost | quote }}
    }{{- if .Values.definitions.vhosts -}},
{{ .Values.definitions.vhosts | indent 4 }}
{{- end }}
  ],
  "permissions": [
    {
      "user": {{ .Values.rabbitmqUsername | quote }},
      "vhost": {{ .Values.rabbitmqVhost | quote }},
      "configure": ".*",
      "read": ".*",
      "write": ".*"
    }{{- if .Values.definitions.permissions -}},
{{ .Values.definitions.permissions | indent 4 }}
{{- end }}
  ],
  "parameters": [
{{ .Values.definitions.parameters| indent 4 }}
  ],
  "policies": [
{{ .Values.definitions.policies | indent 4 }}
  ],
  "queues": [
{{ .Values.definitions.queues | indent 4 }}
  ],
  "exchanges": [
{{ .Values.definitions.exchanges | indent 4 }}
  ],
  "bindings": [
{{ .Values.definitions.bindings| indent 4 }}
  ]
}
{{- end -}}
