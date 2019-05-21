# Change Log

This file documents all notable changes to Ambassador Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

## v2.6.0

### Minor Changes

- Add ambassador CRDs!
- Update ambassador to 0.70.0

## v2.5.1

### Minor Changes

- Update ambassador to 0.61.1

## v2.5.0

### Minor Changes

- Add support for autoscaling using HPA, see `autoscaling` values.

## v2.4.1

### Minor Changes

- Update ambassador to 0.61.0

## v2.4.0

### Minor Changes

- Allow configuring `hostNetwork` and `dnsPolicy`

## v2.3.1

### Minor Changes

- Adds HOST_IP environment variable

## v2.3.0

### Minor Changes

- Adds support for init containers using `initContainers` and pod labels `podLabels`

## v2.2.5

### Minor Changes

- Update ambassador to 0.60.3

## v2.2.4

### Minor Changes

- Add support for Ambassador PRO [see readme](https://github.com/helm/charts/blob/master/stable/ambassador/README.md#ambassador-pro)

## v2.2.3

### Minor Changes

- Update ambassador to 0.60.2

## v2.2.2

### Minor Changes

- Update ambassador to 0.60.1

## v2.2.1

### Minor Changes

- Fix RBAC for ambassador 0.60.0

## v2.2.0

### Minor Changes

- Update ambassador to 0.60.0

## v2.1.0

### Minor Changes

- Added `scope.singleNamespace` for configuring ambassador to run in single namespace

## v2.0.2

### Minor Changes

- Update ambassador to 0.53.1

## v2.0.1

### Minor Changes

- Update ambassador to 0.52.0

## v2.0.0

### Major Changes

- Removed `ambassador.id` and `namespace.single` in favor of setting environment variables.

## v1.1.5

### Minor Changes

- Update ambassador to 0.50.3

## v1.1.4

### Minor Changes

- support targetPort specification

## v1.1.3

### Minor Changes

- Update ambassador to 0.50.2

## v1.1.2

### Minor Changes

- Add additional chart maintainer

## v1.1.1

### Minor Changes

- Default replicas -> 3

## v1.1.0

### Minor Changes

- Allow RBAC to be namespaced (`rbac.namespaced`)

## v1.0.0

### Major Changes

- First release of Ambassador Helm Chart in helm/charts
- For migration see [Migrating from datawire/ambassador chart](https://github.com/helm/charts/tree/master/stable/ambassador#migrating-from-datawireambassador-chart-chart-version-0400-or-0500)
