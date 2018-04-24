{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "grafana.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the LDAP configuration for Grafana
*/}}
{{- define "ldap.toml" -}}
{{- $ldapToml := index .Values.ldap.config }}
# To troubleshoot and get more log info enable ldap debug logging in grafana.ini
# [log]
# filters = ldap:debug
{{ range $server := $ldapToml.servers }}
[[servers]]
# Ldap server host (specify multiple hosts space separated)
host = {{ $server.host | quote }}

# Default port is 389 or 636 if use_ssl = true
port = {{ $server.port | int }}

# Set to true if ldap server supports TLS
use_ssl = {{ default false $server.use_ssl }}

# Set to true if connect ldap server with STARTTLS pattern (create connection in insecure, then upgrade to secure connection with TLS)
start_tls = {{ default false $server.start_tls }}

# set to true if you want to skip ssl cert validation
ssl_skip_verify = {{ default false $server.ssl_skip_verify }}

# set to the path to your root CA certificate or leave unset to use system defaults
{{- if $server.root_ca_cert }}
root_ca_cert = {{ $server.root_ca_cert }}
{{- end }}

# Search user bind dn
bind_dn = {{ $server.bind_dn | quote | default }}

# Search user bind password
# If the password contains # or ; you have to wrap it with triple quotes. Ex """#password;"""
bind_password = {{ $server.bind_password | quote | default }}

# User search filter, for example "(cn=%s)" or "(sAMAccountName=%s)" or "(uid=%s)"
search_filter = {{ $server.search_filter | quote }}

# An array of base dns to search through
search_base_dns = {{ $server.search_base_dns | toJson }}

{{ if $server.group_search_filter }}
## Group search filter, to retrieve the groups of which the user is a member (only set if memberOf attribute is not available)
group_search_filter = {{ $server.group_search_filter | quote }}
{{- end }}

{{ if $server.group_search_base_dns }}
## An array of the base DNs to search through for groups. Typically uses ou=groups
group_search_base_dns = {{ $server.group_search_base_dns | toJson }}
{{- end }}

# Specify names of the ldap attributes your ldap uses
[servers.attributes]
{{ $server.attributes | toToml }}

{{ range $groupMapping := $server.group_mappings }}
# Map ldap groups to grafana org roles
[[servers.group_mappings]]
group_dn = {{ $groupMapping.group_dn | quote }}
org_role = {{ $groupMapping.org_role | quote }}
{{ if $groupMapping.org_id }}
org_id = {{ $groupMapping.org_id | int }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
