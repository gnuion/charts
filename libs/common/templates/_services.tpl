{{/*
Services
*/}}
{{- define "common.services" }}
{{- $name := include "common.nameWithPostfix" . }}
{{- $labels :=  include "common.labelsWithPostfix" . | nindent 4 }}
{{- $selector := include "common.selectorLabelsWithPostfix" . | nindent 4 }}
{{- range $key, $value := index (index . 0).Values (index . 1) "ports" }}
{{/* template */}}
{{- if $value.enableService }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $name }}-{{ $key }}
  labels: {{ $labels }}
spec:
  ports:
  - port: {{ $value.port }}
    targetPort: {{ $value.containerPort }}
    protocol: {{ $value.protocol }}
  selector: {{ $selector }}
{{- end }} {{/* if */}}
{{- end }} {{/* range */}}
{{- end }} {{/* service */}}