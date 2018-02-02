# Helm Charts

Use this repository to submit official Charts for Kubernetes Helm. Charts are curated application definitions for Kubernetes Helm. For more information about installing and using Helm, see its
[README.md](https://github.com/kubernetes/helm/tree/master/README.md). To get a quick introduction to Charts see this [chart document](https://github.com/kubernetes/helm/blob/master/docs/charts.md).

## Where to find us

For general Helm Chart discussions join the Helm Charts (#charts) room in the [Kubernetes](http://slack.kubernetes.io/).

For issues and support for Helm and Charts see [Support Channels](CONTRIBUTING.md#support-channels).


## How do I install these charts?

Just `helm install stable/<chart>`. This is the default repository for Helm which is located at https://kubernetes-charts.storage.googleapis.com/ and is installed by default.

For more information on using Helm, refer to the [Helm's documentation](https://github.com/kubernetes/helm#docs).

## How do I enable the Incubator repository?

To add the Incubator charts for your local client, run `helm repo add`:

```
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
"incubator" has been added to your repositories
```

You can then run `helm search incubator` to see the charts.

## Chart Format

Take a look at the [alpine example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/alpine) and the [nginx example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/nginx) for reference when you're writing your first few charts.

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

Individual charts can be maintained by one or more members of the Kubernetes community. When someone maintains a chart they have the access to merge changes for that chart. To have merge access for a chart someone first needs to be listed on the chart, in the `Chart.yaml` file, as a maintainer. If that is the case there are two steps that need to happen:

1. Become a [member of the Kubernetes community](https://github.com/kubernetes/community/blob/master/community-membership.md). If you need sponsors and have contributed to charts please reach out to one of the [OWNERS](OWNERS) of the charts repository.
2. An OWNERS file needs to be added for a chart. That OWNERS file should list the maintainers GitHub Login names for both the reviewers and approvers sections. For an example see the [Drupal chart](stable/drupal/OWNERS). The `OWNERS` file should also be appended to the `.helmignore` file.

Once these two steps are done a chart approver can merge pull requests following the directions in the [REVIEW_GUIDELINES.md](REVIEW_GUIDELINES.md) file. 

## Review Process

The following outlines the review procedure used by the Chart repository maintainers. Github labels are used to indicate state change during the review process. 

* ***AWAITING REVIEW*** - Initial triage which indicates that the PR is ready for review by the maintainers team. The CLA must be signed and e2e tests must pass in-order to move to this state
* ***CHANGES NEEDED*** - Review completed by at least one maintainer and changes needed by contributor (explicit even when using the review feature of Github)
* ***CODE REVIEWED*** - The chart structure has been reviewed and found to be satisfactory given the [technical requirements](CONTRIBUTING.md#technical-requirements) (may happen in parallel to UX REVIEWED)
* ***UX REVIEWED*** - The chart installation UX has been reviewed and found to be satisfactory. (may happen in parallel to CODE REVIEWED)
* ***LGTM*** - Added ONLY once both UX/CODE reviewed are both present. Merge must be handled by someone OTHER than the maintainer that added the LGTM label. This label indicates that given a quick pass of the comments this change is ready to merge

### Stale Pull Requests and Issues

Pull Requests and Issues that have no activity for 30 days automatically become stale. After 30 days of being stale, without activity, they become rotten. Pull Requests and Issues can rot for 30 days and then are automatically closed. This is the standard stale process handling for all repositories on the Kubernetes GitHub organization.

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernertes even through they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Status of the Project

This project is still under active development, so you might run into [issues](https://github.com/kubernetes/charts/issues). If you do, please don't be shy about letting us know, or better yet, contribute a fix or feature.
