# nginx

## Introduction

This chart is for deploying nginx with static content.

## Prerequisites

Kubernetes >= 1.8.x

Working `helm` and `tiller`.

_Note:_ Tiller may need a service account and role binding if RBAC is enabled in your cluster.

## Installing nginx

```bash
helm install nginx --name hello-world
```

This command deploys a simple "Hello World" static web site.

```text
NAME:   hello-world
LAST DEPLOYED: Fri Apr 26 07:20:55 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                       DATA  AGE
hello-world-nginx-content  1     1s

==> v1/Deployment
NAME               READY  UP-TO-DATE  AVAILABLE  AGE
hello-world-nginx  0/1    1           0          1s

==> v1/Pod(related)
NAME                                READY  STATUS             RESTARTS  AGE
hello-world-nginx-7b45f684cc-npl89  0/1    ContainerCreating  0         1s

==> v1/Role
NAME               AGE
hello-world-nginx  1s

==> v1/RoleBinding
NAME               AGE
hello-world-nginx  1s

==> v1/Service
NAME               TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)         AGE
hello-world-nginx  ClusterIP  10.103.29.216  <none>       80/TCP,443/TCP  1s

==> v1/ServiceAccount
NAME               SECRETS  AGE
hello-world-nginx  1        1s


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=nginx,app.kubernetes.io/instance=hello-world" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```

Copy/paste and execute the commands shown and see the website contents:

```bash
$ curl http://localhost:8080
<html><body><h1>Hello World!</h1></body></html>
```

## Uninstalling

To uninstall/delete the `hello-world` deployment:

```bash
helm delete hello-world --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults. 

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name hello-world \
    --set deployment.replicaCount 3
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name hello-world -f values.yaml stable/nginx
```

> **Tip**: You can use the default [values.yaml](values.yaml)
