{{/* vim: set filetype=mustache: */}}

{{/*Expand the name of the chart.*/}}
{{- define "pomerium.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the proxy-service.*/}}
{{- define "pomerium.proxy.name" -}}
{{- default (printf "%s-proxy" .Chart.Name) .Values.proxy.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the authenticate-service.*/}}
{{- define "pomerium.authenticate.name" -}}
{{- default (printf "%s-authenticate" .Chart.Name) .Values.authenticate.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Expand the name of the authorize-service.*/}}
{{- define "pomerium.authorize.name" -}}
{{- default (printf "%s-authorize" .Chart.Name) .Values.authorize.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pomerium.fullname" -}}
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

{{/* Proxy services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.proxy.fullname" -}}
{{- if .Values.proxy.fullnameOverride -}}
{{- .Values.proxy.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-proxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-proxy" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* authorize services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.authorize.fullname" -}}
{{- if .Values.authorize.fullnameOverride -}}
{{- .Values.authorize.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authorize" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authorize" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* authenticate services fully qualified name. Truncated at 63 chars. */}}
{{- define "pomerium.authenticate.fullname" -}}
{{- if .Values.authenticate.fullnameOverride -}}
{{- .Values.authenticate.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authenticate" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authenticate" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*Create chart name and version as used by the chart label.*/}}
{{- define "pomerium.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pomerium.routestring" -}}
{{- $routes := dict "routes" (list) -}}
{{- range $key, $val := .Values.proxy.routes -}}
{{- $noop := printf "%s=%s" $key $val | append $routes.routes | set $routes "routes" -}}
{{- end -}}
{{- join "," $routes.routes | default "none=none" | quote -}}
{{- end -}}


{{/*
Check if a valid source control provider has been set
Adapted from : https://github.com/helm/charts/blob/master/stable/drone/templates/_provider-envs.yaml
*/}}
{{- define "pomerium.providerOK" -}}
{{- if .Values.authenticate.idp -}}
  {{- if eq .Values.authenticate.idp.clientID "" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientSecret "" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientID "REPLACE_ME" -}}
  false
  {{- else if eq .Values.authenticate.idp.clientSecret "REPLACE_ME" -}}
  false
  {{- else -}}
  true
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Authenticate TLS Cert */}}
{{- define "pomerium.authenticate.tlsSecret.name" -}}
{{- if .Values.authenticate.existingTLSSecret -}}
{{- .Values.authenticate.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- else if .Values.config.existingLegacyTLSSecret -}}
{{ template "pomerium.fullname" . }}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authenticate-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authenticate-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Authorize TLS Cert */}}
{{- define "pomerium.authorize.tlsSecret.name" -}}
{{- if .Values.authorize.existingTLSSecret -}}
{{- .Values.authorize.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- else if .Values.config.existingLegacyTLSSecret -}}
{{ template "pomerium.fullname" . }}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-authorize-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-authorize-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Determine secret name for Proxy TLS Cert */}}
{{- define "pomerium.proxy.tlsSecret.name" -}}
{{- if .Values.proxy.existingTLSSecret -}}
{{- .Values.proxy.existingTLSSecret | trunc 63 | trimSuffix "-" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- else if .Values.config.existingLegacyTLSSecret -}}
{{ template "pomerium.fullname" . }}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-proxy-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-proxy-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Set up secret data field names for each service */}}
{{- define "pomerium.proxy.tlsSecret.certName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.crt" "proxy-cert" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}
{{- define "pomerium.proxy.tlsSecret.keyName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.key" "proxy-key" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}

{{- define "pomerium.authenticate.tlsSecret.certName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.crt" "authenticate-cert" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}
{{- define "pomerium.authenticate.tlsSecret.keyName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.key" "authenticate-key" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}

{{- define "pomerium.authorize.tlsSecret.certName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.crt" "authorize-cert" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}
{{- define "pomerium.authorize.tlsSecret.keyName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "tls.key" "authorize-key" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}

{{- define "pomerium.caSecret.name" -}}
{{if .Values.config.existingCASecret }}
{{- .Values.proxy.existingCASecret | trunc 63 | trimSuffix "-" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- else if .Values.config.existingLegacyTLSSecret -}}
{{- template "pomerium.fullname" . -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-ca-tls" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ca-tls" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "pomerium.caSecret.certName" -}}
{{- /* TODO in future: Remove legacy logic */ -}}
{{- printf "%s" (ternary "ca.crt" "ca-cert" (empty .Values.config.existingLegacyTLSSecret)) -}}
{{- end -}}


{{/*Expand the FQDN of the forward-auth endpoint.*/}}
{{- define "pomerium.forwardAuth.name" -}}
{{- default (printf "forwardauth.%s" .Values.config.rootDomain ) .Values.forwardAuth.nameOverride -}}
{{- end -}}