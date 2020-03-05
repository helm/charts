{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "graylog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "graylog.fullname" -}}
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
Create the name of the service account to use
*/}}
{{- define "graylog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "graylog.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the headless service
*/}}
{{- define "graylog.service.headless.name" }}
{{- printf "%s-%s" (include "graylog.fullname" .) .Values.graylog.service.headless.suffix | trimSuffix "-" -}}
{{- end -}}

{{/*
Craft url taking into account the TLS settings of the server
*/}}
{{- define "graylog.formatUrl" -}}
{{- $env := index . 0 }}
{{- $url := index . 1 }}
{{- if $env.Values.graylog.tls.enabled }}
{{- printf "https://%s" $url }}
{{- else }}
{{- printf "http://%s" $url }}
{{- end -}}
{{- end -}}

{{/*
Print external URI
*/}}
{{- define "graylog.url" -}}
{{- if .Values.graylog.externalUri }}
{{- include "graylog.formatUrl" (list . .Values.graylog.externalUri) }}
{{- else if .Values.graylog.ingress.enabled }}
{{- if .Values.graylog.ingress.tls }}
{{- range .Values.graylog.ingress.tls }}{{ range .hosts }}https://{{ . }}{{ end }}{{ end }}
{{- else }}
{{- range .Values.graylog.ingress.hosts }}http://{{ . }}{{ end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Create a default fully qualified elasticsearch name or use the `graylog.elasticsearch.hosts` value if defined.
Or use chart dependencies with release name
*/}}
{{- define "graylog.elasticsearch.hosts" -}}
{{- if .Values.graylog.elasticsearch.uriSecretKey }}
    {{- if .Values.graylog.elasticsearch.uriSSL }}
        {{- printf "https://${GRAYLOG_ELASTICSEARCH_HOST}" -}}
    {{- else }}
        {{- printf "http://${GRAYLOG_ELASTICSEARCH_HOST}" -}}
    {{- end }}
{{- else if .Values.graylog.elasticsearch.hosts }}
    {{- .Values.graylog.elasticsearch.hosts -}}
{{- else }}
    {{- printf "http://%s-elasticsearch-client.%s.svc.cluster.local:9200" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified mongodb name or use the `graylog.mongodb.uri` value if defined.
Or use chart dependencies with release name
*/}}
{{- define "graylog.mongodb.uri" -}}
{{- if .Values.graylog.mongodb.uriSecretKey }}
    {{- printf "${GRAYLOG_MONGODB_URI}" -}}
{{- else if .Values.graylog.mongodb.uri }}
    {{- .Values.graylog.mongodb.uri -}}
{{- else }}
    {{- printf "mongodb://%s-mongodb-replicaset.%s.svc.cluster.local:27017/graylog?replicaSet=rs0" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "graylog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Standard metadata labels used by the chart.
*/}}
{{- define "graylog.metadataLabels" -}}
helm.sh/chart: {{ template "graylog.chart" . }}
{{ template "graylog.selectorLabels" . }}
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
{{- end -}}

{{/*
Selector labels used by the chart.
*/}}
{{- define "graylog.selectorLabels" -}}
app.kubernetes.io/name: {{ template "graylog.name" . }}
app.kubernetes.io/instance: "{{ .Release.Name }}"
{{- if .Values.helm2Compatibility }}
app.kubernetes.io/managed-by: "Tiller"
{{- else }}
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
{{- end -}}
{{- end -}}
