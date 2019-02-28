{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "stolon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stolon.fullname" -}}
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
{{- define "stolon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/* Create the name of the service account to use */}}
{{- define "stolon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "stolon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
pg_basebackup password file location
*/}}
{{- define "standby.passwordfile.path" -}}
{{- printf "/home/stolon/standbypassword" -}}
{{- end -}}

{{/*
pg_basebackup password file content
*/}}
{{- define "standby.passwordfile.content" -}}
{{- printf "%s:%d:*:%s:%s" .Values.standby.remoteHost 5432 .Values.replicationUsername .Values.replicationPassword | b64enc -}}
{{- end -}}


{{/*
Get cluster specification
*/}}
{{- define "cluster.specification.json" -}}
{{- $clusterSpecification := .Values.clusterSpec -}}
{{- if .Values.standby.enabled -}}
    {{- $remoteHost := required "Provide remote host address" .Values.standby.remoteHost -}}
    {{- $primarySlotName := required "Provide primary replication slot name" .Values.standby.primarySlotName -}}
    {{- $remoteReplUser := required "Provide remote replication username" .Values.replicationUsername -}}
    {{- $remoteReplPassword := required "Provide remote replication password" .Values.replicationPassword -}}
    {{- $passwordFilePath := include "standby.passwordfile.path" . -}}
    {{- $standBySpecAsJson := printf "{\"initMode\":\"pitr\",\"pitrConfig\":{\"dataRestoreCommand\":\"PGPASSFILE=%s pg_basebackup -D %s -h  %s -p 5432 -U %s\"},\"role\":\"standby\",\"standbyConfig\":{\"standbySettings\":{\"primaryConnInfo\":\"host=%s port=5432 user=%s password=%s sslmode=disable\", \"primarySlotName\":\"%s\" }}}" $passwordFilePath "%d" $remoteHost $remoteReplUser $remoteHost $remoteReplUser $remoteReplPassword $primarySlotName -}}
    {{- if $clusterSpecification -}}
        {{- $extraSpecAsMap := $clusterSpecification | toJson | fromJson -}}
        {{- $standBySpecAsMap := fromJson $standBySpecAsJson -}}
        {{- merge $standBySpecAsMap $extraSpecAsMap | toJson -}}
    {{- else -}}
        {{- $standBySpecAsJson -}}
    {{- end -}}
{{- else if $clusterSpecification -}}
    {{- toJson $clusterSpecification -}}
{{- end -}}
{{- end -}}

{{/*
Get cluster specification on initializations
*/}}
{{- define "cluster.init-specification.json" -}}
    {{- $initModeSpecMap := fromJson "{\"initMode\":\"new\"}" -}}
    {{- $clusterSpecification := include "cluster.specification.json" . -}}
    {{- if $clusterSpecification -}}
        {{- $clusterSpecificationMap := fromJson $clusterSpecification -}}
        {{- merge $clusterSpecificationMap $initModeSpecMap | toJson -}}
    {{- else -}}
        {{- toJson $initModeSpecMap -}}
    {{- end -}}
{{- end -}}