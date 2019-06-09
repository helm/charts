{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "coredns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "coredns.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate the list of ports automatically from the server definitions
*/}}
{{- define "coredns.servicePorts" -}}
    {{/* Set ports to be an empty dict */}}
    {{- $ports := dict -}}
    {{/* Iterate through each of the server blocks */}}
    {{- range .Values.servers -}}
        {{/* Capture port to avoid scoping awkwardness */}}
        {{- $port := toString .port -}}

        {{/* If none of the server blocks has mentioned this port yet take note of it */}}
        {{- if not (hasKey $ports $port) -}}
            {{- $ports := set $ports $port (dict "istcp" false "isudp" false) -}}
        {{- end -}}
        {{/* Retrieve the inner dict that holds the protocols for a given port */}}
        {{- $innerdict := index $ports $port -}}

        {{/*
        Look at each of the zones and check which protocol they serve
        At the moment the following are supported by CoreDNS:
        UDP: dns://
        TCP: tls://, grpc://
        */}}
        {{- range .zones -}}
            {{- if has (default "" .scheme) (list "dns://") -}}
                {{/* Optionally enable tcp for this service as well */}}
                {{- if eq .use_tcp true }}
                    {{- $innerdict := set $innerdict "istcp" true -}}
                {{- end }}
                {{- $innerdict := set $innerdict "isudp" true -}}
            {{- end -}}

            {{- if has (default "" .scheme) (list "tls://" "grpc://") -}}
                {{- $innerdict := set $innerdict "istcp" true -}}
            {{- end -}}
        {{- end -}}

        {{/* If none of the zones specify scheme, default to dns:// on both tcp & udp */}}
        {{- if and (not (index $innerdict "istcp")) (not (index $innerdict "isudp")) -}}
            {{- $innerdict := set $innerdict "isudp" true -}}
            {{- $innerdict := set $innerdict "istcp" true -}}
        {{- end -}}

        {{/* Write the dict back into the outer dict */}}
        {{- $ports := set $ports $port $innerdict -}}
    {{- end -}}

    {{/* Write out the ports according to the info collected above */}}
    {{- range $port, $innerdict := $ports -}}
        {{- if index $innerdict "isudp" -}}
            {{- printf "- {port: %v, protocol: UDP, name: udp-%s}\n" $port $port -}}
        {{- end -}}
        {{- if index $innerdict "istcp" -}}
            {{- printf "- {port: %v, protocol: TCP, name: tcp-%s}\n" $port $port -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Generate the list of ports automatically from the server definitions
*/}}
{{- define "coredns.containerPorts" -}}
    {{/* Set ports to be an empty dict */}}
    {{- $ports := dict -}}
    {{/* Iterate through each of the server blocks */}}
    {{- range .Values.servers -}}
        {{/* Capture port to avoid scoping awkwardness */}}
        {{- $port := toString .port -}}

        {{/* If none of the server blocks has mentioned this port yet take note of it */}}
        {{- if not (hasKey $ports $port) -}}
            {{- $ports := set $ports $port (dict "istcp" false "isudp" false) -}}
        {{- end -}}
        {{/* Retrieve the inner dict that holds the protocols for a given port */}}
        {{- $innerdict := index $ports $port -}}

        {{/*
        Look at each of the zones and check which protocol they serve
        At the moment the following are supported by CoreDNS:
        UDP: dns://
        TCP: tls://, grpc://
        */}}
        {{- range .zones -}}
            {{- if has (default "" .scheme) (list "dns://") -}}
                {{/* Optionally enable tcp for this service as well */}}
                {{- if eq .use_tcp true }}
                    {{- $innerdict := set $innerdict "istcp" true -}}
                {{- end }}
                {{- $innerdict := set $innerdict "isudp" true -}}
            {{- end -}}

            {{- if has (default "" .scheme) (list "tls://" "grpc://") -}}
                {{- $innerdict := set $innerdict "istcp" true -}}
            {{- end -}}
        {{- end -}}

        {{/* If none of the zones specify scheme, default to dns:// on both tcp & udp */}}
        {{- if and (not (index $innerdict "istcp")) (not (index $innerdict "isudp")) -}}
            {{- $innerdict := set $innerdict "isudp" true -}}
            {{- $innerdict := set $innerdict "istcp" true -}}
        {{- end -}}

        {{/* Write the dict back into the outer dict */}}
        {{- $ports := set $ports $port $innerdict -}}
    {{- end -}}

    {{/* Write out the ports according to the info collected above */}}
    {{- range $port, $innerdict := $ports -}}
        {{- if index $innerdict "isudp" -}}
            {{- printf "- {containerPort: %v, protocol: UDP, name: udp-%s}\n" $port $port -}}
        {{- end -}}
        {{- if index $innerdict "istcp" -}}
            {{- printf "- {containerPort: %v, protocol: TCP, name: tcp-%s}\n" $port $port -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "coredns.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "coredns.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
