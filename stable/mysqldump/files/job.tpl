spec:
  containers:
  - name: xtrabackup
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
    command: ["/bin/bash", "/scripts/backup.sh"]
    envFrom:
    - configMapRef:
        name: "{{ template "mysqldump.fullname" . }}"
    - secretRef:
        name: "{{ template "mysqldump.fullname" . }}"
    volumeMounts:
    - name: backups
      mountPath: /backup
    - name: xtrabackup-script
      mountPath: /scripts
  restartPolicy: Never
  {{- if .Values.nodeSelector }}
  nodeSelector:
{{ toYaml .Values.nodeSelector | indent 8 }}
  {{- end }}
  volumes:
  - name: backups
{{- if .Values.persistentVolumeClaim }}
    persistentVolumeClaim:
      claimName: {{ .Values.persistentVolumeClaim }}
{{- else -}}
{{- if .Values.persistence.enabled }}
    persistentVolumeClaim:
      claimName: {{ template "mysqldump.fullname" . }}
{{- else }}
    emptyDir: {}
{{- end }}
{{- end }}
  - name: xtrabackup-script
    configMap:
      name: {{ template "mysqldump.fullname" . }}-script
