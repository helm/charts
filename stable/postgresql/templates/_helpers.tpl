{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.master.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := default (printf "%s-%s" .Release.Name $name) .Values.fullnameOverride -}}
{{- if .Values.replication.enabled -}}
{{- printf "%s-%s" $fullname "master" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "postgresql.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"extensions/v1beta1"
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"networking.k8s.io/v1"
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return PostgreSQL postgres user password
*/}}
{{- define "postgresql.postgres.password" -}}
{{- if .Values.global.postgresql.postgresqlPostgresPassword }}
    {{- .Values.global.postgresql.postgresqlPostgresPassword -}}
{{- else if .Values.postgresqlPostgresPassword -}}
    {{- .Values.postgresqlPostgresPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL password
*/}}
{{- define "postgresql.password" -}}
{{- if .Values.global.postgresql.postgresqlPassword }}
    {{- .Values.global.postgresql.postgresqlPassword -}}
{{- else if .Values.postgresqlPassword -}}
    {{- .Values.postgresqlPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL replication password
*/}}
{{- define "postgresql.replication.password" -}}
{{- if .Values.global.postgresql.replicationPassword }}
    {{- .Values.global.postgresql.replicationPassword -}}
{{- else if .Values.replication.password -}}
    {{- .Values.replication.password -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL username
*/}}
{{- define "postgresql.username" -}}
{{- if .Values.global.postgresql.postgresqlUsername }}
    {{- .Values.global.postgresql.postgresqlUsername -}}
{{- else -}}
    {{- .Values.postgresqlUsername -}}
{{- end -}}
{{- end -}}


