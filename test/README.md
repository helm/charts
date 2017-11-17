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

#### Procedure

Pull requests testing is run via the [Kuberentes Test Infrastructure](https://github.com/kubernetes/test-infra).

The configuration of the Pull Request trigger is [in the config.json](https://github.com/kubernetes/test-infra/blob/827797c54b48295045698465b437f463ca9276c2/jobs/config.json#L10285).

This snippet tells Test Infra to run the [test/e2e.sh](https://github.com/kubernetes/charts/blob/master/test/e2e.sh)
when testing is triggered on a pull request. The e2e.sh script will use the [Charts test image](https://github.com/kubernetes/charts/blob/master/test/Dockerfile)
to run the [test/changed.sh](https://github.com/kubernetes/charts/blob/master/test/changed.sh) script. This script 
is the main logic for validation of a pull request. It intends to only test charts that have changed in this PR.

The logic is as follows:

1. [Get credentials for the Kubernetes cluster used for testing.](https://github.com/kubernetes/charts/blob/master/test/changed.sh#L42)
1. [Install and initialize Helm](https://github.com/kubernetes/charts/blob/master/test/changed.sh#L47)
1. [For any charts that have changed](https://github.com/kubernetes/charts/blob/master/test/changed.sh#L62):
    - Download dependent charts, if any, with `helm dep build`
    - Run `helm install` in a new namespace for this PR+build
    - Use the [test/verify-release.sh](https://github.com/kubernetes/charts/blob/master/test/verify-release.sh) to ensure that if any pods were launched that they get to the `Running` state
    - Run `helm test` on the release
    - Delete the release

#### Triggering

In order for the tests to be kicked off one of the 
[Kubernetes member](https://github.com/orgs/kubernetes/people) must add the 
"ok-to-test" label. This can also be done by commenting "/ok-to-test" on the pull request. 

This check is there to ensure that PRs are spot checked for any nefarious code. There are 2 things to check for:

1. No changes have been made to file in the test folder that unnecessarily alter the testing procedures.
1. The chart is not using images whose provenance is not traceable (usually done via the sources metadata field).

## Repo syncing

The syncing of charts to the stable and incubator repos happens from a Jenkins instance that is polling for changes
to the master branch. On each change it will use the [test/repo-sync.sh](https://github.com/kubernetes/charts/blob/master/test/repo-sync.sh)
to update the public repositories. The procedure is as follows:

1. [Setup Helm](https://github.com/kubernetes/charts/blob/master/test/repo-sync.sh#L16)
1. [Authenticate to Google Cloud so that we can upload to the Cloud Storage bucket that hosts the charts](https://github.com/kubernetes/charts/blob/master/test/repo-sync.sh#L27)
1. For the stable and incubator folders:
   - Download the existing index.yaml from the repository
   - Run `helm dep build` on all the charts in the current repository
   - Run `helm package` on each chart
   - Recreate the index using `helm repo index`
   - Upload the repostory using `gsutil rsync`
