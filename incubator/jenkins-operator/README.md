# ⚠️ DEPRECATED

Please consider using https://github.com/jenkinsci/kubernetes-operator. See https://jenkinsci.github.io/kubernetes-operator/docs/installation/#using-helm-chart for instructions.
# Jenkins Operator

[jenkins-operator](https://github.com/samsung-cnct/jenkins-operator) simplifies
Jenkins configuration and management.

**DISCLAIMER:** This application and chart are alpha quality. Proceed with care.

## Introduction

The jenkins operator manages Jenkins instances deployed to [Kubernetes](https://k8s.io) and automates tasks related to operating a Jenkins server

- Create and Destroy instances
- Configure instances via [Jenkins-Configuration-As-code plugin](https://github.com/jenkinsci/configuration-as-code-plugin)

For more information on using the operator please see [the documentation](https://github.com/samsung-cnct/jenkins-operator).

## Prerequisites

- Kubernetes 1.11+
- Jenkins 2.1+

## Installing the Chart

To install the chart with the release name `jenkins-operator` checkout this repository and run the following command from the root of it:

```bash
$ helm install deployments/helm/jenkins-operator --name jenkins-operator
```

## Uninstalling the Chart

To uninstall/delete the `jenkins-operator` deployment:

```bash
$ helm delete jenkins-operator
```

## Configuration

The following table lists the configurable parameters of the jenkins-operator chart and their default values.

| Parameter            | Description                                                      | Default                                      |
| -------------------- | ---------------------------------------------------------------- | -------------------------------------------- |
| `replicaCount`       | Number of operator replicas to create                            | `1`                                          |
| `image.repository`   | Operator container image, including version                      | `quay.io/samsung_cnct/jenkins-operator`      |
| `image.tag`          | Operator container image tag                                     | `0.1.7`                                      |
| `image.pullPolicy`   | Operator container image pull policy                             | `IfNotPresent`                               |
| `nameOverride`       | Override the app name                                            |                                              |
| `fullnameOverride`   | Override the app full name                                       |                                              |
| `keepCRDs`           | If Helm should skip deleting CRDs when the operator is deleted   | `false`                                      |
| `rbac`               | Install required RBAC service account, roles and rolebindings    | `true`                                       |
| `chartCrds`          | If the CRDs should be installed from chart templates             | `true`                                       |
| `args`               | Arguments passed to the operator binary                          | `--alsologtostderr --install-crds=false`     |
| `resources.cpu`      | CPU limit per jenkins-operator pod                               |                                              |
| `resources.memory`   | Memory limit per jenkins-operator pod                            |                                              |
| `nodeSelector`       | Node labels for jenkins-operator pod assignment                  | `{}`                                         |
| `tolerations`        | Tolerations for pod assignment                                   | `[]`                                         |
| `affinity`           | Affinity settings for pod assignment                             | `{}`                                         |
