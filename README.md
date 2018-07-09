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
gcloud container clusters create yugabyte --zone us-west1-b
```
#### Creating node pool to use
If not created already, you can create a new node pool
```
gcloud container node-pools create node-pool-8cpu-2ssd \
      --cluster=yugabyte \
      --local-ssd-count=2 \
      --machine-type=n1-standard-8 \
      --num-nodes=3 \
      --zone=us-west1-b
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
If the helm init was successful then you can go ahead and run the helm install command to install the yugabyte helm chart 
```
helm install yugabyte --namespace yb-demo --name yb-demo --wait
```

Follow the instructions on the NOTES section.

