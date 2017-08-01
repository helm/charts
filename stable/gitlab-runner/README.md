# GitLab Runner

[GitLab Runner](https://docs.gitlab.com/runner) is the open source project that is used to run your jobs and send the results back to GitLab. It is used in conjunction with [GitLab CI](https://about.gitlab.com/gitlab-ci/), the open-source continuous integration service included with GitLab that coordinates the jobs.

## Introduction

This chart deploys a GitLab Runner instance configured to run using the [Kubernetes executor](https://docs.gitlab.com/runner/install/kubernetes.html)

For each new job it recieves from [GitLab CI](https://about.gitlab.com/gitlab-ci/), it will provision a new pod within the specified namespace to run it.

## Prerequisites

- _At least_ 2 vCPUs available on your cluster
- Kubernetes 1.4+ with Beta APIs enabled
- Your GitLab Server's API is reachable from the cluster

## Installing the Chart

To install the chart with the release name `my-release` run:

```bash
$ helm install --name my-release \
    --set gitlabUrl=http://gitlab.your-domain.com/,runnerRegistrationToken=your-token \
    stable/gitlab-runner
```

Note that you _must_ pass in gitlabUrl and runnerRegistrationToken, or you'll end up with a non-functioning release.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults. These are a mixture of Kubernetes and GitLab Runner-related directives.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set gitlabUrl=http://gitlab.your-domain.com/,runnerRegistrationToken=your-token,concurrent=4 \
    stable/gitlab-runner
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/gitlab-runner
```

> **Tip**: You can use the default [values.yaml](values.yaml)
