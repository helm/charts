{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kiam.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kiam.fullname" -}}
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
Create a fully qualified agent name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kiam.agent.fullname" -}}
{{- if .Values.agent.fullnameOverride -}}
{{- .Values.agent.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.agent.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.agent.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kiam.server.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "kiam.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the agent service account to use.
*/}}
{{- define "kiam.serviceAccountName.agent" -}}
{{- if .Values.serviceAccounts.agent.create -}}
    {{ default (include "kiam.agent.fullname" .) .Values.serviceAccounts.agent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.agent.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the server service account to use.
*/}}
{{- define "kiam.serviceAccountName.server" -}}
{{- if .Values.serviceAccounts.server.create -}}
    {{ default (include "kiam.server.fullname" .) .Values.serviceAccounts.server.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.server.name }}
{{- end -}}
{{- end -}}

{{/*
Generate certificates for kiam server and agent
*/}}
{{- define "kiam.agent.gen-certs" -}}
{{- $ca := .ca | default (genCA "kiam-ca" 365) -}}
{{- $_ := set . "ca" $ca -}}
{{- $cert := genSignedCert "Kiam Agent" nil nil 365 $ca -}}
{{.Values.agent.tlsCerts.caFileName }}: {{ $ca.Cert | b64enc }}
{{.Values.agent.tlsCerts.certFileName }}: {{ $cert.Cert | b64enc }}
{{.Values.agent.tlsCerts.keyFileName }}: {{ $cert.Key | b64enc }}
{{- end -}}
{{- define "kiam.server.gen-certs" -}}
{{- $serverName := printf "%s-%s" (include "kiam.name" .) .Values.server.name -}}
{{- $altNames := list $serverName (printf "%s:%s" $serverName .Values.server.service.port) (printf "127.0.0.1:%s" .Values.server.service.targetPort) -}}
{{- $ca := .ca | default (genCA "kiam-ca" 365) -}}
{{- $_ := set . "ca" $ca -}}
{{- $cert := genSignedCert "Kiam Server" (list "127.0.0.1") $altNames 365 $ca -}}
{{.Values.server.tlsCerts.caFileName }}: {{ $ca.Cert | b64enc }}
{{.Values.server.tlsCerts.certFileName }}: {{ $cert.Cert | b64enc }}
{{.Values.server.tlsCerts.keyFileName }}: {{ $cert.Key | b64enc }}
{{- end -}}
