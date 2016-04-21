# Helm Charts

* Under ACTIVE development

Source of curated application definitions (a.k.a Charts) for Kubernetes Helm. For more information about installing and using Helm, see its
[README.md](https://github.com/kubernetes/helm/tree/master/README.md). To get a quick introduction to the developer's experience using Helm and Charts see this [developer workflow](https://github.com/kubernetes/helm/blob/master/docs/workflow/developer-workflows.md).

## Source Repository

This Github repository contains the source of Helm Charts that will soon become available on `gs://kubernetes-charts`.

Charts are already available for testing at `gs://kubernetes-charts-testing`. You can browse those Charts directly on the Google Cloud Storage [console](https://console.cloud.google.com/storage/browser/kubernetes-charts-testing).

Charts are packaged and uploaded to a repository according to a [workflow](https://github.com/kubernetes/helm/blob/master/docs/pushing_charts.md)

## Chart Format

The format of Charts is defined in this [document](https://github.com/kubernetes/helm/blob/master/docs/design/chart_format.md) in the Helm [repository](https://github.com/kubernetes/helm.git)

Before contributing a Chart, become familiar with this format. Note that the project is still under active development and the format may still evolve a bit.

The format is slightly different from the Deis's [Charts](https://github.com/helm/charts.git) where it originated.

## Status of the Project

This project is still under active development, so you might run into [issues](https://github.com/kubernetes/charts/issues). If you do, please don't be shy about letting us know, or better yet, contribute a fix or feature.

## Contributing

Your contributions are most welcome.

We use the same [workflow](https://github.com/kubernetes/kubernetes/blob/master/docs/devel/development.md#git-setup),
[License](LICENSE) and [Contributor License Agreement](CONTRIBUTING.md) as the main Kubernetes repository.