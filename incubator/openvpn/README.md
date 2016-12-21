# Helm chart for OpenVPN
This chart will install an openvpn server inside a kubernetes cluster.  New certificates are generated on install, and a script is provided to genreate client keys as needed.  The chart will automatically configure dns to use kubeDNS and route all network traffic to kuberentes pods and services through the vpn.  By connecting to this VPN a host is effectively inside a cluster's network.

###Uses
The primary purpose of this chart was to make it easy to access kubernetes services during development.  It could also be used for any service that only needs to be accessthrough a VPN.

##Usage
helm install openvpn

Then generate a client certificate as follows :
		export POD_NAME=`kubectl get pods -l type=openvpn | awk END'{ print $1 }'`
		