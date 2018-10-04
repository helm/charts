# Portworx

[Portworx](https://portworx.com/) is a software defined persistent storage solution designed and purpose built for applications deployed as containers, via container orchestrators such as Kubernetes, Marathon and Swarm. It is a clustered block storage solution and provides a Cloud-Native layer from which containerized stateful applications programmatically consume block, file and object storage services directly through the scheduler.

## Pre-requisites
The helm chart (portworx-helm) deploys Portworx and STork(https://docs.portworx.com/scheduler/kubernetes/stork.html) on your Kubernetes cluster. The minimum requirements for deploying the helm chart are as follows:

- Helm has been installed on the client machine from where you would install the chart. (https://docs.helm.sh/using_helm/#installing-helm)
- Tiller version 2.9.0 and above is running on the Kubernetes cluster where you wish to deploy Portworx.
- Tiller has been provided with the right RBAC permissions for the chart to be deployed correctly.
- Kubernetes 1.7+
- All [Pre-requisites](https://docs.portworx.com/#minimum-requirements). for Portworx fulfilled.

## Installing the Chart

To install the chart with the release name `my-release` run the following commands substituting relevant values for your setup:

##### NOTE:
`etcdEndPoint` is a required field. The chart installation would not proceed unless this option is provided.
If the etcdcluster being used is a secured ETCD (SSL/TLS) then please follow instructions to create a kubernetes secret with the certs. https://docs.portworx.com/scheduler/kubernetes/etcd-certs-using-secrets.html#create-kubernetes-secret


`clusterName` should be a unique name identifying your Portworx cluster. The default value is `mycluster`, but it is suggested to update it with your naming scheme.

For eg:
```
git clone https://github.com/portworx/helm.git
helm install --debug --name my-release --set etcdEndPoint=etcd:http://192.168.70.90:2379,clusterName=$(uuidgen) ./helm/charts/portworx/
```

## Configuration

The following tables lists the configurable parameters of the Portworx chart and their default values.

|             Parameter       |            Description             |                    Default                |
|-----------------------------|------------------------------------|-------------------------------------------|
| `deploymentType`            | The deployment type. Can be either docker/oci   | `oci`                 |
| `imageVersion`              | The image tag to pull              | `1.4.0`                                  |
| `openshiftInstall`               | Installing on Openshift? | `false`                               |
| `pksInstall`               | Installing on Pivotal Container service? | `false`                               |
| `AKSorEKSInstall`               | Installing on AKS(Azure Kubernetes service) or EKS (Amazon Elastic Container service) | `false`                               |
| `etcdEndPoint`          | (REQUIRED) ETCD endpoint for PX to function properly in the form "etcd:http://<your-etcd-endpoint>". Multiple Urls should be semi-colon seperated example: etcd:http://<your-etcd-endpoint1>;etcd:http://<your-etcd-endpoint2>  | `etcd:http://<your-etcd-endpoint>`                    |
| `clusterName`           | Portworx Cluster Name  | `mycluster`                                     |
| `usefileSystemDrive`      | Should Portworx use an unmounted drive even with a filesystem ? | `false`                |
| `usedrivesAndPartitions`  | Should Portworx use the drives as well as partitions on the disk ? | `false`             |
| `secretType`      | Secrets store to be used can be AWS/KVDB/Vault          | `none`                                    |
| `drives` | Semi-colon seperated list of drives to be used for storage (example: "/dev/sda;/dev/sdb")           | `none`                                   |
| `dataInterface`   | Name of the interface <ethX>             | `none`                                   |
| `managementInterface`   | Name of the interface <ethX>             | `none`                                   |
| `envVars`  | semi-colon-separated list of environment variables that will be exported to portworx. (example: API_SERVER=http://lighthouse-new.portworx.com;MYENV1=val1;MYENV2=val2) | `none`                                    |
| `stork`    | [Storage Orchestration for Hyperconvergence](https://github.com/libopenstorage/stork).     | `true`       |
| `storkVersion`    | The version of stork     | `1.1.1`       |
| `customRegistryURL`    | Custom Docker registry     | `none`       |
| `registrySecret`   | Registry secret  | `none` |
| `journalDevice`    | Journal device for Portworx metadata     | `none`       |
| `csi`              | Enable CSI (Tech Preview only)           | `false`      |
| `internalKVDB`              | Internal KVDB store           | `false`      |
| `etcd.credentials`  | Username and password for ETCD authentication in the form user:password | `none:none`                                    |
| `etcd.certPath`  | Base path where the certificates are placed. (example: if the certificates ca,.crt and the .key are in /etc/pwx/etcdcerts the value should be provided as /etc/pwx/etcdcerts Refer: https://docs.portworx.com/scheduler/kubernetes/etcd-certs-using-secrets.html) | `none`                                    |
| `etcd.ca`  | Location of CA file for ETCD authentication. Should be /path/to/server.ca | `none`                                    |
| `etcd.cert`  | Location of certificate for ETCD authentication. Should be /path/to/server.crt | `none`                                    |
| `etcd.key`  | Location of certificate key for ETCD authentication Should be /path/to/servery.key | `none`                                    |
| `consul.acl`  | ACL token value used for Consul authentication. (example: 398073a8-5091-4d9c-871a-bbbeb030d1f6) | `none`                                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

> **Tip**: In this case the chart is located at `./helm/charts/portworx`, do change it as per your setup.
```
helm install --name my-release --set deploymentType=docker,imageVersion=1.2.12.0,etcdEndPoint=etcd:http://192.168.70.90:2379 ./helm/charts/portworx/
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,
```
helm install --name my-release -f ./helm/charts/portworx/values.yaml ./helm/charts/portworx
```
> **Tip**: You can use the default [values.yaml](values.yaml) and make changes as per your requirement

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:
The chart would follow the process as outlined here. (https://docs.portworx.com/scheduler/kubernetes/install.html#uninstall)

> **Tip** > The Portworx configuration files under `/etc/pwx/` directory are preserved, and will not be deleted.

```
helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

### Basic troubleshooting

#### Helm install errors with `no available release name found`

```
helm install --dry-run --debug --set etcdEndPoint=etcd:http://192.168.70.90:2379,clusterName=$(uuidgen) ./helm/charts/portworx/
[debug] Created tunnel using local port: '37304'
[debug] SERVER: "127.0.0.1:37304"
[debug] Original chart version: ""
[debug] CHART PATH: /root/helm/charts/portworx

Error: no available release name found
```
This most likely indicates that Tiller doesn't have the right RBAC permissions.
You can verify the tiller logs
```
[storage/driver] 2018/02/07 06:00:13 get: failed to get "singing-bison.v1": configmaps "singing-bison.v1" is forbidden: User "system:serviceaccount:kube-system:default" cannot get configmaps in the namespace "kube-system"
[tiller] 2018/02/07 06:00:13 info: generated name singing-bison is taken. Searching again.
[tiller] 2018/02/07 06:00:13 warning: No available release names found after 5 tries
[tiller] 2018/02/07 06:00:13 failed install prepare step: no available release name found
```

#### Helm install errors with  `Job failed: BackoffLimitExceeded`

```
helm install --debug --set dataInterface=eth1,managementInterface=eth1,etcdEndPoint=etcd:http://192.168.70.179:2379,clusterName=$(uuidgen) ./helm/charts/portworx/
[debug] Created tunnel using local port: '36389'

[debug] SERVER: "127.0.0.1:36389"

[debug] Original chart version: ""
[debug] CHART PATH: /root/helm/charts/portworx

Error: Job failed: BackoffLimitExceeded
```
This most likely indicates that the pre-install hook for the helm chart has failed due to a misconfigured or inaccessible ETCD url.
Follow the below steps to check the reason for failure.

```
kubectl get pods -nkube-system -a | grep preinstall
px-etcd-preinstall-hook-hxvmb   0/1       Error     0          57s

kubectl logs po/px-etcd-preinstall-hook-hxvmb -nkube-system
Initializing...
Verifying if the provided etcd url is accessible: http://192.168.70.179:2379
Response Code: 000
Incorrect ETCD URL provided. It is either not reachable or is incorrect...

```
Ensure the correct etcd URL is set as a parameter to the `helm install` command.
```

```

#### Helm install errors with `Job failed: Deadline exceeded`

```
helm install --debug --set dataInterface=eth1,managementInterface=eth1,etcdEndPoint=etcd:http://192.168.20.290:2379,clusterName=$(uuidgen) ./charts/portworx/
[debug] Created tunnel using local port: '39771'

[debug] SERVER: "127.0.0.1:39771"

[debug] Original chart version: ""
[debug] CHART PATH: /root/helm/charts/portworx

Error: Job failed: DeadlineExceeded
```
This error indicates that the pre-install hook for the helm chart has failed to run to completion correctly. Verify that the etcd URL is accessible. This error occurs on kubernetes cluster(s) with version below 1.8
Follow the below steps to check the reason for failure.

```
kubectl get pods -nkube-system -a | grep preinstall
px-hook-etcd-preinstall-dzmkl    0/1       Error     0          6m
px-hook-etcd-preinstall-nlqwl    0/1       Error     0          6m
px-hook-etcd-preinstall-nsjrj    0/1       Error     0          5m
px-hook-etcd-preinstall-r9gmz    0/1       Error     0          6m

kubectl logs po/px-hook-etcd-preinstall-dzmkl -nkube-system
Initializing...
Verifying if the provided etcd url is accessible: http://192.168.20.290:2379
Response Code: 000
Incorrect ETCD URL provided. It is either not reachable or is incorrect...
```
Ensure the correct etcd URL is set as a parameter to the `helm install` command.
