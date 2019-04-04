# Contributing Guidelines

The Kubernetes Charts project accepts contributions via GitHub pull requests. This document outlines the process to help get your contribution accepted.

## Sign Your Work

The sign-off is a simple line at the end of the explanation for a commit. All 
commits needs to be signed. Your signature certifies that you wrote the patch or
otherwise have the right to contribute the material. The rules are pretty simple,
if you can certify the below (from [developercertificate.org](http://developercertificate.org/)):

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
1 Letterman Drive
Suite D4700
San Francisco, CA, 94129

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.

Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

Then you just add a line to every git commit message:

    Signed-off-by: Joe Smith <joe.smith@example.com>

Use your real name (sorry, no pseudonyms or anonymous contributions.)

If you set your `user.name` and `user.email` git configs, you can sign your
commit automatically with `git commit -s`.

Note: If your git config information is set properly then viewing the
 `git log` information for your commit will look something like this:

```
Author: Joe Smith <joe.smith@example.com>
Date:   Thu Feb 2 11:41:15 2018 -0800

    Update README

    Signed-off-by: Joe Smith <joe.smith@example.com>
```

Notice the `Author` and `Signed-off-by` lines match. If they don't
your PR will be rejected by the automated DCO check.

### Reporting a Bug in Helm

This repository is used by Chart developers for maintaining the official charts for Kubernetes Helm. If your issue is in the Helm tool itself, please use the issue tracker in the [helm/helm](https://github.com/helm/helm) repository.

## How to Contribute a Chart

1. Fork this repository, develop and test your Chart. Remember to sign off your commits as described in the "Sign Your Work" chapter.
1. Choose the correct folder for your chart based on the information in the [Repository Structure](README.md#repository-structure) section
1. Ensure your Chart follows the [technical](#technical-requirements) and [documentation](#documentation-requirements) guidelines, described below.
1. Submit a pull request.

***NOTE***: In order to make testing and merging of PRs easier, please submit changes to multiple charts in separate PRs.

### Technical requirements

* All Chart dependencies should also be submitted independently
* Must pass the linter (`helm lint`)
* Must successfully launch with default values (`helm install .`)
    * All pods go to the running state (or NOTES.txt provides further instructions if a required value is missing e.g. [minecraft](https://github.com/helm/charts/blob/master/stable/minecraft/templates/NOTES.txt#L3))
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
* Includes a [NOTES.txt](https://github.com/helm/helm/blob/master/docs/charts.md#chart-license-readme-and-notes) explaining how to use the application after install
* Follows [best practices](https://github.com/helm/helm/tree/master/docs/chart_best_practices)
  (especially for [labels](https://github.com/helm/helm/blob/master/docs/chart_best_practices/labels.md)
  and [values](https://github.com/helm/helm/blob/master/docs/chart_best_practices/values.md))

### Documentation requirements

* Must include an in-depth `README.md`, including:
    * Short description of the Chart
    * Any prerequisites or requirements
    * Customization: explaining options in `values.yaml` and their defaults
* Must include a short `NOTES.txt`, including:
    * Any relevant post-installation information for the Chart
    * Instructions on how to access the application or service provided by the Chart

### Merge approval and release process

A Kubernetes Charts maintainer will review the Chart submission, and start a validation job in the CI to verify the technical requirements of the Chart. A maintainer may add "LGTM" (Looks Good To Me) or an equivalent comment to indicate that a PR is acceptable. Any change requires at least one LGTM. No pull requests can be merged until at least one maintainer signs off with an LGTM.

Once the Chart has been merged, the release job will automatically run in the CI to package and release the Chart in the [`gs://kubernetes-charts` Google Storage bucket](https://console.cloud.google.com/storage/browser/kubernetes-charts/).

## Support Channels

Whether you are a user or contributor, official support channels include:

- GitHub issues: https://github.com/helm/charts/issues
- Slack: Helm Users - #Helm-users room in the [Kubernetes Slack](http://slack.kubernetes.io/)
- Slack: Helm Developers - #Helm-dev room in the [Kubernetes Slack](http://slack.kubernetes.io/)

Before opening a new issue or submitting a new pull request, it's helpful to search the project - it's likely that another user has already reported the issue you're facing, or it's a known issue that we're already aware of.
