# Helm Charts

* Under ACTIVE development

Use this repository to submit official Charts for Kubernetes Helm. Charts are curated application definitions for Kubernetes Helm. For more information about installing and using Helm, see its
[README.md](https://github.com/kubernetes/helm/tree/master/README.md). To get a quick introduction to Charts see this [chart document](https://github.com/kubernetes/helm/blob/master/docs/charts.md).

## Chart Format

Take a look at the [alpine example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/alpine) and the [nginx example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/nginx) for reference when you're writing your first few charts.

Before contributing a Chart, become familiar with the format. Note that the project is still under active development and the format may still evolve a bit.

## Repository Structure

This GitHub repository contains the source for the packaged and versioned charts released in the [`gs://kubernetes-charts` Google Storage bucket](https://console.cloud.google.com/storage/browser/kubernetes-charts/) (the Chart Repository).

The Charts in the master branch of this repository match the latest packaged Chart in the Chart Repository, though there may be previous versions of a Chart available in the Chart Repository.

The purpose of this repository is to provide a place for maintaining and contributing official Charts, with CI processes in place for managing the releasing of Charts into the Chart Repository.

The Charts in this repository are organized into two folders:
* stable
* incubator

Stable Charts:

1. Provide a method for data persistence (if applicable)
1. Support application upgrades
1. Allow customization of the application configuration
1. Provide a secure default configuration
1. Do not leverage alpha features of Kubernetes

Incubator Charts are those that do not meet these criteria, but still meet the technical and documentation requirements described in CONTRIBUTING.md. Having the incubator folder allows charts to be shared and improved on until they are ready to be moved into the stable folder.

In order to get a Chart from incubator to stable, Chart maintainers should open a pull request that moves the chart folder.

## Contributing a Chart

We'd love for you to contribute a Chart that provides a useful application or service for Kubernetes. Please read our [Contribution Guide](CONTRIBUTING.md) for more information on how you can contribute Charts.

Note: We use the same [workflow](https://github.com/kubernetes/kubernetes/blob/master/docs/devel/development.md#git-setup),
[License](LICENSE) and [Contributor License Agreement](CONTRIBUTING.md) as the main Kubernetes repository.

## Status of the Project

This project is still under active development, so you might run into [issues](https://github.com/kubernetes/charts/issues). If you do, please don't be shy about letting us know, or better yet, contribute a fix or feature.
