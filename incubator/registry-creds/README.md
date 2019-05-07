# registry-creds

## Chart Details

This chart bootstraps a [registry-creds](https://github.com/upmc-enterprises/registry-creds) deployment on a Kubernetes
cluster

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

By default, all registry credential types are disabled by default but at least one needs to be configured (otherwise
registry-creds will be up and running but useless)

### Using Docker Registry Provider

```console
helm install --name registry-creds --set dpr.enabled=true --set dpr.user="myUser" --set dpr.password="myPassword" \
--set dpr.server=myregistry:myport incubator/registry-creds
```

### Using Elastic Container Registry

#### From AWS

Ensure your EC2 instances have the appropriate permissions as described in 
[registry-creds](https://github.com/upmc-enterprises/registry-creds) documentation.

```console
helm install --name registry-creds --set ecr.enabled=true --set ecr.awsAccount="myAccount" \
--set ecr.awsRegion="myRegion" incubator/registry-creds
```

#### Outside AWS

```console
helm install --name registry-creds --set ecr.enabled=true --set ecr.awsAccessKeyId="myID" \
--set ecr.awsSecretAccessKey="mySecret"--set ecr.awsAccount="myAccount" --set ecr.awsRegion="myRegion" \
incubator/registry-creds
```

### Using Google Container Registry

Create a `custom-values.yaml` file:

```yaml
gcr:
  enabled: false  
  applicationDefaultCredentialsJson: |
  {
    "client_id": "myID",
    "client_secret": "mySecret",
    "refresh_token": "myRefreshToken",
    "type": "authorized_user"
  }"
```

Install the chart using this `custom-values.yaml` file:

```console
helm install --name registry-creds --values custom-values.yaml incubator/registry-creds
```

## Uninstalling the Chart

````console
helm delete registry-creds
````

## Using existing secrets

In order to set the authentication for the private registry (dpr, ecr, gcr), existing secrets can be referenced instead
of providing the required parameters for the registry provider. This can be useful in some scenarios (for instance for
a GitOps approach where we don't want sensitive information to live in the repository)

Unlike other components, registry-creds is designed to be installed in `kube-system` namespace and therefore
corresponding secrets need to be created in that namespace.

### Using an existing secret for Docker Private Registry

Creating the secret:

```console
kubectl create secret generic registry-creds-dpr -n kube-system \
--from-literal "DOCKER_PRIVATE_REGISTRY_SERVER=myServer" \
--from-literal "DOCKER_PRIVATE_REGISTRY_USER=myUser" \
--from-literal "DOCKER_PRIVATE_REGISTRY_PASSWORD=myPassword"
```

Installing the chart:

```console
helm install --name registry-creds --set dpr.enabled=true --set dpr.existingSecretName="registry-creds-dpr" \
incubator/registry-creds
```

## Configuration

The following table lists the configurable parameters of this chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | number of replicas | `1`
`image.name` | container image repository | `"upmcenterprises/registry-creds"`
`image.tag`  | container image tag | `"1.9"`
`image.pullPolicy` | container image pull policy | `"IfNotPresent"`
`nameOverride` | override name of app |`""`
`fullnameOverride` | override full name of app | `""`
`dpr.enabled` | enable the injection of docker private registry credentials | `false`
`dpr.existingSecretName` | defines an existing secret (in kube-system namespace) containing the credentials| `""`
`dpr.user` | user for authenticating with docker private registry. Only applicable if dpr.existingSecretName is empty | `""`
`dpr.server` | hostname/IP Address of the docker private registry. Only applicable if dpr.existingSecretName is empty | `""`
`dpr.password` | password for authentication with the selected docker private registry. Only applicable if dpr.existingSecretName is empty | `""`
`ecr.enabled` | enable the injection of elastic container registry credentials | `""`
`ecr.existingSecretName` | defines an existing secret (in kube-system namespace) containing the credentials| `""`
`ecr.awsAccessKeyId` | ID of the key used to access ECR. Not needed for machines within AWS. Only applicable if ecr.existingSecretName is empty | `""`
`ecr.awsSecretAccessKey` | secret of the key used to access ECR. Not needed for machines within AWS. Only applicable if ecr.existingSecretName is empty | `""`
`ecr.awsAccount` | comma separated list of AWS Account Ids. Only applicable if ecr.existingSecretName is empty | `""`
`ecr.awsRegion`  | optional AWS region to override the default. Only applicable if ecr.existingSecretName is empty | `""`
`ecr.awsAssumeRole` | optional role to be assumed by AWS and used to retrieve tokens. Only applicable if ecr.existingSecretName is empty | `""`
`gcr.enabled` | enables the injection of google container registry credentials | `false`
`gcr.existingSecretName` | defines an existing secret (in kube-system namespace) containing the credentials| `""`
`gcr.applicationDefaultCredentialsJson` | JSON representing google cloud credentials. Only applicable if gcr.existingSecretName is empty | `""`
`gcr.url` | URL for google container registry. Only applicable if gcr.existingSecretName is empty | `"https://gcr.io"`
`rbac.enabled` | enables the usage of RBAC for registry-creds (needed for clusters with RBAC enabled) | `true`
`rbac.existingServiceAccountName` | name of an existing service account to be used for RBAC permissions. If not defined a new service account will be created by the chart | `""`
`resources.limits`.memory | memory resource limit | `"100Mi"`
`resources.limits`.cpu | cpui resource limit | `"200m"`
`resources.requests`.memory | memory resource request | `"50Mi"`
`resources.requests`.cpu | cpu resource request | `"40m"`
`tolerations` | List of node taints to tolerate  | `[]`
`nodeSelector` | Node labels for pod assignment | `{}`
`affinity` | Node affinity | `{}`