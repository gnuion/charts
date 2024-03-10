{{/*
Ingress
*/}}
{{- define "common.ingress" }}
{{- $context := index . 0 }}
{{- $postfix := index . 1 }}
{{ if index $context.Values $postfix "ingress" "isEnabled" }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.nameWithPostfix" . }}
  labels: 
  {{- include "common.labelsWithPostfix" . | nindent 4 }} 
  {{- with index $context.Values $postfix "ingress" "extraLabels" }}
  {{- . | toYaml | nindent 4 }}
  {{- end }}
spec:
  rules:
  - host: {{ index $context.Values $postfix "ingress" "host" }}
    http:
      paths:
      - path: {{ index $context.Values $postfix "ingress" "path" | default "/" }}
        backend:
          service:
            name: {{ include "common.nameWithPostfix" . }}
            port:
              number: 80
        pathType: Prefix
  {{- if index $context.Values $postfix "ingress" "tls" "isEnabled" }}
  tls:
  - hosts:
    - {{ index $context.Values $postfix "ingress" "host" }}
    secretName: {{ include "common.nameWithPostfix" . }}
  {{- end }}
{{- end }}
{{ end }}