# AWS Pod Identity Webhook

This chart will install the [Amazon EKS Pod Identity Webhook](https://github.com/aws/amazon-eks-pod-identity-webhook). This tool allows you to specify IAM Roles for Kubernetes Service Accounts. This allows a pod to assume a IAM role.

Further details can be found here: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html

## Prerequisites

- Kubernetes 1.12+

For installation into a non-EKS cluster, see [Self-hosted Kubernetes setup](https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/SELF_HOSTED_SETUP.md)

## Installing the Chart

You first need to retrieve `ca.crt` from your cluster as this is used as a value for the chart:

```shell
secret_name=$(kubectl get sa default -o jsonpath='{.secrets[0].name}')
export CA_BUNDLE=$(kubectl get secret/$secret_name -o jsonpath='{.data.ca\.crt}' | tr -d '\n')
```

Then install the chart:

```shell
$ helm install --name my-release stable/aws-pod-identity-webhook --set caBundle="${CA_BUNDLE}"
```

After installation you need to approve the certificate. Follow the chart notes after installation for this step.

The webhook will request a new CSR prior expiry in 1 year. This new CSR will also need to be manually approved.

## Uninstalling the Chart

To delete the chart:

```shell
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters for this chart and their default values.

| Parameter              | Description                           | Default                                                                 |
| -----------------------|---------------------------------------|-------------------------------------------------------------------------|
| `image.repository`     | Image repository                      | `602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/pod-identity-webhook` |
| `image.tag`            | Image tag                             | `latest`                                                                |
| `image.pullPolicy`     | Container pull policy                 | `IfNotPresent`                                                          |
| `fullnameOverride`     | Override the fullname of the chart    | `nil`                                                                   |
| `nameOverride`         | Override the name of the chart        | `nil`                                                                   |
| `priorityClassName`    | Set a priority class for pod          | `nil`                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters:

```shell
$ helm install --name my-release stable/aws-pod-identity-webhook --values values.yaml
```
