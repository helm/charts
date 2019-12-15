{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "kong.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.dblessConfig.fullname" -}}
{{- $name := default "kong-custom-dbless-config" .Values.dblessConfig.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kong.serviceAccountName" -}}
{{- if .Values.ingressController.serviceAccount.create -}}
    {{ default (include "kong.fullname" .) .Values.ingressController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ingressController.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the KONG_PROXY_LISTEN value string
*/}}
{{- define "kong.kongProxyListenValue" -}}

{{- if and .Values.proxy.http.enabled .Values.proxy.tls.enabled -}}
   0.0.0.0:{{ .Values.proxy.http.containerPort }},0.0.0.0:{{ .Values.proxy.tls.containerPort }} ssl
{{- else -}}
{{- if .Values.proxy.http.enabled -}}
   0.0.0.0:{{ .Values.proxy.http.containerPort }}
{{- end -}}
{{- if .Values.proxy.tls.enabled -}}
   0.0.0.0:{{ .Values.proxy.tls.containerPort }} ssl
{{- end -}}
{{- end -}}

{{- end }}

{{/*
Create the KONG_ADMIN_GUI_LISTEN value string
*/}}
{{- define "kong.kongManagerListenValue" -}}

{{- if and .Values.manager.http.enabled .Values.manager.tls.enabled -}}
   0.0.0.0:{{ .Values.manager.http.containerPort }},0.0.0.0:{{ .Values.manager.tls.containerPort }} ssl
{{- else -}}
{{- if .Values.manager.http.enabled -}}
   0.0.0.0:{{ .Values.manager.http.containerPort }}
{{- end -}}
{{- if .Values.manager.tls.enabled -}}
   0.0.0.0:{{ .Values.manager.tls.containerPort }} ssl
{{- end -}}
{{- end -}}

{{- end }}

{{/*
Create the KONG_PORTAL_GUI_LISTEN value string
*/}}
{{- define "kong.kongPortalListenValue" -}}

{{- if and .Values.portal.http.enabled .Values.portal.tls.enabled -}}
   0.0.0.0:{{ .Values.portal.http.containerPort }},0.0.0.0:{{ .Values.portal.tls.containerPort }} ssl
{{- else -}}
{{- if .Values.portal.http.enabled -}}
   0.0.0.0:{{ .Values.portal.http.containerPort }}
{{- end -}}
{{- if .Values.portal.tls.enabled -}}
   0.0.0.0:{{ .Values.portal.tls.containerPort }} ssl
{{- end -}}
{{- end -}}

{{- end }}

{{/*
Create the KONG_PORTAL_API_LISTEN value string
*/}}
{{- define "kong.kongPortalApiListenValue" -}}

{{- if and .Values.portalapi.http.enabled .Values.portalapi.tls.enabled -}}
   0.0.0.0:{{ .Values.portalapi.http.containerPort }},0.0.0.0:{{ .Values.portalapi.tls.containerPort }} ssl
{{- else -}}
{{- if .Values.portalapi.http.enabled -}}
   0.0.0.0:{{ .Values.portalapi.http.containerPort }}
{{- end -}}
{{- if .Values.portalapi.tls.enabled -}}
   0.0.0.0:{{ .Values.portalapi.tls.containerPort }} ssl
{{- end -}}
{{- end -}}

{{- end }}

{{/*
Create the ingress servicePort value string
*/}}

{{- define "kong.ingress.servicePort" -}}
{{- if .tls.enabled -}}
   {{ .tls.servicePort }}
{{- else -}}
   {{ .http.servicePort }}
{{- end -}}
{{- end -}}

{{/*
Generate an appropriate external URL from a Kong service's ingress configuration
Strips trailing slashes from the path. Manager at least does not handle these
intelligently and will append its own slash regardless, and the admin API cannot handle
the extra slash.
*/}}

{{- define "kong.ingress.serviceUrl" -}}
{{- if .tls -}}
    https://{{ .hostname }}{{ .path | trimSuffix "/" }}
{{- else -}}
    http://{{ .hostname }}{{ .path | trimSuffix "/" }}
{{- end -}}
{{- end -}}

{{/*
The name of the service used for the ingress controller's validation webhook
*/}}

{{- define "kong.service.validationWebhook" -}}
{{ include "kong.fullname" . }}-validation-webhook
{{- end -}}

{{- define "kong.env" -}}
{{- range $key, $val := .Values.env }}
- name: KONG_{{ $key | upper}}
{{- $valueType := printf "%T" $val -}}
{{ if eq $valueType "map[string]interface {}" }}
{{ toYaml $val | indent 2 -}}
{{- else }}
  value: {{ $val | quote -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "kong.volumes" -}}
{{- range .Values.plugins.configMaps }}
- name: kong-plugin-{{ .pluginName }}
  configMap:
    name: {{ .name }}
{{- end }}
{{- range .Values.plugins.secrets }}
- name: kong-plugin-{{ .pluginName }}
  secret:
    secretName: {{ .name }}
{{- end }}
- name: custom-nginx-template-volume
  configMap:
    name: {{ template "kong.fullname" . }}-default-custom-server-blocks
{{- if (and (not .Values.ingressController.enabled) (eq .Values.env.database "off")) }}
- name: kong-custom-dbless-config-volume
  configMap:
    {{- if .Values.dblessConfig.configMap }}
    name: {{ .Values.dblessConfig.configMap }}
    {{- else }}
    name: {{ template "kong.dblessConfig.fullname" . }}
    {{- end }}
{{- end }}
{{- if .Values.ingressController.admissionWebhook.enabled }}
- name: webhook-cert
  secret:
    secretName: {{ template "kong.fullname" . }}-validation-webhook-keypair
{{- end }}
{{- range $secretVolume := .Values.secretVolumes }}
- name: {{ . }}
  secret:
    secretName: {{ . }}
{{- end }}
{{- end -}}

{{- define "kong.volumeMounts" -}}
- name: custom-nginx-template-volume
  mountPath: /kong
{{- if (and (not .Values.ingressController.enabled) (eq .Values.env.database "off")) }}
- name: kong-custom-dbless-config-volume
  mountPath: /kong_dbless/
{{- end }}
{{- range .Values.secretVolumes }}
- name:  {{ . }}
  mountPath: /etc/secrets/{{ . }}
{{- end }}
{{- range .Values.plugins.configMaps }}
- name:  kong-plugin-{{ .pluginName }}
  mountPath: /opt/kong/plugins/{{ .pluginName }}
{{- end }}
{{- range .Values.plugins.secrets }}
- name:  kong-plugin-{{ .pluginName }}
  mountPath: /opt/kong/plugins/{{ .pluginName }}
{{- end }}
{{- end -}}

{{- define "kong.plugins" -}}
{{ $myList := list "bundled" }}
{{- range .Values.plugins.configMaps -}}
{{- $myList = append $myList .pluginName -}}
{{- end -}}
{{- range .Values.plugins.secrets -}}
  {{ $myList = append $myList .pluginName -}}
{{- end }}
{{- $myList | join "," -}}
{{- end -}}

{{- define "kong.wait-for-db" -}}
- name: wait-for-db
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  env:
  {{- if .Values.enterprise.enabled }}
  {{- include "kong.license" . | nindent 2 }}
  {{- end }}
  {{- if .Values.postgresql.enabled }}
  - name: KONG_PG_HOST
    value: {{ template "kong.postgresql.fullname" . }}
  - name: KONG_PG_PORT
    value: "{{ .Values.postgresql.service.port }}"
  - name: KONG_LUA_PACKAGE_PATH
    value: "/opt/?.lua;;"
  - name: KONG_PG_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "kong.postgresql.fullname" . }}
        key: postgresql-password
  {{- end }}
  {{- include "kong.env" .  | nindent 2 }}
  command: [ "/bin/sh", "-c", "until kong start; do echo 'waiting for db'; sleep 1; done; kong stop" ]
  volumeMounts:
  {{- include "kong.volumeMounts" . | nindent 4 }}
{{- end -}}

