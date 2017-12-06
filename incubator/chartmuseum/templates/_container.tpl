{{- define "container" -}}
- name: {{ .Chart.Name }}
  image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  args:
  - --port={{ .Values.service.internalPort }}
  - --storage={{ .Values.storage.provider }}
  {{- if eq .Values.storage.provider "local" }}
  - --storage-local-rootdir=/storage
  {{- else }}
  - --storage-{{.Values.storage.provider}}-bucket={{ .Values.storage.bucket}}
  - --storage-{{.Values.storage.provider}}-prefix={{ .Values.storage.prefix | quote}}
  {{- end }}
  {{- if eq .Values.storage.provider "amazon"}}
  {{- range $key, $val := .Values.storage.amazon }}
  - --storage-amazon-{{ $key }}={{$val}}
  {{- end }}
  {{- end }}
  {{- range $val := .Values.container.extraArgs }}
  - {{ $val }}
  {{- end }}
  ports:
  - containerPort: {{ .Values.service.internalPort }}
  livenessProbe:
    httpGet:
      path: /index.yaml
      port: {{ .Values.service.internalPort }}
  readinessProbe:
    httpGet:
      path: /index.yaml
      port: {{ .Values.service.internalPort }}
  volumeMounts:
  - mountPath: /storage
    name: storage-volume
  env:
  {{- range $key, $val := .Values.container.environment }}
    - name: {{ $key | upper }}
      value: {{ $val | quote}}
  {{- end }}
  resources:
{{ toYaml .Values.resources | indent 4 }}
{{- end -}}
