> This chart is deprecated in favor of the [official GitLab chart](https://docs.gitlab.com/ee/install/kubernetes/gitlab_chart.html).

# GitLab Enterprise Edition

[GitLab Enterprise Edition](https://about.gitlab.com/) is an application to code, test, and deploy code together. It provides Git repository management with fine grained access controls, code reviews, issue tracking, activity feeds, wikis, and continuous integration. 

## Introduction

This chart stands up a GitLab Enterprise Edition install. This includes:

- A [GitLab Omnibus](https://docs.gitlab.com/omnibus/) Pod
- Redis
- Postgresql

## Prerequisites

- _At least_ 3 GB of RAM available on your cluster, in chunks of 1 GB
- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- The ability to point a DNS entry or URL at your GitLab install

## Installing the Chart

To install the chart with the release name `my-release` run:

```bash
$ helm install --name my-release \
    --set externalUrl=http://your-domain.com/ stable/gitlab-ee
```

Note that you _must_ pass in externalUrl, or you'll end up with a non-functioning release.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults. These are a mixture of Kubernetes and GitLab-related directives.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set externalUrl=http://your-domain.com/,gitlabRootPassword=pass1234 \
    stable/gitlab-ee
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/gitlab-ee
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

By default, persistence of GitLab data and configuration happens using PVCs. If you know that you'll need a larger amount of space, make _sure_ to look at the `persistence` section in [values.yaml](values.yaml).

> *"If you disable persistence, the contents of your volume(s) will only last as long as the Pod does. Upgrading or changing certain settings may lead to data loss without persistence."*
