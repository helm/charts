{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gogs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gogs.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gogs.gogs.fullname" -}}
{{- printf "%s-%s" .Release.Name "gogs" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gogs.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Determine database user based on use of postgresql dependency.
*/}}
{{- define "gogs.database.host" -}}
{{- if .Values.postgresql.install -}}
{{- template "gogs.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresHost | quote -}}
{{- end -}}
{{- end -}}

{{/*
Determine database user based on use of postgresql dependency.
*/}}
{{- define "gogs.database.user" -}}
{{- .Values.postgresql.postgresUser | quote -}}
{{- end -}}

{{/*
Determine database password based on use of postgresql dependency.
*/}}
{{- define "gogs.database.password" -}}
{{- .Values.postgresql.postgresPassword | quote -}}
{{- end -}}

{{/*
Determine database name based on use of postgresql dependency.
*/}}
{{- define "gogs.database.name" -}}
{{- .Values.postgresql.postgresDatabase | quote -}}
{{- end -}}
