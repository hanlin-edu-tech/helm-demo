{{- define "ehanlin.containers" }}
  {{- with .Values.ehanlin.tutor.java }}
  containers:
  {{- $probeSeconds := .probeSeconds -}}
  {{- with .app.chest }}
    - name: {{ .name | quote }}
      image: {{ .image | quote }}
      imagePullPolicy: Always
      ports:
        - containerPort: 8080
      livenessProbe:
        httpGet:
          path: {{ .probePath | quote }}
          port: 8080
        initialDelaySeconds: {{ $probeSeconds }}
      readinessProbe:
        httpGet:
          path: {{ .probePath | quote }}
          port: 8080
        initialDelaySeconds: {{ $probeSeconds }}
  {{- end }}
  {{- end }}
{{- end }}

{{- define "ehanlin.service.nodeport" }}
  {{- with .Values.ehanlin.tutor.java.app.chest }}
  type: NodePort
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
      name: http
  selector:
    app: {{ .name }}
  {{- end }}
{{- end }}

{{- define "ehanlin.ingress.httpPaths" }}
  {{- with .Values.ehanlin.tutor.ingress.http }}
    {{- $servicePort := .servicePort -}}
    {{- range $index, $path := .paths }}
      - path: {{ $path.path | quote }}
        backend:
          serviceName: {{ $path.serviceName | quote }}
          servicePort: {{ $servicePort }}
    {{- end}}
  {{- end }}
{{- end }}