{{/*
Return PostgreSQL replication username
*/}}
{{- define "postgresql.replication.username" -}}
{{- if .Values.global.postgresql.replicationUser }}
    {{- .Values.global.postgresql.replicationUser -}}
{{- else -}}
    {{- .Values.replication.user -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL port
*/}}
{{- define "postgresql.port" -}}
{{- if .Values.global.postgresql.servicePort }}
    {{- .Values.global.postgresql.servicePort -}}
{{- else -}}
    {{- .Values.service.port -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL created database
*/}}
{{- define "postgresql.database" -}}
{{- if .Values.global.postgresql.postgresqlDatabase }}
    {{- .Values.global.postgresql.postgresqlDatabase -}}
{{- else if .Values.postgresqlDatabase -}}
    {{- .Values.postgresqlDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "postgresql.secretName" -}}
{{- if .Values.global.postgresql.existingSecret }}
    {{- printf "%s" .Values.global.postgresql.existingSecret -}}
{{- else if .Values.existingSecret -}}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "postgresql.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "postgresql.createSecret" -}}
{{- if .Values.global.postgresql.existingSecret }}
{{- else if .Values.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration ConfigMap name.
*/}}
{{- define "postgresql.configurationCM" -}}
{{- if .Values.configurationConfigMap -}}
{{- printf "%s" (tpl .Values.configurationConfigMap $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "postgresql.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the extended configuration ConfigMap name.
*/}}
{{- define "postgresql.extendedConfigurationCM" -}}
{{- if .Values.extendedConfConfigMap -}}
{{- printf "%s" (tpl .Values.extendedConfConfigMap $) -}}
{{- else -}}
{{- printf "%s-extended-configuration" (include "postgresql.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "postgresql.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
{{- printf "%s" (tpl .Values.initdbScriptsConfigMap $) -}}
{{- else -}}
{{- printf "%s-init-scripts" (include "postgresql.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "postgresql.initdbScriptsSecret" -}}
{{- printf "%s" (tpl .Values.initdbScriptsSecret $) -}}
{{- end -}}

{{/*
Get the metrics ConfigMap name.
*/}}
{{- define "postgresql.metricsCM" -}}
{{- printf "%s-metrics" (include "postgresql.fullname" .) -}}
{{- end -}}


{{/*
Get the readiness probe command
*/}}
{{- define "postgresql.readinessProbeCommand" -}}
- |
{{- if (include "postgresql.database" .) }}
  exec pg_isready -U {{ include "postgresql.username" . | quote }} -d {{ (include "postgresql.database" .) | quote }} -h 127.0.0.1 -p {{ template "postgresql.port" . }}
{{- else }}
  exec pg_isready -U {{ include "postgresql.username" . | quote }} -h 127.0.0.1 -p {{ template "postgresql.port" . }}
{{- end }}
{{- if contains "bitnami/" (include "postgresql.registryImage" (dict "image" .Values.images.postgresql "values" .Values "name" "postgresql")) }}
  [ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]
{{- end -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "postgresql.storageClass" -}}
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
Renders a value that contains template.
Usage:
{{ include "postgresql.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "postgresql.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "postgresql.statefulset.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "postgresql.validateValues" -}}
{{- $messages := list -}}
{{- $messages = append $messages (include "postgresql.validateValues.ldapConfigurationMethod" .) -}}
{{- $messages = without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Postgresql - If ldap.url is used then you don't need the other settings for ldap
*/}}
{{- define "postgresql.validateValues.ldapConfigurationMethod" -}}
{{- if and .Values.ldap.enabled (and (not (empty .Values.ldap.url)) (not (empty .Values.ldap.server))) }}
postgresql: ldap.url, ldap.server
    You cannot set both `ldap.url` and `ldap.server` at the same time.
    Please provide a unique way to configure LDAP.
    More info at https://www.postgresql.org/docs/current/auth-ldap.html
{{- end -}}
{{- end -}}

{{/*
Create a registry image reference for use in a spec.
Includes the `image` and `imagePullPolicy` keys.
*/}}
{{- define "postgresql.registryImage" -}}
image: {{ include "postgresql.imageReference" . }}
{{ include "postgresql.imagePullPolicy" . }}
{{- end -}}

{{/*
The most complete image reference, including the
registry address, repository, tag and digest when available.
*/}}
{{- define "postgresql.imageReference" -}}
{{- if .values.image -}}
{{ include "postgresql.deprecatedImageReference" . }}
{{- else -}}
{{- $registry := include "postgresql.imageRegistry" . -}}
{{- $namespace := include "postgresql.imageNamespace" . -}}
{{- printf "%s/%s/%s" $registry $namespace .image.name -}}
{{- if .image.tag -}}
{{- printf ":%s" .image.tag -}}
{{- end -}}
{{- if .image.digest -}}
{{- printf "@%s" .image.digest -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.deprecatedImageReference" -}}
{{- $image := dict -}}
{{- if eq .name "postgresql" -}}
{{- $image = .values.image -}}
{{- else if eq .name "volumePermissions" -}}
{{- $image = .values.volumePermissions.image -}}
{{- else if eq .name "metrics" -}}
{{- $image = .values.metrics.image -}}
{{- end -}}
{{- if $image.registry -}}
{{- printf "%s/" $image.registry -}}
{{- end -}}
{{- printf "%s" $image.repository -}}
{{- if $image.tag -}}
{{- printf ":%s" $image.tag }}
{{- end -}}
{{- if $image.digest -}}
{{- printf "@%s" $image.digest -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.imageRegistry" -}}
{{- if or (and .image.useOriginalRegistry (empty .image.registry)) (and .values.useOriginalRegistry (empty .values.imageRegistry)) -}}
{{- include "postgresql.originalImageRegistry" . -}}
{{- else -}}
{{- include "postgresql.customImageRegistry" . -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.originalImageRegistry" -}}
{{- printf (coalesce .image.originalRegistry .values.originalImageRegistry "docker.io") -}}
{{- end -}}

{{- define "postgresql.customImageRegistry" -}}
{{- printf (coalesce .image.registry .values.imageRegistry .values.global.imageRegistry (include "postgresql.originalImageRegistry" .)) -}}
{{- end -}}

{{- define "postgresql.imageNamespace" -}}
{{- if or (and .image.useOriginalNamespace (empty .image.namespace)) (and .values.useOriginalNamespace (empty .values.imageNamespace)) -}}
{{- include "postgresql.originalImageNamespace" . -}}
{{- else -}}
{{- include "postgresql.customImageNamespace" . -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.originalImageNamespace" -}}
{{- printf (coalesce .image.originalNamespace .values.originalImageNamespace "library") -}}
{{- end -}}

{{- define "postgresql.customImageNamespace" -}}
{{- printf (coalesce .image.namespace .values.imageNamespace .values.global.imageNamespace (include "postgresql.originalImageNamespace" .)) -}}
{{- end -}}

{{/*
Specify the image pull policy
*/}}
{{- define "postgresql.imagePullPolicy" -}}
{{ $policy := coalesce .image.pullPolicy .values.global.imagePullPolicy }}
{{- if $policy -}}
imagePullPolicy: "{{ printf "%s" $policy -}}"
{{- end -}}
{{- end -}}

{{/*
Use the image pull secrets. All of the specified secrets will be used
*/}}
{{- define "postgresql.imagePullSecrets" -}}
{{- $secrets := .Values.global.imagePullSecrets -}}
{{- range $_, $image := .Values.images -}}
{{- range $_, $s := $image.pullSecrets -}}
{{- if not $secrets -}}
{{- $secrets = list $s -}}
{{- else -}}
{{- $secrets = append $secrets $s -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets }}
- name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}