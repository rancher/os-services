
{{- if .Port}}
Port {{.Port}}
{{- end}}

{{- if .ListenAddress}}
ListenAddress {{.ListenAddress}}
{{- end}}

ClientAliveInterval 180

UseDNS no
PermitRootLogin no
AllowGroups docker
