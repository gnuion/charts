{{/*
Service
*/}}
{{- define "common.service" }}
{{- $context := index . 0 }}
{{- $postfix := index . 1 }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.nameWithPostfix" . }}
  labels:
    {{- include "common.labelsWithPostfix" . | nindent 4 }}
spec:
  ports:
  {{- range index $context.Values $postfix "ports" }}
  - port: {{ .containerPort }}
    targetPort: {{ .containerPort }}
    protocol: {{ .protocol }}
  {{- end }}
  selector:
    {{- include "common.selectorLabelsWithPostfix" . | nindent 4 }}
{{- end }}