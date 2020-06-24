# Rundeck Community Helm Chart

Rundeck lets you turn your operations procedures into self-service jobs. Safely give others the control and visibility they need. Read more about Rundeck at [https://www.rundeck.com/open-source](https://www.rundeck.com/open-source).


## Install

    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm install incubator/rundeck

## Configuration

The following configurations may be set. It is recommended to use values.yaml for overwriting the Rundeck config.

Parameter | Description | Default
--------- | ----------- | -------
deployment.replicaCount | How many replicas to run. Rundeck can really only work with one. | 1
deployment.annotations | You can pass annotations inside deployment.spec.template.metadata.annotations. Useful for KIAM/Kube2IAM and others for example. | {}
deployment.strategy | Sets the K8s rollout strategy for the Rundeck deployment | { type: RollingUpdate }
image.repository | Name of the image to run, without the tag. | [rundeck/rundeck](https://github.com/rundeck/rundeck)
image.tag | The image tag to use. | 3.2.7
image.pullPolicy | The kubernetes image pull policy. | IfNotPresent
service.type | The kubernetes service type to use. | ClusterIP
service.port | The tcp port the service should listen on. | 80
ingress | Any ingress rules to apply. | None
resources | Any resource constraints to apply. | None
rundeck.adminUser | The config to set up the admin user that should be placed at the realm.properties file. | "admin:admin,user,admin,architect,deploy,build"
rundeck.env | The rundeck environment variables that you would want to set | Default variables provided in docker file
rundeck.sshSecrets | A reference to the Kubernetes Secret that contains the ssh keys. | ""
rundeck.awsCredentialsSecret | A reference to the Kubernetes Secret that contains the aws credentials. | ""
nginxConfOverride | An optional multi-line value that can replace the default nginx.conf. | ""
persistence.enabled | Whether or not to attach persistent storage to the Rundeck pod | false
persistence.claim.create | Whether the helm chart should create a persistent volume claim. See the values.yaml for more claim options | false
persistence.awsVolumeId | A Volume ID from a pre-existent AWS EBS volume to persist Rundeck data from /home/rundeck/server/data path. | None
persistence.existingClaim | Name of an existing volume claim | None
serviceAccount.create | Set to true to create a service account for the Rundeck pod | false
serviceAccount.annotations | A map of annotations to attach to the service account (eg: AWS IRSA) | {}
serviceAccount.name | Name of the service account the Rundeck pod should use | ""
