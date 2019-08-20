{{- define "linkerd.proxy.validation" -}}
{{- if .DisableIdentity -}}
{{- fail (printf "Can't disable identity mTLS for %s. Set '.Values.Proxy.DisableIdentity' to 'false'" .Component) -}}
{{- end -}}

{{- if .DisableTap -}}
{{- fail (printf "Can't disable tap for %s. Set '.Values.Proxy.DisableTap' to 'false'" .Component) -}}
{{- end -}}
{{- end -}}
