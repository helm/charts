{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the block for the ProxyProtocol's Trusted IPs.
*/}}
{{- define "trustedips" -}}
         trustedIPs = [
	   {{- range $idx, $ips := .Values.proxyProtocol.trustedIPs }}
	     {{- if $idx }}, {{ end }}
	     {{- $ips | quote }}
	   {{- end -}}
         ]
{{- end -}}
