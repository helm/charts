{{- define "partials.proxy.capabilities" -}}
capabilities:
  {{- if .Capabilities.Add }}
  add:
  {{- toYaml .Capabilities.Add | trim | nindent 4 }}
  {{- end }}
  {{- if .Capabilities.Drop }}
  drop:
  {{- toYaml .Capabilities.Drop | trim | nindent 4 }}
  {{- end }}
{{- end -}}

{{- define "partials.proxy-init.capabilities.drop" -}}
drop:
{{ toYaml .Capabilities.Drop | trim }}
{{- end -}}
