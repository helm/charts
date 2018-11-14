# OPA Helm Chart helper scripts

In this directory are some scripts which are useful for creating the necessary resources required by OPA when it is used as a Kubernetes custom admission controller.

*NOTE*: Before running `make`, you should decide what namespace and what deployment name you wish to use. See the section below the example which contains details of how to pass these to `make`.

## Example

To generate everything, simply run make:

    ❯ make
    openssl genrsa -out tls/server.key 2048
    Generating RSA private key, 2048 bit long modulus
    ........+++
    ........................+++
    e is 65537 (0x10001)
    openssl req -new -key tls/server.key -out tls/server.csr -subj "/CN="opa-open-policy-agent".kube-system.svc" -config openssl-server.conf
    openssl genrsa -out tls/ca.key 2048
    Generating RSA private key, 2048 bit long modulus
    ...+++
    ..........................................+++
    e is 65537 (0x10001)
    openssl req -x509 -new -nodes -key tls/ca.key -days 100000 -out tls/ca.crt -subj "/CN=admission_ca"
    openssl x509 -req -in tls/server.csr -CA tls/ca.crt -CAkey tls/ca.key -CAcreateserial -out tls/server.crt -days 100000 -extensions v3_req -extfile openssl-server.conf
    Signature ok
    subject=/CN=opa-open-policy-agent.kube-system.svc
    Getting CA Private Key
    ./generate-webhook "kube-system" ""opa-open-policy-agent"" > resources/webhook-configuration.yaml
    ./generate-helm-values tls/server.crt tls/server.key > resources/helm-values.yaml

## Changing the defaults

The `Makefile` defaults to the `kube-system` namespace and the deployment name `opa`. These can be override by passing the chosen names to make on the command line:

    make NAMESPACE=test NAME=foo

## Using the output

Among the various TLS files created under `tls/`, there are two useful files created in `resources/`:

* `helm-values.yaml` - This is a yaml file, ready for passing to help (via `-f`) with the `server.key` and `server.crt` inside. You can provide multiple `-f` options to help, so this is safe to put on the end of any other options you are passing.
* `webhook-configuration.yaml` - This is a `ValidatingWebhookConfiguration` resource for passing to kubernetes to configure the webhook admission controller to send requests to OPA. You will need to install this manually (via `kubectl create -f resources/webhook-configuration.yaml`).

