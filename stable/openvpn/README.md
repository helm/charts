# Helm chart for OpenVPN
This chart will install an openvpn server inside a kubernetes cluster.  New certificates are generated on install, and a script is provided to generate client keys as needed.  The chart will automatically configure dns to use kube-dns and route all network traffic to kubernetes pods and services through the vpn.  By connecting to this vpn a host is effectively inside a cluster's network.

###Uses
The primary purpose of this chart was to make it easy to access kubernetes services during development.  It could also be used for any service that only needs to be accessed through a vpn or as a standard vpn.

##Usage

```bash
helm repo add stable http://storage.googleapis.com/kubernetes-charts-incubator
helm install stable/openvpn
```

Wait for the external load balancer IP to become available.  Check service status via: kubectl get svckubectl get svc
 
Please be aware that certificate generation is variable and may take some time (minutes).
Check pod status via:
POD_NAME=`kubectl get pods -l type=openvpn | awk END'{ print $1 }'` \
&& kubectl log $POD_NAME --follow

When ready generate a client key as follows:

```bash
POD_NAME=`kubectl get pods --namespace {{ .Release.Namespace }} -l type=openvpn | awk END'{ print $1 }'` \
&& SERVICE_NAME=`kubectl get svc --namespace {{ .Release.Namespace }} -l type=openvpn | awk END'{ print $1 }'` \
&& SERVICE_IP=`kubectl get svc $SERVICE_NAME --namespace {{ .Release.Namespace }} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'` \
&& KEY_NAME=kubeVPN \
&& kubectl exec --namespace {{ .Release.Namespace }} -it $POD_NAME /etc/openvpn/setup/newClientCert.sh $KEY_NAME $SERVICE_IP \
&& kubectl exec --namespace {{ .Release.Namespace }} -it $POD_NAME cat /usr/share/easy-rsa/pki/$KEY_NAME.ovpn > $KEY_NAME.ovpn
```

Be sure to change KEY_NAME if generating additional keys.  Import the .ovpn file into your favorite openvpn tool like tunnelblick and verify connectivity.

##Configuration

All configuration is in the values.yaml file, and can be overwritten via the helm --set flag.

###Certificates

New certificates are generated with each deployment.  This chart was developed as a way to quickly set up a personal vpn.  Supporting multiple users would require persistent storage of certificates to avoid unncessary regeneration.  This will be added later if there is interest in multi-user support.

###Important values
* service.externalPort: 443 - external LoadBalancer port
* service.internalPort: 443 - port of openVPN port
* openvpn.OVPN_NETWORK: 10.240.0.0 - Network allocated for openvpn clients (default: 10.240.0.0).
* openvpn.OVPN_SUBNET:  255.255.0.0 - Network subnet allocated for openvpn client (default: 255.255.0.0).
* openvpn.OVPN_PROTO: tcp - Protocol used by openvpn tcp or udp (default: tcp).
* openvpn.OVPN_K8S_POD_NETWORK: "10.0.0.0" - Kubernetes pod network (optional).
* openvpn.OVPN_K8S_POD_SUBNET: "255.0.0.0" - Kubernetes pod network subnet (optional).

####Note: As configured the chart will create a route for a large 10.0.0.0/8 network that may cause issues if that is your local network.  If so tweak this value to something more restrictive.  This route is added, because GKE generates pods with IPs in this range.
