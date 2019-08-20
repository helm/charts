{{- define "partials.resources" -}}
resources:
  {{- if or .CPU.Limit .Memory.Limit }}
  limits:
    {{- with .CPU.Limit }}
    cpu: {{. | quote}}
    {{- end }}
    {{- with .Memory.Limit }}
    memory: {{. | quote}}
    {{- end }}
  {{- end }}
  {{- if or .CPU.Request .Memory.Request }}
  requests:
    {{- with .CPU.Request }}
    cpu: {{. | quote}}
    {{- end }}
    {{- with .Memory.Request }}
    memory: {{. | quote}}
    {{- end }}
  {{- end }}
{{- end }}
