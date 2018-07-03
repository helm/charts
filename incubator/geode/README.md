# Geode
A Chart to install Apache Geode clusters in kubernetes

## Install Chart
To install the Geode in your Kubernetes cluster:

```bash
helm install incubator/geode
```

## Dashboard
Follow the steps listed in the output of the above helm install command to launch Geode's dashboard (pulse)

## Status
After installation succeeds, you can get a status of Chart

```bash
helm status <deployment name>
```
Tip: use `helm list` to get the deployment name

## Delete
If you want to delete your Chart, use this command
```bash
helm delete <deployment name>
```

## Install Chart with specific cluster size
By default, this Chart will create a geode cluster with one locator and 3 servers. If you want to change the cluster size during installation, you can use `--set config.num_locators={value}` to specify number of locators and `--set config.num_servers={value}` to specify the number of servers.

For example:
To start 5 servers

```bash
helm install --set config.num_servers=5 incubator/geode
```

## Install Chart with specific resource size
By default, this Chart creates a locator with 50m JVM heap and a server with 100m JVM heap. If you want to give more memory to your locator, you can use `--set memory.max_locators={value}` and for the servers `--set memory.max_servers={value}`.

For example:
To start servers with 20G memory

```bash
helm install --set memory.max_servers=20g incubator/geode
```

## Scale cluster
When you want to change the cluster size of your geode cluster, first lookup the name of the geode-server statefulset

```bash
kubectl get statefulsets
```
Then scale the stateful set using the `kubectl scale` command
```bash
kubectl scale statefulsets <deployment name>-geode-server --replicas=5
```