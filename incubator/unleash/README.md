# Unleash


Unleash is a feature toggle system, that gives you a great overview over all feature toggles across all your applications and services. It comes with official client implementations for Java, Node.js, Go, Ruby and Python.

The main motivation for doing feature toggling is to decouple the process for deploying code to production and releasing new features. This helps reducing risk, and allow us to easily manage which features to enable

> Feature toggles decouple **deployment** of code from **release** of new features

This repo contains the unleash-server, which contains the admin UI and a place to ask for the status of features. In order to make use of unleash you will also need a client implementation.

<img src="https://github.com/Unleash/unleash/raw/master/docs/assets/dashboard_new.png" alt="Unleash UI" width="600" />

## Activation strategies

It's fine to have a system for turning stuff on and off. But some times we want more granular control, we want to decide who to the toggle should be enabled for. This is where activation strategies comes in to the picture. Activation strategies take arbitrary config and allows us to enable a toggle in various ways.

Common activation strategies includes:

- Active For users with a specified userId
- GradualRollout to X-percent of our users
- Active for our beta users
- Active only for application instances running on host x.

Read more about activation strategies in [docs/activation-strategies.md](./docs/activation-strategies.md)

## Client implementations

We have official SDK's for Java, Node.js, Go, Ruby and Python. And we will be happy to add implementations in other languages written by you! These libraries makes it very easy to use Unleash in you application.

Official client SDK's:

- [unleash/unleash-client-java](https://github.com/unleash/unleash-client-java)
- [unleash/unleash-client-node](https://github.com/unleash/unleash-client-node)
- [unleash/unleash-client-go](https://github.com/unleash/unleash-client-go)
- [unleash/unleash-client-ruby](https://github.com/unleash/unleash-client-ruby)
- [unleash/unleash-client-python](https://github.com/Unleash/unleash-client-python)
- [unleash/unleash-client-core](https://github.com/Unleash/unleash-client-core) (.Net Core)

Clients written by awesome enthusiasts: :fire:

- [afontaine/unleash_ex](https://gitlab.com/afontaine/unleash_ex) (Elixir)
- [mikefrancis/laravel-unleash](https://github.com/mikefrancis/laravel-unleash) (Larvel - PHP)

### The Client API

The client SDKs provides a simple abstraction making it easy to check feature toggles in your application. The code snippet below shows how you would use `Unleash` in Java.

```java
if (unleash.isEnabled("AwesomeFeature")) {
  //do some magic
} else {
  //do old boring stuff
}
```

# Running Unleash Service

## Run it yourself

Run a kuberenetes deployment of [unleash](https://github.com/Unleash/unleash) using [helm](https://github.com/helm/charts),
with DB presistance postgresql.

The values.yaml file contains the default values for the deployment template as well as the postgres dependency.
The values-production.yaml is for production systems 
## How to run?

1. connect to k8s cluster with working helm client 
2. for helm install use the flowing command 

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm upgrade -i elhays-unlesh incubator/unlesh --set vault.dev=false "
```
3. remove it
```console
$ helm delete --purge elhays-unlesh
```
 



