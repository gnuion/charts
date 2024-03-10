{{/*
Services
*/}}
{{- define "common.ingresses" }}
{{- $name := include "common.nameWithPostfix" . }}
{{- $labels :=  include "common.labelsWithPostfix" . | nindent 4 }}
{{- $selector := include "common.selectorLabelsWithPostfix" . | nindent 4 }}
{{- range $key, $value := index (index . 0).Values (index . 1) "ports" }}
{{/* template */}}
{{- if $value.enableIngress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $name }}-{{ $key }}
  labels: {{ $labels }}
spec:
  rules:
  - host: {{ $value.hostname }}
    http:
      paths:
      - path: {{ $value.path }}
        backend:
          service:
            name: {{ $name }}-{{ $key }}
            port:
              number: {{ $value.port }}
        pathType: Prefix
{{- end }} {{/* if */}}
{{- end }} {{/* range */}}
{{- end }} {{/* service */}}