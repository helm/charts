{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "cockroachdb.networkPolicy.apiVersion" -}}
{{- if and (ge .Capabilities.KubeVersion.Minor "4") (le .Capabilities.KubeVersion.Minor "6") -}}
{{- print "extensions/v1beta1" -}}
{{- else if ge .Capabilities.KubeVersion.Minor "7" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cockroachdb.serviceAccountName" -}}
{{- if .Values.Secure.ServiceAccount.Create -}}
    {{ default (printf "%s-%s" .Release.Name .Values.Name | trunc 56) .Values.Secure.ServiceAccount.Name }}
{{- else -}}
    {{ default "default" .Values.Secure.ServiceAccount.Name }}
{{- end -}}
{{- end -}}
