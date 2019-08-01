External-Service-Operator
=========================

A Helm chart for deploying External-Service-Operator which is repsonsible for creating and monitoring Services running outside of the cluster.
The External-Service-Operator will create K8s Ressources for those Services, so they can be used, as they would just live inside the cluster.
One of the Usecases can also be, that you want to expose an external Service via your Kubernetes Ingress Controller in order to have one central reverse Proxy.

More Information: https://github.com/CrowdfoxGmbH/external-service-operator

Getting Started
----------------

This chart is not very complex. So you can simply run:

`helm install --name external-service-operator .`

which will install the external-service-operator in an own namespace "external-services" but is watching all namespaces.

Now you can create an ExternalService by posting an ExternalService Resource Definition, e.g:

```YAML
apiVersion: eso.crowdfox.com/v1alpha1
kind: ExternalService
metadata:
  annotations:
    # those annotations will be added to the ingress ressource
    traefik.ingress.kubernetes.io/preserve-host: "true"
  name: complex-example
  namespace: external-service
spec:
  hosts:
  - host: static1.mydomain.com
    path: ""
  - host: static2.mydomain.com
    path: ""
  - host: mydomain.com
    path: ""
  - host: www.mydomain.com
    path: ""
  ips:
  - 10.0.100.10
  - 10.0.100.11
  port: 80
  readinessProbe:
    failureThreshold: 3
    httpGet:
      host: www.mydomain.com
      httpHeaders:
      - name: X-Forwarded-Proto
        value: https
      path: /healthcheck
      port: 8080
      scheme: HTTP
    periodSeconds: 10
    successThreshold: 2
    timeoutSeconds: 2
```

This will create in the according namespacce: Endpoints, Service and Ingress Resoures. Also when you provide any probes like it's the case above, it will check regulary your service for readiness.

You can basically choose any namespace you want to have your external-service deployed to. This can help, that you expose a service A to one or more services (B,C,D,...) already running in the Cluster even though service A is yet not dockerized and deployed to kubernetes.

When you then migrate the service into the cluster you just have to remove the ExternalService resource, deploy Service A into Kubernetes without the need to change service B,C,D...

Configuration
--------------

|           Parameter             |             Description                                     |                Default                 |
|---------------------------------|-------------------------------------------------------------|----------------------------------------|
| `image.repository`              | Docker image for the Operator                               | crowdfox/external-service-operator
| `image.pullPolicy`              | Docker pull policy                                          | IfNotPresent
| `devel`                         | Verbose debug output as tab seperated lines instead of json | false
| `resources`                     | Container resources                                         | {}
| `nodeSelector`                  |                                                             | {}
| `affinity`                      |                                                             | {}
| `tolerations`                   |                                                             | {}


