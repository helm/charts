# Quay 
A Quay Chart for Kubernetes

## Install Chart
To install the Quay Chart into your Kubernetes cluster

```bash
helm install --namespace "quay" -n "quay" incubator/quay
```

After installation succeeds, you can get a status of Chart

```bash
helm status "quay"
```

If you want to delete your Chart, use this command
```bash
helm delete  --purge "quay"
```


