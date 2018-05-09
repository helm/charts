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
Check pod status via:

```bash
POD_NAME=$(kubectl get pods -l type=openvpn -o jsonpath='{.items[0].metadata.name}') \
&& kubectl log $POD_NAME --follow
```

When all components of the openvpn chart have started use the following script to generate a client key:

```shell
kubectl -n <namespace> exec -it <pod_name> /etc/openvpn/setup/newClientCert.sh <key_name> <external-ip>
kubectl -n <namespace> exec -it <pod_name> /etc/openvpn/setup/newClientCert.sh <key_name> > <key_name>.ovpn
```

The entire list of helper scripts can be found on [templates/config-openvpn.yaml](templates/config-openvpn.yaml)

Be sure to change `KEY_NAME` if generating additional keys.  Import the .ovpn file into your favorite openvpn tool like tunnelblick and verify connectivity.

## Configuration
The following table lists the configurable parameters of the `openvpn` chart and their default values,
and can be overwritten via the helm `--set` flag.

Parameter | Description | Default
---                            | ---                                                                  | ---
`replicaCount`                 | amount of parallel openvpn replicas to be started                    | `1`
`image.repository`             | `openvpn` image repository                                           | `jfelten/openvpn-docker`
`image.tag`                    | `openvpn` image tag                                                  | `1.1.0`
`image.pullPolicy`             | Image pull policy                                                    | `IfNotPresent`
`service.type`                 | k8s service type exposing ports, e.g. `NodePort`                     | `LoadBalancer`
`service.externalPort`         | TCP port reported when creating configuration files                  | `443`
`service.internalPort`         | TCP port on which the service works                                  | `443`
`service.nodePort`             | NodePort value if service.type is `NodePort`                         | `nil` (auto-assigned)
`service.externalIPs`          | External IPs to listen on                                            | `[]`
`resources.requests.cpu`       | OpenVPN cpu request                                                  | `300m`
`resources.requests.memory`    | OpenVPN memory request                                               | `128Mi`
`resources.limits.cpu`         | OpenVPN cpu limit                                                    | `300m`
`resources.limits.memory`      | OpenVPN memory limit                                                 | `128Mi`
`persistence.enabled`          | Use a PVC to persist configuration                                   | `true`
`persistence.subPath`          | Subdirectory of the volume to mount at                               | `openvpn`
`persistence.existingClaim`    | Provide an existing PersistentVolumeClaim                            | `nil`
`persistence.storageClass`     | Storage class of backing PVC                                         | `nil`
`persistence.accessMode`       | Use volume as ReadOnly or ReadWrite                                  | `ReadWriteOnce`
`persistence.size`             | Size of data volume                                                  | `2M`
`openvpn.OVPN_NETWORK`         | Network allocated for openvpn clients                                | `10.240.0.0`
`openvpn.OVPN_SUBNET`          | Network subnet allocated for openvpn                                 | `255.255.0.0`
`openvpn.OVPN_PROTO`           | Protocol used by openvpn tcp or udp                                  | `tcp`
`openvpn.OVPN_K8S_POD_NETWORK` | Kubernetes pod network (optional)                                    | `10.0.0.0`
`openvpn.OVPN_K8S_POD_SUBNET`  | Kubernetes pod network subnet (optional)                             | `255.0.0.0`
`openvpn.dhcpOptionDomain`     | Push a `dhcp-option DOMAIN` config                                   | `true`
`openvpn.conf`                 | Arbitrary lines appended to the end of the server configuration file | `nil`

This chart has been engineered to use kube-dns and route all network traffic to kubernetes pods and services,
to disable this behaviour set `openvpn.OVPN_K8S_POD_NETWORK` and `openvpn.OVPN_K8S_POD_SUBNET` to `null`.

#### Note: As configured the chart will create a route for a large 10.0.0.0/8 network that may cause issues if that is your local network.  If so tweak this value to something more restrictive.  This route is added, because GKE generates pods with IPs in this range.

### Certificates
New certificates are generated with each deployment.
If persistence is enabled certificate data will be persisted across pod restarts.
Otherwise new client certs will be needed after each deployment or pod restart.
