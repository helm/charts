# Contributing to the Ambassador Helm Chart

This Helm chart is used to install The Ambassador Edge Stack (AES) and is 
maintained by Datawire.

## Developing

All work on the helm chart should be done in a separate branch off `master` and
contributed with a Pull Request targeting `master`.

**Note**: All updates to the chart require you update the `version` in 
`Chart.yaml`.

## Testing

The `ci/` directory contains scripts that will be run on PRs to `master`.

- `ci/run_tests.sh` will run the tests of the chart.

## Releasing

Releasing a new chart is done by pushing a tag to `master`. Travis will then 
run the tests and push the chart to `https://getambassador.io/helm`.
