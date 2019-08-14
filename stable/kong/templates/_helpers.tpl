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

{{- define "kong.cassandra.fullname" -}}
{{- $name := default "cassandra" .Values.cassandra.nameOverride -}}
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
    {{ default "default" .Values.serviceAccount.name }}
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
  - name: KONG_PG_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "kong.postgresql.fullname" . }}
        key: postgresql-password
  {{- end }}
  {{- if .Values.cassandra.enabled }}
  - name: KONG_CASSANDRA_CONTACT_POINTS
    value: {{ template "kong.cassandra.fullname" . }}
  {{- end }}
  {{- include "kong.env" .  | nindent 2 }}
  command: [ "/bin/sh", "-c", "until kong start; do echo 'waiting for db'; sleep 1; done; kong stop" ]
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
  livenessProbe:
    failureThreshold: 3
    httpGet:
      path: /healthz
      port: 10254
      scheme: HTTP
    initialDelaySeconds: 30
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  readinessProbe:
    failureThreshold: 3
    httpGet:
      path: /healthz
      port: 10254
      scheme: HTTP
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  resources:
{{ toYaml .Values.ingressController.resources | indent 10 }}
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
