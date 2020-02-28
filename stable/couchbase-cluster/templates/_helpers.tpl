{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "couchbase-cluster.name" -}}
{{- default .Chart.Name .Values.couchbaseCluster.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "couchbase-cluster.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "couchbase-cluster.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "couchbase-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the username of the Admin user.
TODO: Auto generate when there is a better mechanism for upgrading secrets
      https://github.com/pulumi/pulumi-kubernetes/issues/205
*/}}
{{- define "couchbase-cluster.username" -}}
  {{ .Values.couchbaseCluster.username | b64enc | quote }}
{{- end -}}

{{/*
Create the password of the Admin user.
TODO: Auto generate when there is a better mechanism for upgrading secrets
      https://github.com/pulumi/pulumi-kubernetes/issues/205
*/}}
{{- define "couchbase-cluster.password" -}}
  {{ .Values.couchbaseCluster.password | b64enc | quote }}
{{- end -}}


{{/*
Create secret for couchbase cluster.
*/}}
{{- define "couchbase-cluster.secret.name" -}}
{{- default (include "couchbase-cluster.fullname" .) .Values.couchbaseCluster.authSecretOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate cluster name from chart name or use user value
*/}}
{{- define "couchbase-cluster.clustername" -}}
  {{ default (include "couchbase-cluster.fullname" .) .Values.couchbaseCluster.name }}
{{- end -}}

{{/*
Name of tls operator secret
*/}}
{{- define  "couchbase-cluster.secret.tls-operator" -}}
{{- $fullname := printf "%s-operator-tls" (include "couchbase-cluster.fullname" .) -}}
{{- default $fullname .Values.couchbaseTLS.ServerSecret | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of tls server secret
*/}}
{{- define  "couchbase-cluster.secret.tls-server" -}}
{{- $fullname := printf "%s-server-tls" (include "couchbase-cluster.fullname" .) -}}
{{- default $fullname .Values.couchbaseTLS.ServerSecret | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate certificates for couchbase-cluster
*/}}
{{- define "couchbase-cluster.gen-certs" -}}
{{- $expiration := (.Values.couchbaseTLS.expiration | int) -}}
{{- if (or (empty .Values.couchbaseTLS.cert) (empty .Values.couchbaseTLS.key)) -}}
{{- $ca :=  genCA "couchbase-cluster-ca" $expiration -}}
{{- template "couchbase-cluster.gen-client-tls" (dict "RootScope" . "CA" $ca) -}}
{{- else -}}
{{- $ca :=  buildCustomCert (.Values.couchbaseTLS.cert | b64enc) (.Values.couchbaseTLS.key | b64enc) -}}
{{- template "couchbase-cluster.gen-client-tls" (dict "RootScope" . "CA" $ca) -}}
{{- end -}}
{{- end -}}

{{/*
Generate client key and cert from CA
*/}}
{{- define "couchbase-cluster.gen-client-tls" -}}
{{- $clustername := (include "couchbase-cluster.clustername" .RootScope) -}}
{{- $altNames :=  list (printf "*.%s.%s.svc" $clustername .RootScope.Release.Namespace) -}}
{{- if .RootScope.Values.couchbaseCluster.dns -}}
{{- $extendedAltNames := append $altNames (printf "*.%s.%s" $clustername .RootScope.Values.couchbaseCluster.dns.domain) -}}
{{- template "couchbase-cluster.internal.gen-client-tls" (dict "RootScope" .RootScope "CA" .CA "AltNames" $extendedAltNames) -}}
{{- else -}}
{{- template "couchbase-cluster.internal.gen-client-tls" (dict "RootScope" .RootScope "CA" .CA "AltNames" $altNames) -}}
{{- end -}}
{{- end -}}

{{/*
Generate client key and cert from CA and altNames
*/}}
{{- define "couchbase-cluster.internal.gen-client-tls" -}}
{{- $expiration := (.RootScope.Values.couchbaseTLS.expiration | int) -}}
{{- $cert := genSignedCert ( include "couchbase-cluster.fullname" .RootScope) nil .AltNames $expiration .CA -}}
{{- $clientCert := default $cert.Cert .RootScope.Values.couchbaseTLS.operatorSecret.cert | b64enc -}}
{{- $clientKey := default $cert.Key .RootScope.Values.couchbaseTLS.operatorSecret.key | b64enc -}}
caCert: {{ .CA.Cert | b64enc }}
clientCert: {{ $clientCert }}
clientKey: {{ $clientKey }}
{{- end -}}
