{{- define "partials.proxy-init" -}}
args:
- --incoming-proxy-port
- {{.Proxy.Ports.Inbound | quote}}
- --outgoing-proxy-port
- {{.Proxy.Ports.Outbound | quote}}
- --proxy-uid
- {{.Proxy.UID | quote}}
- --inbound-ports-to-ignore
- {{.Proxy.Ports.Control}},{{.Proxy.Ports.Admin}}{{ternary (printf ",%s" .ProxyInit.IgnoreInboundPorts) "" (not (empty .ProxyInit.IgnoreInboundPorts)) }}
{{- if hasPrefix "linkerd-" .Proxy.Component }}
- --outbound-ports-to-ignore
- {{ternary (printf "443,%s" .ProxyInit.IgnoreOutboundPorts) (quote "443") (not (empty .ProxyInit.IgnoreOutboundPorts)) }}
{{- else if .ProxyInit.IgnoreOutboundPorts }}
- --outbound-ports-to-ignore
- {{.ProxyInit.IgnoreOutboundPorts | quote}}
{{- end }}
image: {{.ProxyInit.Image.Name}}:{{.ProxyInit.Image.Version}}
imagePullPolicy: {{.ProxyInit.Image.PullPolicy}}
name: linkerd-init
{{ include "partials.resources" .ProxyInit.Resources }}
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    add:
    - NET_ADMIN
    - NET_RAW
    {{- if .ProxyInit.Capabilities -}}
    {{- if .ProxyInit.Capabilities.Add }}
    {{- toYaml .ProxyInit.Capabilities.Add | trim | nindent 4 }}
    {{- end }}
    {{- if .ProxyInit.Capabilities.Drop -}}
    {{- include "partials.proxy-init.capabilities.drop" .ProxyInit | nindent 4 -}}
    {{- end }}
    {{- end }}
  privileged: false
  readOnlyRootFilesystem: true
  runAsNonRoot: false
  runAsUser: 0
terminationMessagePolicy: FallbackToLogsOnError
{{- if .ProxyInit.SAMountPath }}
volumeMounts:
- mountPath: {{.ProxyInit.SAMountPath.MountPath}}
  name: {{.ProxyInit.SAMountPath.Name}}
  readOnly: {{.ProxyInit.SAMountPath.ReadOnly}}
{{- end -}}
{{- end -}}
