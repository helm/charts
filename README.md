# Helm Charts

Use this repository to submit official Charts for Helm. Charts are curated application definitions for Helm. For more information about installing and using Helm, see its
[README.md](https://github.com/helm/helm/tree/master/README.md). To get a quick introduction to Charts see this [chart document](https://github.com/helm/helm/blob/master/docs/charts.md).

## Where to find us

For general Helm Chart discussions join the Helm Charts (#charts) room in the [Kubernetes](http://slack.kubernetes.io/).

For issues and support for Helm and Charts see [Support Channels](CONTRIBUTING.md#support-channels).

## How do I install these charts?

Just `helm install stable/<chart>`. This is the default repository for Helm which is located at https://kubernetes-charts.storage.googleapis.com/ and is installed by default.

For more information on using Helm, refer to the [Helm documentation](https://github.com/kubernetes/helm#docs).

## How do I enable the Incubator repository?

To add the Incubator charts for your local client, run `helm repo add`:

```
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
"incubator" has been added to your repositories
```

You can then run `helm search incubator` to see the charts.

## Chart Format

Take a look at the [alpine example chart](https://github.com/helm/helm/tree/master/cmd/helm/testdata/testcharts/alpine) for reference when you're writing your first few charts.

Before contributing a Chart, become familiar with the format. Note that the project is still under active development and the format may still evolve a bit.

## Repository Structure

This GitHub repository contains the source for the packaged and versioned charts released in the [`gs://kubernetes-charts` Google Storage bucket](https://console.cloud.google.com/storage/browser/kubernetes-charts/) (the Chart Repository).

The Charts in the `stable/` directory in the master branch of this repository match the latest packaged Chart in the Chart Repository, though there may be previous versions of a Chart available in that Chart Repository.

The purpose of this repository is to provide a place for maintaining and contributing official Charts, with CI processes in place for managing the releasing of Charts into the Chart Repository.

The Charts in this repository are organized into two folders:

* stable
* incubator

Stable Charts meet the criteria in the [technical requirements](CONTRIBUTING.md#technical-requirements).

Incubator Charts are those that do not meet these criteria. Having the incubator folder allows charts to be shared and improved on until they are ready to be moved into the stable folder. The charts in the `incubator/` directory can be found in the [`gs://kubernetes-charts-incubator` Google Storage Bucket](https://console.cloud.google.com/storage/browser/kubernetes-charts-incubator).

In order to get a Chart from incubator to stable, Chart maintainers should open a pull request that moves the chart folder.

## Contributing a Chart

We'd love for you to contribute a Chart that provides a useful application or service for Kubernetes. Please read our [Contribution Guide](CONTRIBUTING.md) for more information on how you can contribute Charts.

Note: We use the same [workflow](https://github.com/kubernetes/community/blob/master/contributors/devel/development.md#workflow),
[License](LICENSE) and [Contributor License Agreement](CONTRIBUTING.md) as the main Kubernetes repository.

## Owning and Maintaining A Chart

Individual charts can be maintained by one or more users of GitHub. When someone maintains a chart they have the access to merge changes to that chart. To have merge access to a chart someone needs to:

1. Be listed on the chart, in the `Chart.yaml` file, as a maintainer. If you need sponsors and have contributed to the chart, please reach out to the existing maintainers, or if you are having trouble connecting with them, please reach out to one of the [OWNERS](OWNERS) of the charts repository.
1. Be invited (and accept your invite) as a read-only collaborator on [this repo](https://github.com/helm/charts). This is required for @k8s-ci-robot [PR comment interaction](https://github.com/kubernetes/community/blob/master/contributors/guide/pull-requests.md).
1. An OWNERS file needs to be added to a chart. That OWNERS file should list the maintainers' GitHub login names for both the reviewers and approvers sections. For an example see the [Drupal chart](stable/drupal/OWNERS). The `OWNERS` file should also be appended to the `.helmignore` file.

Once these three steps are done a chart approver can merge pull requests following the directions in the [REVIEW_GUIDELINES.md](REVIEW_GUIDELINES.md) file.

## Trusted Collaborator

The `pull-charts-e2e` test run, that installs a chart to test it, is required before a pull request can be merged. These tests run automatically for members of the Helm Org and for chart [repository collaborators](https://help.github.com/articles/adding-outside-collaborators-to-repositories-in-your-organization/). For regular contributors who are trusted, in a manner similar to Kubernetes community members, we have trusted collaborators. These individuals can have their tests run automatically as well as mark other pull requests as ok to test by adding a comment of `/ok-to-test` on pull requests.

There are two paths to becoming a trusted collaborator. One only needs follow one of them.

1. If you are a Kubernetes GitHub org member and have your Kubernetes org membership public you can become a trusted collaborator for Helm Charts
2. Get sponsorship from one of the Charts Maintainers listed in the OWNERS file at the root of this repository

The process to get added is:

* File an issue asking to be a trusted collaborator
* A Helm Chart Maintainer can then add the user as a read only collaborator to the repository

## Review Process

For information related to the review procedure used by the Chart repository maintainers, see [Merge approval and release process](CONTRIBUTING.md#merge-approval-and-release-process).

### Stale Pull Requests and Issues

Pull Requests and Issues that have no activity for 30 days automatically become stale. After 30 days of being stale, without activity, they become rotten. Pull Requests and Issues can rot for 30 days and then they are automatically closed. This is the standard stale process handling for all repositories on the Kubernetes GitHub organization.

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernertes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Status of the Project

This project is still under active development, so you might run into [issues](https://github.com/helm/charts/issues). If you do, please don't be shy about letting us know, or better yet, contribute a fix or feature.

## Happy Helming in China

If you are in China, there are some problems to use upstream Helm Charts directly (e.g. images hosted on `gcr.io`, `quay.io`, and Charts hosted on `googleapis.com` etc), you can use this mirror repo at https://github.com/cloudnativeapp/charts which automatically sync & replace unavailable image & repo URLs in every Chart.
