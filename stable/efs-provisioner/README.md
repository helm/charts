# Helm chart for 'efs-provisioner'

The Kubernetes project provides an AWS [EFS provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/aws/efs)
that is used to fulfill PersistentVolumeClaims with EFS PersistentVolumes.

"The efs-provisioner allows you to mount EFS storage as PersistentVolumes in kubernetes.
It consists of a container that has access to an AWS EFS resource. The container reads
a configmap which contains the EFS filesystem ID, the AWS region and the name you want
to use for your efs-provisioner. This name will be used later when you create a storage class."

This chart deploys the EFS Provisioner and a StorageClass for EFS volumes (optionally as the default).

The EFS external storage provisioner runs in a Kubernetes cluster and will create persistent volumes
in response to the PersistentVolumeClaim resources being created. These persistent volumes can then be
mounted on containers.

  https://kubernetes.io/docs/concepts/storage/persistent-volumes/

The persisent volumes are created as folders with in an AWS EFS filesystem.

  https://aws.amazon.com/efs/

## Prequisites

You must create the EFS file system and end points yourself first.

  https://docs.aws.amazon.com/efs/latest/ug/creating-using-create-fs.html

The end points must be accessible to the cluster and the cluster nodes must have
permission to mount EFS file systems.

## Configuring

At a minimum you must the supply the EFS file system ID and the AWS region

```
helm install stable/efs-provisioner --set efsProvisioner.efsFileSystemId=fs-12345678 --set efsProvisioner.awsRegion=us-east-2
```

All the values documented below and by `helm inspect values`.

```
helm inspect values stable/efs-provisioner
```

```
#
# Default values for EFS provisioner service
# https://github.com/kubernetes-incubator/external-storage/tree/master/aws/efs
#

## Deploy environment label, e.g. dev, test, prod
##
global:
  deployEnv: dev

## Containers
##
replicaCount: 1
revisionHistoryLimit: 10
image:
  repository: quay.io/external_storage/efs-provisioner
  tag: v2.2.0-k8s1.12
  pullPolicy: IfNotPresent

busyboxImage:
  repository: gcr.io/google_containers/busybox
  tag: 1.27
  pullPolicy: IfNotPresent

## Deployment annotations
##
annotations: {}

## Configure provisioner
## https://github.com/kubernetes-incubator/external-storage/tree/master/aws/efs#deployment
##
efsProvisioner:
  # If specified, use this DNS or IP to connect the EFS
  #dnsName: "my-custom-efs-dns.com"
  efsFileSystemId: fs-12345678
  awsRegion: us-east-2
  path: /example-pv
  provisionerName: example.com/aws-efs
  storageClass:
    name: efs
    isDefault: false
    gidAllocate:
      enabled: true
      gidMin: 40000
      gidMax: 50000
    reclaimPolicy: Delete
    mountOptions: []
      # - acregmin=3
      # - acregmax=60

## Enable RBAC
## Leave serviceAccountName blank for the default name
##
rbac:
  create: true
  serviceAccountName: ""

## Annotations to be added to deployment
##
podAnnotations: {}
  # iam.amazonaws.com/role: efs-provisioner-role

## Node labels for pod assignment
##
nodeSelector: {}

# Affinity for pod assignment
# Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
affinity: {}

# Tolerations for node tains
tolerations: {}

## Configure resources
##
resources: {}
  # To specify resources, uncomment the following lines, adjust them as necessary,
  # and remove the curly braces after 'resources:'.
  # limits:
  #  cpu: 200m
  #  memory: 128Mi
  # requests:
  #  cpu: 100m
  #  memory: 128Mi
```
