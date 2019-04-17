# Ingress

This chart can automatically create an Ingress resource for Code Dx. To do this, set `ingress.enabled=true` and add an appropriate entry to `ingress.hosts`. Setting `ingress.enabled=true` automatically sets Code Dx's Service type to `NodePort` rather than `LoadBalancer`.

Check the [example YAML values file](../sample-values/values-ingress.yaml) for an example that uses HTTPS.

**Note that the Ingress Annotations contains NGINX annotations by default to increase the read timeout and remove the proxy request body size limit.** This is to prevent errors for Code Dx live-updates and for uploading large files, respectively. If using a different Ingress implementation, make sure to include the appropriate annotations.

Once an ingress is defined, Code Dx will be available at `http(s)://my.hostname/codedx`. 