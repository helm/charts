# Helm Charts

* Under ACTIVE development

Use this repository to submit official charts for Kubernetes Helm. Charts are curated application definitions for Kubernetes Helm. For more information about installing and using Helm, see its
[README.md](https://github.com/kubernetes/helm/tree/master/README.md). To get a quick introduction to Charts see this [chart document](https://github.com/kubernetes/helm/blob/master/docs/charts.md).

This Github repository contains the packaged source of Helm Charts that will become available on `gs://kubernetes-charts`.

Charts are already available for testing at `gs://kubernetes-charts-testing`. You can browse those Charts directly on the Google Cloud Storage [console](https://console.cloud.google.com/storage/browser/kubernetes-charts-testing).

## Chart Format

Take a look at the [alpine example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/alpine) and the [nginx example chart](https://github.com/kubernetes/helm/tree/master/docs/examples/nginx) for reference when you're writing your first few charts..

Before contributing a Chart, become familiar with the format. Note that the project is still under active development and the format may still evolve a bit.

## Contributing a chart

Your contributions are most welcome in the form or Pull Requests.

After you have created and tested a chart, please use `helm lint [CHART]` to lint the chart for additionalchecks. Then, use `helm package [CHART]` to package your chart into a chart archive. Create a pull request containing your packaged charts.

Note: We use the same [workflow](https://github.com/kubernetes/kubernetes/blob/master/docs/devel/development.md#git-setup),
[License](LICENSE) and [Contributor License Agreement](CONTRIBUTING.md) as the main Kubernetes repository.

## Status of the Project

This project is still under active development, so you might run into [issues](https://github.com/kubernetes/charts/issues). If you do, please don't be shy about letting us know, or better yet, contribute a fix or feature.
