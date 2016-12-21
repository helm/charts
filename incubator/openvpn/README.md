# Helm chart for OpenVPN
This chart will install an openvpn server inside a kubernetes cluster.  New certificates are generated on install, and a script is provided to genreate client keys as needed.  The chart will automatically configure dns to use kubeDNS and route all network traffic to kuberentes pods and services through the vpn.  By connecting to this VPN a host is effectively inside a cluster's network.

###Uses
The primary purpose of this chart was to make it easy to access kubernetes services during development.  It could also be used for any service that only needs to be access through a VPN, or as a general prupose VPN.

##Usage
helm install openvpn

Wait for the external load blancer IP to become available.  Then generate a client key as follows :
		export POD_NAME=`kubectl get pods -l type=openvpn | awk END'{ print $1 }'`
		export SERVICE_NAME=`kubectl get svc -l type=openvpn | awk END'{ print $1 }'`
		export SERVICE_IP=`kubectl get svc --namespace {{ .Release.Namespace }} $SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
		export KEY_NAME=mycert
		kubectl exec -it $POD_NAME /etc/openvpn/setup/newClientCert.sh $KEY_ NAME $SERVICE_IP > $KEY_NAME.ovpn

Import the .ovpn file into your favorite openvpn tool like tunnelblick, and verify connectivity.

##Configuration

All configuration is in the values.yaml file, and can be overwritten via the helm --set flag.

###Certificates

Certificates are generated with each deployment.  This way there is no need to store them, but this may be an issue if the pods are restarted often or if there are many clients.  We may able a persistent storage of certs if this becomes an issue.

###Important values
* service.externalPort: 443 - external LoadBalancer port
* service.internalPort: 443 - port of openVPN port
 
* openvpn.OVPN_NETWORK: 10.240.0.0 - Network allocated for openvpn clients (default: 10.240.0.0).
* openvpn.OVPN_SUBNET:  255.255.0.0 - Network subnet allocated for openvpn client (default: 255.255.0.0).
* openvpn.OVPN_PROTO: tcp - Protocol used by openvpn tcp or udp (default: tcp).
* openvpn.OVPN_K8S_POD_NETWORK: "10.0.0.0" - Kubernetes pod network (optional).
* openvpn.OVPN_K8S_POD_SUBNET: "255.0.0.0" - Kubernetes pod network subnet (optional).

####Note: As configured the chart will create a route for a large 10.0.0.0/8 network that may cause issues if that is your local network.  If so tweak this value to something more restrictive that doesn't interfere with you network.  We add this because kubernetes get genreate pod IPS in this range.
