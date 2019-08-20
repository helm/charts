{{ define "partials.proxy" -}}
env:
- name: LINKERD2_PROXY_LOG
  value: {{.Proxy.LogLevel}}
- name: LINKERD2_PROXY_DESTINATION_SVC_ADDR
  value: {{ternary "localhost.:8086" (printf "linkerd-destination.%s.svc.%s:8086" .Namespace .ClusterDomain) (eq .Proxy.Component "linkerd-controller")}}
- name: LINKERD2_PROXY_CONTROL_LISTEN_ADDR
  value: 0.0.0.0:{{.Proxy.Ports.Control}}
- name: LINKERD2_PROXY_ADMIN_LISTEN_ADDR
  value: 0.0.0.0:{{.Proxy.Ports.Admin}}
- name: LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR
  value: 127.0.0.1:{{.Proxy.Ports.Outbound}}
- name: LINKERD2_PROXY_INBOUND_LISTEN_ADDR
  value: 0.0.0.0:{{.Proxy.Ports.Inbound}}
- name: LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES
  {{- $internalProfileSuffix := printf "svc.%s." .ClusterDomain }}
  value: {{ternary "." $internalProfileSuffix .Proxy.EnableExternalProfiles}}
- name: LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE
  value: 10000ms
- name: LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE
  value: 10000ms
- name: _pod_ns
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: LINKERD2_PROXY_DESTINATION_CONTEXT
  value: ns:$(_pod_ns)
{{ if eq .Proxy.Component "linkerd-prometheus" -}}
- name: LINKERD2_PROXY_OUTBOUND_ROUTER_CAPACITY
  value: "10000"
{{ end -}}
{{ if .Proxy.DisableIdentity -}}
- name: LINKERD2_PROXY_IDENTITY_DISABLED
  value: disabled
{{ else -}}
- name: LINKERD2_PROXY_IDENTITY_DIR
  value: /var/run/linkerd/identity/end-entity
- name: LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS
  value: |
  {{- required "Please provide the identity trust anchors" .Identity.TrustAnchorsPEM | trim | nindent 4 }}
- name: LINKERD2_PROXY_IDENTITY_TOKEN_FILE
  value: /var/run/secrets/kubernetes.io/serviceaccount/token
- name: LINKERD2_PROXY_IDENTITY_SVC_ADDR
  {{- $identitySvcAddr := printf "linkerd-identity.%s.svc.%s:8080" .Namespace .ClusterDomain }}
  value: {{ternary "localhost.:8080" $identitySvcAddr (eq .Proxy.Component "linkerd-identity")}}
- name: _pod_sa
  valueFrom:
    fieldRef:
      fieldPath: spec.serviceAccountName
- name: _l5d_ns
  value: {{.Namespace}}
- name: _l5d_trustdomain
  value: {{.Identity.TrustDomain}}
- name: LINKERD2_PROXY_IDENTITY_LOCAL_NAME
  value: $(_pod_sa).$(_pod_ns).serviceaccount.identity.$(_l5d_ns).$(_l5d_trustdomain)
- name: LINKERD2_PROXY_IDENTITY_SVC_NAME
  value: linkerd-identity.$(_l5d_ns).serviceaccount.identity.$(_l5d_ns).$(_l5d_trustdomain)
- name: LINKERD2_PROXY_DESTINATION_SVC_NAME
  value: linkerd-controller.$(_l5d_ns).serviceaccount.identity.$(_l5d_ns).$(_l5d_trustdomain)
{{ end -}}
{{ if .Proxy.DisableTap -}}
- name: LINKERD2_PROXY_TAP_DISABLED
  value: "true"
{{ else if not .Proxy.DisableIdentity -}}
- name: LINKERD2_PROXY_TAP_SVC_NAME
  value: linkerd-tap.$(_l5d_ns).serviceaccount.identity.$(_l5d_ns).$(_l5d_trustdomain)
{{ end -}}
image: {{.Proxy.Image.Name}}:{{.Proxy.Image.Version}}
imagePullPolicy: {{.Proxy.Image.PullPolicy}}
livenessProbe:
  httpGet:
    path: /metrics
    port: {{.Proxy.Ports.Admin}}
  initialDelaySeconds: 10
name: linkerd-proxy
ports:
- containerPort: {{.Proxy.Ports.Inbound}}
  name: linkerd-proxy
- containerPort: {{.Proxy.Ports.Admin}}
  name: linkerd-admin
readinessProbe:
  httpGet:
    path: /ready
    port: {{.Proxy.Ports.Admin}}
  initialDelaySeconds: 2
{{- if .Proxy.Resources }}
{{ include "partials.resources" .Proxy.Resources }}
{{- end }}
securityContext:
  allowPrivilegeEscalation: false
  {{- if .Proxy.Capabilities -}}
  {{- include "partials.proxy.capabilities" .Proxy | nindent 2 -}}
  {{- end }}
  readOnlyRootFilesystem: true
  runAsUser: {{.Proxy.UID}}
terminationMessagePolicy: FallbackToLogsOnError
{{- if or (not .Proxy.DisableIdentity) (.Proxy.SAMountPath) }}
volumeMounts:
{{- if not .Proxy.DisableIdentity }}
- mountPath: /var/run/linkerd/identity/end-entity
  name: linkerd-identity-end-entity
{{- end -}}
{{- if .Proxy.SAMountPath }}
- mountPath: {{.Proxy.SAMountPath.MountPath}}
  name: {{.Proxy.SAMountPath.Name}}
  readOnly: {{.Proxy.SAMountPath.ReadOnly}}
{{- end -}}
{{- end -}}
{{- end }}
