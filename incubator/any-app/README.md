# any-app

any-app is meant to provide base yaml templates for the installation of any container as an app on kubernetes. An 'app' is any application or microservice which in the kubernetes space would need deployments, services and ingresses. 

```console
$ helm install incubator/any-app --set ingress.host=foo.app.com --set image.repository=slick/fooapp --set image.tag=v1 --name slick-app-v1
```

## Introduction

This chart allows one to setup an application on kubernetes, complete with ingress, service and deployment. One simply needs to provide a container to the chart to complete the installation.


## Configuration

The following table lists the configurable parameters of the any-app chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | the repository where your apps container is located | None
`image.tag` | the tag of the image you wish to use | None
`command` | command to run as container starts 'ENTRYPOINT' | None
`args` | args for the startup command | None
`appEnv` | environment variables to inject into container | {}
`ingress.host` | the hostname to use on the ingress | None
`ingress.enabled` | add an ingress for your app to be externally accessible | true
`replicaCount` | number of pods to deploy | 1 
