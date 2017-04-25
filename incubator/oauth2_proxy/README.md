# oauth2_proxy

[oauth2_proxy](https://github.com/bitly/oauth2_proxy) is a reverse proxy and static file server that provides authentication using Providers (Google, GitHub, and others) to validate accounts by email, domain or group.

# Configuration

# Usage

## 1. Create your internal service

This service will be the service you want to hide behind the `oauth2_proxy`.

## 2. Create an ingress for your service

Example for Kubernetes Dashboard:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/auth-signin: https://auth.example.com/oauth2/sign_in
    ingress.kubernetes.io/auth-url: https://auth.example.com/oauth2/auth
  name: external-auth-oauth2
  namespace: kube-system
spec:
  rules:
  - host: dashboard.example.com
    http:
      paths:
      - backend:
          serviceName: kubernetes-dashboard
          servicePort: 80
        path: /
```

