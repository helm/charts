{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scdf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default short app name to use for resource naming.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scdf.fullname" -}}
{{- $name := default "data-flow" .Values.appNameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create an uppercase app name to use for environment variables.
*/}}
{{- define "scdf.envname" -}}
{{- $name := default "data-flow" .Values.appNameOverride -}}
{{- printf "%s_%s" .Release.Name $name | upper | replace "-" "_" | trimSuffix "_" -}}
{{- end -}}

{{/*
Create an uppercase release prefix to use for environment variables.
*/}}
{{- define "scdf.envrelease" -}}
{{- printf "%s" .Release.Name | upper | replace "-" "_" | trimSuffix "_" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "scdf.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "scdf.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "scdf.database.driver" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "org.mariadb.jdbc.Driver" -}}
  {{- else -}}
    {{- .Values.database.driver -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.scheme" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "mysql" -}}
  {{- else -}}
    {{- .Values.database.scheme -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.host" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "${%s_MYSQL_SERVICE_HOST}" (include "scdf.envrelease" . ) -}}
  {{- else -}}
    {{- .Values.database.host -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.port" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "${%s_MYSQL_SERVICE_PORT}" (include "scdf.envrelease" . ) -}}
  {{- else -}}
    {{- .Values.database.port -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.user" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "root" -}}
  {{- else -}}
    {{- .Values.database.user -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.password" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "${mysql-root-password}" -}}
  {{- else -}}
    {{- printf "${database-password}" -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.dataflow" -}}
  {{- if .Values.mysql.enabled -}}
    {{- .Values.mysql.mysqlDatabase -}}
  {{- else -}}
    {{- .Values.database.dataflow -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.database.skipper" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "skipper" -}}
  {{- else -}}
    {{- .Values.database.skipper -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.broker.rabbitmq.host" -}}
  {{- if index .Values "rabbitmq-ha" "enabled" -}}
    {{- printf "%s-rabbitmq-ha" .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else if .Values.rabbitmq.enabled -}}
    {{- printf "${%s_RABBITMQ_SERVICE_HOST}" (include "scdf.envrelease" . ) -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.broker.rabbitmq.port" -}}
  {{- if index .Values "rabbitmq-ha" "enabled" -}}
    {{- index .Values "rabbitmq-ha" "rabbitmqNodePort" -}}
  {{- else if .Values.rabbitmq.enabled -}}
    {{- printf "${%s_RABBITMQ_SERVICE_PORT_AMQP}" (include "scdf.envrelease" . ) -}}
  {{- end -}}
{{- end -}}

{{- define "scdf.broker.rabbitmq.user" -}}
  {{- if index .Values "rabbitmq-ha" "enabled" -}}
    {{ index .Values "rabbitmq-ha" "rabbitmqUsername" }}
  {{- else if .Values.rabbitmq.enabled -}}
    {{ .Values.rabbitmq.rabbitmq.username }}
  {{- end -}}
{{- end -}}
