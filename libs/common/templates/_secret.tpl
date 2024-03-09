{{/*
Secret for storing environment variables
*/}}
{{- define "common.secret" }}
{{- $context := index . 0 }}
{{- $postfix := index . 1 }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.nameWithPostfix" . }}
  labels: {{ include "common.labelsWithPostfix" . | nindent 4 }}
type: Opaque
data:
  {{- range index $context.Values $postfix "env" | split "\n"  }}
  {{- if . }}
  {{- $parts := regexSplit "=" . 2  }}
  {{ index $parts 0 }}: {{ tpl (index $parts 1) $context | b64enc }}
  {{- end }}
  {{- end }}
{{- end }}



