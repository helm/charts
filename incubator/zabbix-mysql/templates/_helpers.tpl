{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "zabbix.name" -}}
{{- default .Chart.Name .Values.nameOverride.chart | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for zabbix-server-mysql.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zabbix-server-mysql.fullname" -}}
{{- if .Values.fullnameOverride.zabbix_server_mysql -}}
{{- .Values.fullnameOverride.zabbix_server_mysql | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride.Zabbix_server_mysql -}}
{{- printf "%s-%s-%s" .Release.Name $name "server-mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{/*
Create a default fully qualified app name for zabbix-web-nginx-mysql.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zabbix-web-nginx-mysql.fullname" -}}
{{- if .Values.fullnameOverride.zabbix_web_nginx_mysql -}}
{{- .Values.fullnameOverride.zabbix_web_nginx_mysql | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride.zabbix_web_nginx_mysql -}}
{{- printf "%s-%s-%s" .Release.Name $name "web-nginx-mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper zabbix image name
*/}}
{{- define "zabbix_server_mysql.image" -}}
{{- $registryName := .Values.image.zabbix_server_mysql.registry -}}
{{- $repositoryName := .Values.image.zabbix_server_mysql.repository -}}
{{- $tag := .Values.image.zabbix_server_mysql.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper zabbix_web_nginx_mysql image name
*/}}
{{- define "zabbix_web_nginx_mysql.image" -}}
{{- $registryName := .Values.image.zabbix_web_nginx_mysql.registry -}}
{{- $repositoryName := .Values.image.zabbix_web_nginx_mysql.repository -}}
{{- $tag := .Values.image.zabbix_web_nginx_mysql.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper zabbix_agent image name
*/}}
{{- define "zabbix_agent.image" -}}
{{- $registryName := .Values.image.zabbix_agent.registry -}}
{{- $repositoryName := .Values.image.zabbix_agent.repository -}}
{{- $tag := .Values.image.zabbix_agent.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zabbix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{/*
Return  the proper Storage Class
*/}}
{{- define "zabbix.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "zabbix-web.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}
