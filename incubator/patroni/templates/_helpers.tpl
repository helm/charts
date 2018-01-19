
{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "patroni.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.Name | trunc 63 -}}
{{- end -}}

{{/*
    generates a yaml secretKeyRef env structure and expects the folowing structure as input (dict):
    ```
    SecretKeyRefs:
        <container-env-var-name>:
            name: <secret resource name> (optional, defaults to patroni.fullname as secret resource name)
            key: <secret resource entry>
    ```
*/}}
{{- define "patroni.secretKeyRefs" -}}
{{- $global := . -}}
{{- range $k, $v := .Values.SecretKeyRefs }}
- name: {{ $k | upper | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ default (include "patroni.fullname" $global) $v.name | quote }}
      key: {{ $v.key | quote }}
{{- end -}}
{{- end -}}
