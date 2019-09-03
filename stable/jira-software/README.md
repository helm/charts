# Jira Software

[JIRA Software](https://www.atlassian.com/software/jira) is the project management tool for agile teams.

This chart bootstraps a deployment with the [atlassian/jira-software](https://hub.docker.com/r/atlassian/jira-software/) image on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Testing the Chart

To test the chart:
```shell
$ helm install --dry-run --debug ./
```

To test the chart with your own values:
```shell
$ helm install --dry-run --debug -f test-values.yaml ./
```
