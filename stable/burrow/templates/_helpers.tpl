{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "burrow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "burrow.fullname" -}}
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
{{- define "burrow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Formulate the how the seeds feed is populated.
*/}}
{{- define "burrow.seeds" -}}
{{- if (and .Values.RPC.Peer.ingress.enabled (not (eq (len .Values.RPC.Peer.ingress.hosts) 0))) -}}
{{- $host := index .Values.RPC.Peer.ingress.hosts 0 -}}
{{- range (until (sub $.Values.chain.nodes 1 | int)) -}}
{{- $addr := (index $.Values.validatorAddresses ( print "Validator_" . )).NodeAddress | lower -}}
{{- $node := printf "%03d" . -}}
tcp://{{ $addr }}@{{ $node }}.{{ $host }}:{{ $.Values.config.Tendermint.ListenPort }},
{{- end -}}
{{- $addr := (index $.Values.validatorAddresses ( print "Validator_" (sub .Values.chain.nodes 1))).NodeAddress | lower -}}
{{- $node := sub .Values.chain.nodes 1 | printf "%03d" -}}
tcp://{{ $addr }}@{{ $node }}.{{ $host }}:{{ $.Values.config.Tendermint.ListenPort }}
{{- if not (eq (len .Values.chain.extraSeeds) 0) -}}
{{- range .Values.chain.extraSeeds -}},{{ . }}{{- end -}}
{{- end -}}
{{- else -}}
{{- range (until (sub $.Values.chain.nodes 1 | int)) -}}
{{- $addr := (index $.Values.validatorAddresses ( print "Validator_" . )).NodeAddress | lower -}}
{{- $node := printf "%03d" . -}}
tcp://{{ $addr }}@{{ template "burrow.fullname" $ }}-peer-{{ $node }}:{{ $.Values.config.Tendermint.ListenPort }},
{{- end -}}
{{- $addr := (index $.Values.validatorAddresses ( print "Validator_" (sub .Values.chain.nodes 1))).NodeAddress | lower -}}
{{- $node := sub .Values.chain.nodes 1 | printf "%03d" -}}
tcp://{{ $addr }}@{{ template "burrow.fullname" $ }}-peer-{{ $node }}:{{ $.Values.config.Tendermint.ListenPort }}
{{- if not (eq (len .Values.chain.extraSeeds) 0) -}}
{{- range .Values.chain.extraSeeds -}},{{ . }}{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
