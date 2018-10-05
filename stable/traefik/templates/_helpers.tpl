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
Create custom cipherSuites block
*/}}
{{- define "traefik.ssl.cipherSuites" -}}
          chipherSuites = [
          {{- range $idx, $cipher := .Values.ssl.cipherSuites }}
            {{- if $idx }},{{ end }}
            {{ $cipher | quote }}
          {{- end }}
          ]
{{- end -}}
