{{ define "linkerd.pod-affinity" -}}
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: {{ .Label }}
            operator: In
            values:
            - {{ .Component }}
        topologyKey: failure-domain.beta.kubernetes.io/zone
      weight: 100
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        - key: {{ .Label }}
          operator: In
          values:
          - {{ .Component }}
      topologyKey: kubernetes.io/hostname
{{- end }}
