{{- define "common.envvar.value" -}}
  {{- $name := index . 0 -}}
  {{- $value := index . 1 -}}

  name: {{ $name }}
  value: {{ default "" $value | quote }}
{{- end -}}

{{- define "common.envvar.secret" -}}
  {{- $name := index . 0 -}}
  {{- $secretName := index . 1 -}}
  {{- $secretKey := index . 2 -}}

  name: {{ $name }}
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: {{ $secretKey }}
{{- end -}}
