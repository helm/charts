NAMESPACE=opa
NAME=opa
SERVICE_NAME=$(NAME)-open-policy-agent

all: certs resources/webhook-configuration.yaml resources/helm-values.yaml

certs: tls/server.crt

tls/ca.key:
	openssl genrsa -out tls/ca.key 2048

tls/ca.crt: tls/ca.key
	openssl req -x509 -new -nodes -key tls/ca.key -days 100000 -out tls/ca.crt -subj "/CN=admission_ca"

tls/server.key:
	openssl genrsa -out tls/server.key 2048

tls/server.csr: tls/server.key
	openssl req -new -key tls/server.key -out tls/server.csr -subj "/CN=$(SERVICE_NAME).$(NAMESPACE).svc" -config openssl-server.conf

tls/server.crt: tls/server.csr tls/ca.crt tls/ca.key
	openssl x509 -req -in tls/server.csr -CA tls/ca.crt -CAkey tls/ca.key -CAcreateserial -out tls/server.crt -days 100000 -extensions v3_req -extfile openssl-server.conf

resources/webhook-configuration.yaml: tls/ca.crt
	./generate-webhook "$(SERVICE_NAME)" "$(NAMESPACE)" > resources/webhook-configuration.yaml 

resources/helm-values.yaml: tls/server.key tls/server.crt
	./generate-helm-values tls/server.crt tls/server.key > resources/helm-values.yaml

clean:
	rm -f tls/* resources/*.yaml