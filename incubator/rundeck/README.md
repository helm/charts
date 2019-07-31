# Rundeck Community Helm Chart

Rundeck lets you turn your operations procedures into self-service jobs. Safely give others the control and visibility they need. Read more about Rundeck at [https://www.rundeck.com/open-source](https://www.rundeck.com/open-source).


## Install

    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm install incubator/rundeck

## Configuration

The following configurations may be set. It is recommended to use values.yaml for overwriting the Riemann config.

Parameter | Description | Default
--------- | ----------- | -------
replicaCount | How many replicas to run. Riemann can really only work with one. | 1
image.repository | Name of the image to run, without the tag. | [rundeck/rundeck](https://github.com/rundeck/rundeck)
image.tag | The image tag to use. | 3.0.16
image.pullPolicy | The kubernetes image pull policy. | IfNotPresent
service.type | The kubernetes service type to use. | ClusterIP
service.port | The tcp port the service should listen on. | 80
ingress | Any ingress rules to apply. | None
resources | Any resource constraints to apply. | None
rundeck.adminUser | The config to set up the admin user that should be placed at the realm.properties file. | "admin:admin,user,admin,architect,deploy,build"
rundeck.env | The rundeck environment variables that you would want to set | Default variables provided in docker file
rundeck.sshSecrets | A reference to the Kubernetes Secret that contains the ssh keys. | ""
rundeck.awsCredentialsSecret | A reference to the Kubernetes Secret that contains the aws credentials. | ""
