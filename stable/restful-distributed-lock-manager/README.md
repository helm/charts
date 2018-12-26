# restful-distributed-lock-manager
[RDLM](https://github.com/thefab/restful-distributed-lock-manager) (Restful Distributed Lock Manager) is a lock manager over HTTP built on [Tornado](http://www.tornadoweb.org/en/stable/).

## Special features

- RESTful interface
- Timeout automatic management (to avoid stale locks)
- Blocking wait for acquiring a lock (with customatizable timeout)
- Very fast (in memory)
- One unique single threaded process
- Can deal with thousands of locks and simultaneous connections
- Administrative password protected requests

## Helm Charts

If you have configured helm on your cluster, you can add rdlm to helm from helm public chart repository and deploy it via helm using below mentioned commands

 ```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/restful-distributed-lock-manager
```

## Usage

The following quickstart let's you set up restful-distributed-lock-manager

Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| rdlm.labels          | Labels for deployment                                                | `provider: stakater`                        | `provider: stakater`                        |
| rdlm.deployment.replicas          | Number of replicas                                                | `1`                        | `1`                        |
| rdlm.deployment.podLabels           | Pod labels                                                | `{}`                        | `{}`                        |
| rdlm.deployment.container.name           | container name                                                | `rdlm`                        | `rdlm`                        |
| rdlm.deployment.container.imageName          | Image name for rdlm                                                | `stakater/restful-distributed-lock-manager`                        | `stakater/restful-distributed-lock-manager`                        |
| rdlm.deployment.container.imageTag          | Image tag for rdlm                                                | `0.5.3`                        | `0.5.3`                        |
| rdlm.deployment.container.port          | port to expose rdlm                                                | `8080`                        | `8080`                        |
| rdlm.deployment.container.targetPort          | container targetPort for rdlm                                                | `8888`                        | `8888`                        |