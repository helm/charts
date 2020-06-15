{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "traefik.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "traefik.fullname" -}}
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
{{- define "traefik.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the block for the ProxyProtocol's Trusted IPs.
*/}}
{{- define "traefik.trustedips" -}}
         trustedIPs = [
	   {{- range $idx, $ips := .Values.proxyProtocol.trustedIPs }}
	     {{- if $idx }}, {{ end }}
	     {{- $ips | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Create the block for the forwardedHeaders's Trusted IPs.
*/}}
{{- define "traefik.forwardedHeadersTrustedIPs" -}}
         trustedIPs = [
	   {{- range $idx, $ips := .Values.forwardedHeaders.trustedIPs }}
	     {{- if $idx }}, {{ end }}
	     {{- $ips | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Create the block for whiteListSourceRange.
*/}}
{{- define "traefik.whiteListSourceRange" -}}
       whiteListSourceRange = [
	   {{- range $idx, $ips := .Values.whiteListSourceRange }}
	     {{- if $idx }}, {{ end }}
	     {{- $ips | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Create the block for acme.domains.
*/}}
{{- define "traefik.acme.domains" -}}
{{- range $idx, $value := .Values.acme.domains.domainsList }}
    {{- if $value.main }}
    [[acme.domains]]
       main = {{- range $mainIdx, $mainValue := $value }} {{ $mainValue | quote }}{{- end -}}
    {{- end -}}
{{- if $value.sans }}
       sans = [
  {{- range $sansIdx, $domains := $value.sans }}
			 {{- if $sansIdx }}, {{ end }}
	     {{- $domains | quote }}
  {{- end -}}
	     ]
	{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the block for acme.resolvers.
*/}}
{{- define "traefik.acme.dnsResolvers" -}}
         resolvers = [
	   {{- range $idx, $ips := .Values.acme.resolvers }}
	     {{- if $idx }},{{ end }}
	     {{- $ips | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Create custom cipherSuites block
*/}}
{{- define "traefik.ssl.cipherSuites" -}}
          cipherSuites = [
          {{- range $idx, $cipher := .Values.ssl.cipherSuites }}
            {{- if $idx }},{{ end }}
            {{ $cipher | quote }}
          {{- end }}
          ]
{{- end -}}

{{/*
Create the block for RootCAs.
*/}}
{{- define "traefik.rootCAs" -}}
         rootCAs = [
	   {{- range $idx, $ca := .Values.rootCAs }}
	     {{- if $idx }}, {{ end }}
	     {{- $ca | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Create the block for mTLS ClientCAs.
*/}}
{{- define "traefik.ssl.mtls.clientCAs" -}}
         files = [
	   {{- range $idx, $_ := .Values.ssl.mtls.clientCaCerts }}
	     {{- if $idx }}, {{ end }}
	     {{- printf "/mtls/clientCaCert-%d.crt" $idx | quote }}
	   {{- end -}}
         ]
{{- end -}}

{{/*
Helper for containerPort (http)
*/}}
{{- define "traefik.containerPort.http" -}}
	{{- if .Values.useNonPriviledgedPorts -}}
	6080
	{{- else -}}
	80
	{{- end -}}
{{- end -}}

{{/*
Helper for RBAC Scope
If Kubernetes namespace selection is defined and the (one) selected
namespace is the release namespace Cluster scope is unnecessary.
*/}}
{{- define "traefik.rbac.scope" -}}
	{{- if .Values.kubernetes -}}
		{{- if not (eq (.Values.kubernetes.namespaces | default (list) | toString) (list .Release.Namespace | toString)) -}}
		Cluster
		{{- end -}}
	{{- else -}}
	Cluster
	{{- end -}}
{{- end -}}

{{/*
Helper for containerPort (https)
*/}}
{{- define "traefik.containerPort.https" -}}
	{{- if .Values.useNonPriviledgedPorts -}}
	6443
	{{- else -}}
	443
	{{- end -}}
{{- end -}}
