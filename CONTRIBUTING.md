# Contributing Guidelines

The Kubernetes Charts project accepts contributions via GitHub pull requests. This document outlines the process to help get your contribution accepted.

### Contributor License Agreements

We'd love to accept your patches! Before we can take them, we have to jump a couple of legal hurdles.

The Cloud Native Computing Foundation (CNCF) CLA [must be signed](https://github.com/kubernetes/community/blob/master/CLA.md) by all contributors.
Please fill out either the individual or corporate Contributor License
Agreement (CLA).

Once you are CLA'ed, we'll be able to accept your pull requests. For any issues that you face during this process,
please add a comment [here](https://github.com/kubernetes/kubernetes/issues/27796) explaining the issue and we will help get it sorted out.

***NOTE***: Only original source code from you and other people that have signed the CLA can be accepted into the main repository.

### Reporting a Bug in Helm

This repository is used by Chart developers for maintaining the official charts for Kubernetes Helm. If your issue is in the Helm tool itself, please use the issue tracker in the [kubernetes/helm](https://github.com/kubernetes/helm) repository.

### How to Contribute a Chart

1. If you haven't already done so, sign a Contributor License Agreement (see details above).
1. Fork this repository, develop and test your Chart.
1. Choose the correct folder for your chart based on the information in the [Repository Structure](README.md#repository-structure) section
1. Ensure your Chart follows the [technical](#technical-requirements) and [documentation](#documentation-requirements) guidelines, described below.
1. Submit a pull request.

***NOTE***: In order to make testing and merging of PRs easier, please submit changes to multiple charts in separate PRs.

#### Technical requirements

* All Chart dependencies should also be submitted independently
* Must pass the linter (`helm lint`)
* Must successfully launch with default values (`helm install .`)
    * All pods go to the running state (or NOTES.txt provides further instructions if a required value is missing e.g. [minecraft](https://github.com/kubernetes/charts/blob/master/stable/minecraft/templates/NOTES.txt#L3))
    * All services have at least one endpoint
* Must include source GitHub repositories for images used in the Chart
* Images should not have any major security vulnerabilities
* Must be up-to-date with the latest stable Helm/Kubernetes features
    * Use Deployments in favor of ReplicationControllers
* Should follow Kubernetes best practices
    * Include Health Checks wherever practical
    * Allow configurable [resource requests and limits](http://kubernetes.io/docs/user-guide/compute-resources/#resource-requests-and-limits-of-pod-and-container)
* Provide a method for data persistence (if applicable)
* Support application upgrades
* Allow customization of the application configuration
* Provide a secure default configuration
* Do not leverage alpha features of Kubernetes
* Includes a [NOTES.txt](https://github.com/kubernetes/helm/blob/master/docs/charts.md#chart-license-readme-and-notes) explaining how to use the application after install
* Follows [best practices](https://github.com/kubernetes/helm/tree/master/docs/chart_best_practices)
  (especially for [labels](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/labels.md)
  and [values](https://github.com/kubernetes/helm/blob/master/docs/chart_best_practices/values.md))

#### Documentation requirements

* Must include an in-depth `README.md`, including:
    * Short description of the Chart
    * Any prerequisites or requirements
    * Customization: explaining options in `values.yaml` and their defaults
* Must include a short `NOTES.txt`, including:
    * Any relevant post-installation information for the Chart
    * Instructions on how to access the application or service provided by the Chart

#### Merge approval and release process

A Kubernetes Charts maintainer will review the Chart submission, and start a validation job in the CI to verify the technical requirements of the Chart. A maintainer may add "LGTM" (Looks Good To Me) or an equivalent comment to indicate that a PR is acceptable. Any change requires at least one LGTM. No pull requests can be merged until at least one maintainer signs off with an LGTM.

Once the Chart has been merged, the release job will automatically run in the CI to package and release the Chart in the [`gs://kubernetes-charts` Google Storage bucket](https://console.cloud.google.com/storage/browser/kubernetes-charts/).

### Support Channels

Whether you are a user or contributor, official support channels include:

- GitHub issues: https://github.com/kubenetes/charts/issues
- Slack: Helm Users - #Helm-users room in the [Kubernetes Slack](http://slack.kubernetes.io/)
- Slack: Helm Developers - #Helm-dev room in the [Kubernetes Slack](http://slack.kubernetes.io/)

Before opening a new issue or submitting a new pull request, it's helpful to search the project - it's likely that another user has already reported the issue you're facing, or it's a known issue that we're already aware of.
