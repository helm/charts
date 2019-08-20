{{- define "partials.proxy.annotations" -}}
linkerd.io/identity-mode: {{ternary "default" "disabled" (not .DisableIdentity)}}
linkerd.io/proxy-version: {{.Image.Version}}
{{- end -}}

{{- define "partials.proxy.labels" -}}
linkerd.io/proxy-{{.WorkloadKind}}: {{.Component}}
{{- end -}}
