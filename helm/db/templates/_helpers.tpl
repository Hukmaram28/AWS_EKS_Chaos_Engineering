{{/* 
Expand Image name and tag */}}
{{- define "db.image.name" -}}
{{- printf "%s:%s" .Values.image.name .Values.image.tag -}}
{{- end}}