# Charts Testing

## Pull Request Testing

There are two forms of testing run on a pull request. Static analysis, run
automatically, and operational testing, run when a maintainer flags a pull
request as being ready. The operational testing is run on Kubernertes test
infrastructure.

### Static Analysis

Static analysis is performed on every pull request and is run by CircleCI. The
configuration is stored in the [`.circleci/config.yml`](../.circleci/config.yml)
file.

The static analysis currently:

* Performs `helm lint` on any changed charts to provide quick feedback

### Operational Testing

Operational testing allows deploying a Release for the changed Helm Chart to test it.

#### Procedure

Pull requests testing is run via the [Kubernetes Test Infrastructure](https://github.com/kubernetes/test-infra).

The configuration of the Pull Request trigger is [in the config.json](https://github.com/kubernetes/test-infra/blob/827797c54b48295045698465b437f463ca9276c2/jobs/config.json#L10285).

This snippet tells Test Infra to run the [test/e2e.sh](https://github.com/helm/charts/blob/master/test/e2e.sh)
when testing is triggered on a pull request. The e2e.sh script will use the [Charts test image](https://github.com/helm/charts/blob/master/test/Dockerfile)
to run the [ct lint-and-install](https://github.com/helm/chart-testing/blob/master/doc/ct_lint-and-install.md) command. This
is the main logic for validation of a pull request. It intends to only test charts that have changed in this PR.

The testing logic has been extracted to the [chart-testing](https://github.com/helm/chart-testing) project. A go library provides the required logic to lint, install, and test charts. It is provided as a Docker image and can be run by anyone on their own charts.

#### Providing Custom Test Values

Testing charts with default values may not be suitable in all cases. For instance, charts may require some values to be set which should not be part of the chart's default `values.yaml` (such as keys etc.). Furthermore, it is often desirable to test a chart with different configurations, reflecting different use cases (e.g. setting a password instead of using the default generated one, activating persistence instead of using the default emptyDir volume, etc.).

In order to enable custom test values, create a directory `ci` in the chart's directory and add any number of `*-values.yaml` files to this directory. Only files with a suffix `-values.yaml` are considered. Instead of using the defaults, the chart is then installed and tested separately for each of these files using the `--values` flag.

Please note that in order to test using the default values when using the `ci` directory, an empty values file must be present in the directory.

For examples, you can take a look at existing tests in this repository (e.g. [Kibana Chart](https://github.com/helm/charts/tree/7755cea24c028db07e2e36933ec13c28efea9a32/stable/kibana/ci)).

Please also note that it is a different concept than "[Helm Chart Test](https://github.com/helm/helm/blob/master/docs/chart_tests.md)", although the Helm Chart test, if defined, will be run by this test tool for each test values.

#### Triggering

In order for the tests to be kicked off one of the
[Kubernetes member](https://github.com/orgs/kubernetes/people) must add the
"ok-to-test" label. This can also be done by commenting "/ok-to-test" on the pull request.

This check is there to ensure that PRs are spot checked for any nefarious code. There are 2 things to check for:

1. No changes have been made to file in the test folder that unnecessarily alter the testing procedures.
1. The chart is not using images whose provenance is not traceable (usually done via the sources metadata field).

## Repo Syncing

The syncing of charts to the stable and incubator repos happens from a Jenkins instance that is polling for changes
to the master branch. On each change it will use the [test/repo-sync.sh](https://github.com/helm/charts/blob/master/test/repo-sync.sh)
to update the public repositories. The procedure is as follows:

1. [Setup Helm](https://github.com/helm/charts/blob/master/test/repo-sync.sh#L16)
1. [Authenticate to Google Cloud so that we can upload to the Cloud Storage bucket that hosts the charts](https://github.com/helm/charts/blob/master/test/repo-sync.sh#L27)
1. For the stable and incubator folders:
   - Download the existing index.yaml from the repository
   - Run `helm dep build` on all the charts in the current repository
   - Run `helm package` on each chart
   - Recreate the index using `helm repo index`
   - Upload the repository using `gsutil rsync`

The Jenkins instance doing the syncing is running in a GCP project
`kubernetes-charts-ci` in the default namespace of the GKE cluster named
jenkins in us-west1-a.

To access the Jenkins interface:
```shell
gcloud container clusters get-credentials --project kubernetes-charts-ci --zone us-west1-a jenkins
helm status sync
```
