# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Rundeck Community Helm Chart

Rundeck lets you turn your operations procedures into self-service jobs. Safely give others the control and visibility they need. Read more about Rundeck at [https://www.rundeck.com/open-source](https://www.rundeck.com/open-source).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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
image.pullSecrets | The kubernetes secret to pull the image from a private registry. | None
service.type | The kubernetes service type to use. | ClusterIP
service.port | The tcp port the service should listen on. | 80
ingress | Any ingress rules to apply. | None
resources | Any resource constraints to apply. | None
rundeck.adminUser | The config to set up the admin user that should be placed at the realm.properties file. | "admin:admin,user,admin,architect,deploy,build"
rundeck.env | The rundeck environment variables that you would want to set | Default variables provided in docker file
rundeck.envSecret | Name of secret containing environment variables to add to the Rundeck deployment | ""
rundeck.sshSecrets | A reference to the Kubernetes Secret that contains the ssh keys. | ""
rundeck.awsConfigSecret | Name of secret to mount under the `~/.aws/` directory. Useful when AWS IRSA is not an option. | ""
rundeck.kubeConfigSecret | Name of secret to mount under the `~/.kube/` directory. Useful when Rundeck needs configuration for multiple K8s clusters. | ""
rundeck.extraConfigSecret | Name of secret containing additional files to mount at `~/extra/`. Can be useful for working with RUNDECK_TOKENS_FILE configuration | ""
nginxConfOverride | An optional multi-line value that can replace the default nginx.conf. | ""
persistence.enabled | Whether or not to attach persistent storage to the Rundeck pod | false
persistence.claim.create | Whether the helm chart should create a persistent volume claim. See the values.yaml for more claim options | false
persistence.awsVolumeId | A Volume ID from a pre-existent AWS EBS volume to persist Rundeck data from /home/rundeck/server/data path. | None
persistence.existingClaim | Name of an existing volume claim | None
serviceAccount.create | Set to true to create a service account for the Rundeck pod | false
serviceAccount.annotations | A map of annotations to attach to the service account (eg: AWS IRSA) | {}
serviceAccount.name | Name of the service account the Rundeck pod should use | ""
volumes | volumes made available to all containers | ""
volumeMounts | volumeMounts to add to the rundeck container | ""
initContainers | can be used to download plugins or customise your rundeck installation | ""
sideCars | can be used to run additional containers in the pod | ""

## AWS & K8s Permissions

If Rundeck jobs need access to the AWS or Kubernetes APIs this chart provides a couple options.

### AWS IRSA
If running Rundeck in AWS on EKS, [AWS IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html) can be used to grant Rundeck IAM permissions by adding the appropriate annotation at `serviceAccount.annotations` (see `./values.yaml` for example). This can also be used to grant access to other EKS K8s APIs by adding the proper role bindings in those clusters that reference the IAM user.

### AWS & K8s
The `rundeck.awsConfigSecret` and `rundeck.kubeConfigSecret` keys allow for mounting additional configuration for AWS and Kubernetes tools and SDKs. The secrets are mounted into their respective configuration directories under the Rundeck users's home directory. 

For example, you can create a secret containing kubeconfig file content that can be used to configure authentication to another remote cluster via the AWS IAM authenticator. Combine this with an AWS IRSA annotation on the Rundeck service account and you can configure Rundeck to auth to multiple EKS clusters' APIs accross multiple AWS accounts without ever needing to manage AWS IAM API keys or K8s credentials.
```yaml
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: rundeck-kube-config
  namespace: rundeck
stringData:
  config: |-
    apiVersion: v1
    kind: Config
    clusters:
    - cluster:
        certificate-authority-data: LS0tLS1CRUdJ[YOUR_CLUSTER_CA_INFO]tLQo=
        server: https://[your_eks_server_id].sk1.us-west-2.eks.amazonaws.com
    name: staging
    contexts:
    - context:
        cluster: staging
        user: admin
        namespace: default
    name: stating
    current-context: staging
    preferences: {}
    users:
    - name: admin
    user:
        exec:
        apiVersion: client.authentication.k8s.io/v1alpha1
        args:
        - token
        - -i
        - staging
        command: aws-iam-authenticator
```

Note that the Rundeck Docker image does not currently include the [Kubernetes plugin](https://github.com/rundeck-plugins/kubernetes) nor the `aws-iam-authenticator`, `kubectl`, and `aws` command line tools. All of these may be added to the Rundeck image by extending the Dockerfile with additional install steps.

An example Dockerfile that adds the Rundeck k8s module and needed CLI tools:
```Dockerfile
ARG RUNDECK_IMAGE
FROM ${RUNDECK_IMAGE:-rundeck/rundeck:3.2.6-20200427}

# Kubernetes support
USER root
RUN apt-get update && sudo apt-get install -y apt-transport-https gnupg2
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y \
  kubectl \
  apt-transport-https \
  gnupg2 \
  python3-pip \
  awscli \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install kubernetes requests==2.22.0
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install aws-iam-authenticator
RUN curl -o aws-iam-authenticator \
  https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x ./aws-iam-authenticator && \
  mv aws-iam-authenticator /usr/local/bin

USER rundeck
ADD --chown=rundeck:root https://github.com/rundeck-plugins/kubernetes/releases/download/1.0.15/kubernetes-plugin-1.0.15.zip ./libext/
```
