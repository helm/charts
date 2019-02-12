# YugaByte using Helm Charts

This page has details on deploying YugaByte DB on [Kubernetes](https://kubernetes.io) using the `Helm Charts` feature. [Helm Charts](https://github.com/kubernetes/charts) can be used to deploy YugaByte on configuration that customer prefers.

## Requirements
### Install Helm: 2.8.0 or later
You can install helm by following [these instructions](https://github.com/kubernetes/helm#install).
You can check the version of helm installed using the following command:
```
helm version
Client: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
```

## Create Kubernetes clusters and node pools created
Inorder for you to install YugaByte db using helm you need have a kubernetes cluster created and make sure it has node pools created as well.

#### Creating new cluster
If not already created, you can create a new kubernetes cluster by running the below command:
```
gcloud container clusters create yugabyte-demo --zone us-west1-b --machine-type=n1-standard-8
```

#### Update the local credentials
Fetch the credentials for the newly created kubernetes cluster by running the below command:
```
gcloud container clusters get-credentials yugabyte-demo --zone us-west1-b
```

## Running YugaByte using helm charts

### Creating YugaByte RBAC on your kubernetes cluster
In order to install helm package you need to have a service account with certain cluster role binding, if you don't already have such service account
you can run the yugabyte-rbac.yaml to create a service account.
```
kubectl create -f yugabyte-rbac.yaml
```

### Initiatlizing helm and tiller on your kubernetes cluster
If you ran the yugabyte-rbac.yaml script above, your service account name would be `yugabyte-helm` if not make a note of the service account with necessary
helm privileges and initialize helm/tiller with that service account
```
helm init --service-account yugabyte-helm --upgrade --wait
```

### Installing YugaByte helm package on your kubernetes cluster
If the helm init was successful then you can go ahead and run the helm install command to install the yugabyte helm chart, this would go with default resources and replication of 3.
```
helm install yugabyte --namespace yb-demo --name yb-demo --wait
```

### Overriding YugaByte helm package with custom resources
If you want to override the default resources for the yugabyte pods, you could do so using helm

#### Creating YugaByte cluster with 5 nodes
```
helm install yugabyte --set replicas.tserver=5 --namespace yb-demo --name yb-demo --wait
```

#### Creating YugaByte cluster with custom resource
```
helm install yugabyte --set resource.tserver.requests.cpu=8,resource.tserver.requests.memory=15Gi --namespace yb-demo --name yb-demo
```

#### Creating YugaByte cluster with resource upper limits
```
helm install yugabyte --set resource.tserver.limits.cpu=16,resource.tserver.limits.memory=30Gi --namespace yb-demo --name yb-demo --wait
```

#### Creating YugaByte cluster with Cassandra authentication enabled.
```
helm install yugabyte --set gflags.tserver.use_cassandra_authentication=true --namespace yb-demo --name yb-demo --wait
```

#### Create YugaByte cluster with larger disk.
The default helm chart brings up a YugaByte DB with 10Gi for master nodes and 10Gi for tserver nodes. You override those defaults as below.
```
helm install yugabyte --set storage.tserver.size=100Gi --namespace yb-demo --name yb-demo --wait
```

#### Create YugaByte cluster with different storage class.
```
helm install yugabyte --set storage.tserver.storageClass=custom-storage,storage.master.storageClass=custom-storage --namespace yb-demo --name yb-demo --wait
```

### Exposing YugaByte service endpoints using LoadBalancer
By default YugaByte helm would expose the master ui endpoint alone via LoadBalancer. If you wish to expose yql, yedis services
via LoadBalancer for your app to use, you could do that in couple of different ways.

#### Exposing individual service endpoint
If you want individual LoadBalancer endpoint for each of the services (YQL, YEDIS), run the following command
```
helm install yugabyte -f expose-all.yaml --namespace yb-demo --name yb-demo --wait
```

#### Exposing shared service endpoint
If you want to create a shared LoadBalancer endpoint for all the services (YQL, YEDIS), run the following command
```
helm install yugabyte -f expose-all-shared.yaml --namespace yb-demo --name yb-demo --wait
```
#### Enable TLS for YugaByte (Note: This is only available for Enterprise Edition)
The assumption here is you already have the pull secret installed to pull from our private Enterprise Edition registry
```
helm install yugabyte --namespace yb-demo --name yb-demo --set=tls.enabled=true --set=Image.repository=quay.io/yugabyte/yugabyte --set=Image.pullSecretName=yugabyte-k8s-pull-secret --wait
```

Follow the instructions on the NOTES section.
