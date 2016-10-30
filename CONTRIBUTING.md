# Contributing guidelines

The Kubernetes Charts project accepts contributions via GitHub pull requests. This document outlines the process to help get your contribution accepted.

### Contributor License Agreements

We'd love to accept your patches! Before we can take them, we have to jump a couple of legal hurdles.

Please fill out either the individual or corporate Contributor License Agreement (CLA).

  * If you are an individual writing original source code and you're sure you own the intellectual property, then you'll need to sign an [individual CLA](http://code.google.com/legal/individual-cla-v1.0.html).
    * If you work for a company that wants to allow you to contribute your work, then you'll need to sign a [corporate CLA](http://code.google.com/legal/corporate-cla-v1.0.html).

Follow either of the two links above to access the appropriate CLA and instructions for how to sign and return it. Once we receive it, we'll be able to accept your pull requests.

***NOTE***: Only original source code from you and other people that have signed the CLA can be accepted into the main repository.

### Reporting a bug in Helm

This repository is used by Chart developers for maintaining the official charts for Kubernetes Helm. If your issue is in the Helm tool itself, please use the issue tracker in the [kubernetes/helm](https://github.com/kubernetes/helm) repository.

### How to contribute a Chart

1. If you haven't already done so, sign a Contributor License Agreement (see details above).
1. Fork this repository, develop and test your Chart.
1. Choose the correct folder for your chart based on the information in the [Repository Structure](README.md#repository-structure) section
1. Ensure your Chart follows the [technical](#technical-requirements) and [documentation](#documentation-requirements) guidelines, described below.
1. Submit a pull request.

#### Technical requirements

* All Chart dependencies should also be submitted independently
* Must pass the linter (`helm lint`)
* Must successfully launch with default values (`helm install .`)
    * All pods go to the running state
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

- GitHub issues: https://github.com/kubenetes/charts/issues/new
- Slack: #Helm room in the [Kubernetes Slack](http://slack.kubernetes.io/)

Before opening a new issue or submitting a new pull request, it's helpful to search the project - it's likely that another user has already reported the issue you're facing, or it's a known issue that we're already aware of.
