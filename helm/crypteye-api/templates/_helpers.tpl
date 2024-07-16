{{/* 
Expand Image name and tag */}}
{{- define "crypteye-api.image.name" -}}
{{- printf "%s:%s" .Values.image.name .Values.image.tag -}}
{{- end}}