{{- define "kong.controller-container" -}}
- name: ingress-controller
  args:
  - /kong-ingress-controller
  # Service from were we extract the IP address/es to use in Ingress status
  - --publish-service={{ .Release.Namespace }}/{{ template "kong.fullname" . }}-proxy
  # Set the ingress class
  - --ingress-class={{ .Values.ingressController.ingressClass }}
  - --election-id=kong-ingress-controller-leader-{{ .Values.ingressController.ingressClass }}
  # the kong URL points to the kong admin api server
  {{- if .Values.admin.useTLS }}
  - --kong-url=https://localhost:{{ .Values.admin.containerPort }}
  - --admin-tls-skip-verify # TODO make this configurable
  {{- else }}
  - --kong-url=http://localhost:{{ .Values.admin.containerPort }}
  {{- end }}
  {{- if .Values.ingressController.admissionWebhook.enabled }}
  - --admission-webhook-listen=0.0.0.0:{{ .Values.ingressController.admissionWebhook.port }}
  {{- end }}
  env:
  - name: POD_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.name
  - name: POD_NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  image: "{{ .Values.ingressController.image.repository }}:{{ .Values.ingressController.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  readinessProbe:
{{ toYaml .Values.ingressController.readinessProbe | indent 4 }}
  livenessProbe:
{{ toYaml .Values.ingressController.livenessProbe | indent 4 }}
  resources:
{{ toYaml .Values.ingressController.resources | indent 4 }}
{{- if .Values.ingressController.admissionWebhook.enabled }}
  volumeMounts:
  - name: webhook-cert
    mountPath: /admission-webhook
    readOnly: true
{{- end }}
{{- end -}}

{{/*
Retrieve Kong Enterprise license from a secret and make it available in env vars
*/}}
{{- define "kong.license" -}}
- name: KONG_LICENSE_DATA
  valueFrom:
    secretKeyRef:
      name: {{ .Values.enterprise.license_secret }}
      key: license
{{- end -}}
