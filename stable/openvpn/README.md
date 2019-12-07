# Helm chart for OpenVPN
This chart will install an [OpenVPN](https://openvpn.net/) server inside a kubernetes cluster.  New certificates are generated on install, and a script is provided to generate client keys as needed.  The chart will automatically configure dns to use kube-dns and route all network traffic to kubernetes pods and services through the vpn.  By connecting to this vpn a host is effectively inside a cluster's network.

### Uses
The primary purpose of this chart was to make it easy to access kubernetes services during development.  It could also be used for any service that only needs to be accessed through a vpn or as a standard vpn.

## Usage

```bash
helm repo add stable http://storage.googleapis.com/kubernetes-charts
helm install stable/openvpn
```

Wait for the external load balancer IP to become available.  Check service status via: `kubectl get svc`

Please be aware that certificate generation is variable and may take some time (minutes).
Check pod status, replacing `$HELM_RELEASE` with the name of your release, via:

```bash
POD_NAME=$(kubectl get pods -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}') \
&& kubectl logs "$POD_NAME" --follow
```

When all components of the openvpn chart have started use the following script to generate a client key:


```bash
#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME> <NAMESPACE> <HELM_RELEASE>"
  exit
fi

KEY_NAME=$1
NAMESPACE=$2
HELM_RELEASE=$3
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
SERVICE_NAME=$(kubectl get svc -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
SERVICE_IP=$(kubectl get svc -n "$NAMESPACE" "$SERVICE_NAME" -o go-template='{{range $k, $v := (index .status.loadBalancer.ingress 0)}}{{$v}}{{end}}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" > "$KEY_NAME.ovpn"
```

In order to revoke certificates in later steps:
```bash
#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME> <NAMESPACE> <HELM_RELEASE>"
  exit
fi

KEY_NAME=$1
NAMESPACE=$2
HELM_RELEASE=$3
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/revokeClientCert.sh $KEY_NAME
```

The entire list of helper scripts can be found on [templates/config-openvpn.yaml](templates/config-openvpn.yaml)

Be sure to change `KEY_NAME` if generating additional keys.  Import the .ovpn file into your favorite openvpn tool like tunnelblick and verify connectivity.

## Configuration
The following table lists the configurable parameters of the `openvpn` chart and their default values,
and can be overwritten via the helm `--set` flag.

Parameter | Description | Default
---                                  | ---                                                                  | ---
`replicaCount`                       | amount of parallel openvpn replicas to be started                    | `1`
`updateStrategy`                     | update strategy for deployment                                       | `{}`
`image.repository`                   | `openvpn` image repository                                           | `jfelten/openvpn-docker`
`image.tag`                          | `openvpn` image tag                                                  | `1.1.0`
`image.pullPolicy`                   | Image pull policy                                                    | `IfNotPresent`
`service.type`                       | k8s service type exposing ports, e.g. `NodePort`                     | `LoadBalancer`
`service.externalPort`               | TCP port reported when creating configuration files                  | `443`
`service.internalPort`               | TCP port on which the service works                                  | `443`
`service.hostPort`                   | Expose openvpn directly using host port                              | `nil`
`service.nodePort`                   | NodePort value if service.type is `NodePort`                         | `nil` (auto-assigned)
`service.clusterIP`                  | clusterIP value if service.type is `ClusterIP`                       | `nil`
`service.externalIPs`                | External IPs to listen on                                            | `[]`
`resources.requests.cpu`             | OpenVPN cpu request                                                  | `300m`
`resources.requests.memory`          | OpenVPN memory request                                               | `128Mi`
`resources.limits.cpu`               | OpenVPN cpu limit                                                    | `300m`
`resources.limits.memory`            | OpenVPN memory limit                                                 | `128Mi`
`readinessProbe.initialDelaySeconds` | Time to wait to start first probe                                    | `5`
`readinessProbe.periodSeconds`       | Interval of readiness probe                                          | `5`
`readinessProbe.successThreshold`    | Minimum consecutive successes for probe to be considered healthy     | `2`
`persistence.enabled`                | Use a PVC to persist configuration                                   | `true`
`persistence.subPath`                | Subdirectory of the volume to mount at                               | `nil`
`persistence.existingClaim`          | Provide an existing PersistentVolumeClaim                            | `nil`
`persistence.storageClass`           | Storage class of backing PVC                                         | `nil`
`persistence.accessMode`             | Use volume as ReadOnly or ReadWrite                                  | `ReadWriteOnce`
`persistence.size`                   | Size of data volume                                                  | `2M`
`podAnnotations`                     | Key-value pairs to add as pod annotations                            | `{}`
`openvpn.OVPN_NETWORK`               | Network allocated for openvpn clients                                | `10.240.0.0`
`openvpn.OVPN_SUBNET`                | Network subnet allocated for openvpn                                 | `255.255.0.0`
`openvpn.OVPN_PROTO`                 | Protocol used by openvpn tcp or udp                                  | `tcp`
`openvpn.OVPN_K8S_POD_NETWORK`       | Kubernetes pod network (optional)                                    | `10.0.0.0`
`openvpn.OVPN_K8S_POD_SUBNET`        | Kubernetes pod network subnet (optional)                             | `255.0.0.0`
`openvpn.OVPN_K8S_SVC_NETWORK`       | Kubernetes service network (optional)                                | `nil`
`openvpn.OVPN_K8S_SVC_SUBNET`        | Kubernetes service network subnet (optional)                         | `nil`
`openvpn.dhcpOptionDomain`           | Push a `dhcp-option DOMAIN` config                                   | `true`
`openvpn.conf`                       | Arbitrary lines appended to the end of the server configuration file | `nil`
`openvpn.redirectGateway`            | Redirect all client traffic through VPN                              | `true`
`openvpn.useCrl`                     | Use/generate a certificate revocation list (crl.pem)                 | `false`
`openvpn.taKey`                      | Use/generate a ta.key file for hardening security                    | `false`
`openvpn.cipher`                     | Override the default cipher                                          | `nil` (OpenVPN default)
`openvpn.istio.enabled`              | Enables istio support for openvpn clients                            | `false`
`openvpn.istio.proxy.port`           | Istio proxy port                                                     | `15001`
`openvpn.iptablesExtra`              | Custom iptables rules for clients                                    | `[]`
`nodeSelector`                       | Node labels for pod assignment                                       | `{}`
`tolerations`                        | Tolerations for node taints                                          | `[]`

This chart has been engineered to use kube-dns and route all network traffic to kubernetes pods and services,
to disable this behaviour set `openvpn.OVPN_K8S_POD_NETWORK` and `openvpn.OVPN_K8S_POD_SUBNET` to `null`.

If openvpn.OVPN_K8S_SVC_NETWORK and openvpn.OVPN_K8S_SVC_SUBNET are defined, an extra route for services subnet will be added.

#### Note: As configured the chart will create a route for a large 10.0.0.0/8 network that may cause issues if that is your local network.  If so tweak this value to something more restrictive.  This route is added, because GKE generates pods with IPs in this range.

### Certificates

New certificates are generated with each deployment, if *keystoreSecret* is not defined.
If persistence is enabled certificate data will be persisted across pod restarts.
Otherwise new client certs will be needed after each deployment or pod restart.

Certificates can be passed in secret, which name is specified in *openvpn.keystoreSecret* value.
Create secret as follows:

```bash
kubectl create secret generic openvpn-keystore-secret --from-file=./server.key --from-file=./ca.crt --from-file=./server.crt --from-file=./dh.pem [--from-file=./crl.pem] [--from-file=./ta.key]
```

You can deploy temporary openvpn chart, create secret from generated certificates, and then re-deploy openvpn, providing the secret.
Certificates can be found in openvpn pod in the following files:

 `/etc/openvpn/certs/pki/private/server.key`
 `/etc/openvpn/certs/pki/ca.crt`
 `/etc/openvpn/certs/pki/issued/server.crt`
 `/etc/openvpn/certs/pki/dh.pem`

If openvpn.useCrl is set:

 `/etc/openvpn/certs/pki/crl.pem`

And optionally (see openvpn.taKey setting):

 `/etc/openvpn/certs/pki/ta.key`

Note: using mounted secret makes creation of new client certificates impossible inside openvpn pod, since easyrsa needs to write in certs directory, which is read-only.
