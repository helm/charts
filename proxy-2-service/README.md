# proxy-2-service

Proxy a pod port or host port to a kubernetes Service

While Kubernetes provides the ability to map Services to ports on each node,
those ports are in a special range set aside for allocations.  This means you
can not not simply choose to expose a Service on port 80 on your nodes.  You
also can not choose to expose it on some nodes but not others.  These things
will be fixed in the future, but until then, here is a stop-gap measure you can
use.

The container image `gcr.io/google_containers/proxy-to-service:v2` is a very
small container that will do port-forwarding for you.  You can use it to
forward a pod port or a host port to a service.  Pods can choose any port or
host port, and are not limited in the same way Services are.

For example, suppose you want to forward a node's port 80 (HTTP) to your
node's nginx service.  The following pod would do the trick:

```
apiVersion: v1
kind: Pod
metadata:
  name: http-proxy
spec:
  containers:
  - name: proxy-http
    image: gcr.io/google_containers/proxy-to-service:v2
    args: [ "tcp", "80", "nginx.default" ]
    ports:
    - name: http
      protocol: TCP
      containerPort: 80
      hostPort: 80
```

This creates a pod with one container receives traffic on a port 80 (HTTP) and 
forwards that traffic to the `nginx` service.
You also can add more ports adding another container there.
You can run this on as many or as few nodes as you want.

Note: Kubernetes DNS Add-on needs to be installed
