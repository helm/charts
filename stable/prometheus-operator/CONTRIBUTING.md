# Contributing Guidelines
## How to contribute to this chart
1. Fork this repository, develop and test your Chart.
1. Bump the chart version for every change.
1. Ensure PR title has the prefix `[stable/prometheus-operator]`
1. When making changes to values.yaml, update the files in `ci/` by running `hack/update-ci.sh`
1. When making changes to rules or dashboards, see the README.md section on how to sync data from upstream repositories
1. Check the `hack/minikube` folder has scripts to set up minikube and components of this chart that will allow all components to be scraped. You can use this configuration when validating your changes.
1. Check for changes of RBAC rules.
1. Check for changes in CRD specs.
1. PR must pass the linter (`helm lint`)