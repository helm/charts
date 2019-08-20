# Change Log

This file documents all notable changes to Sysdig Falco Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

## v1.0.5

### Minor Changes

* Added 3 resources (`daemonsets`, `deployments`, `replicasets`) to the ClusterRole resource list  
  Taken from the [PR#514](https://github.com/falcosecurity/falco/pull/514) from Falco repository

## v1.0.4

### Minor Changes

* Upgrade to Falco 0.17.0
* Upgrade rules to Falco 0.17.0

## v1.0.3

### Minor Changes

* Support [`priorityClassName`](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)

## v1.0.2

### Minor Changes

* Upgrade to Falco 0.16.0
* Upgrade rules to Falco 0.16.0

## v1.0.1

### Minor Changes

* Extra environment variables passed to daemonset pods

## v1.0.0

### Major Changes

* Add support for K8s audit logging

## v0.9.1

### Minor Changes

* Allow configuration using values for `time_format_iso8601` setting
* Allow configuration using values for `syscall_event_drops` setting
* Allow configuration using values for `http_output` setting
* Add CHANGELOG entry for v0.8.0, [not present on its PR](https://github.com/helm/charts/pull/14813#issuecomment-506821432)

## v0.9.0

### Major Changes

* Add nestorsalceda as an approver

## v0.8.0

### Major Changes

* Allow configuration of Pod Security Policy. This is needed to get Falco
  running when the Admission Controller is enabled.

## v0.7.10

### Minor Changes

* Fix bug with Google Cloud Security Command Center and Falco integration

## v0.7.9

### Minor Changes

* Upgrade to Falco 0.15.3
* Upgrade rules to Falco 0.15.3

## v0.7.8

### Minor Changes

* Add TZ parameter for time correlation in Falco logs

## v0.7.7

### Minor Changes

* Upgrade to Falco 0.15.1
* Upgrade rules to Falco 0.15.1

## v0.7.6

### Major Changes

* Allow to enable/disable usage of the docker socket
* Configurable docker socket path
* CRI support, configurable CRI socket
* Allow to enable/disable usage of the CRI socket

## v0.7.5

### Minor Changes

* Upgrade to Falco 0.15.0
* Upgrade rules to Falco 0.15.0

## v0.7.4

### Minor Changes

* Use the KUBERNETES_SERVICE_HOST environment variable to connect to Kubernetes
  API instead of using a fixed name

## v0.7.3

### Minor Changes

* Remove the toJson pipeline when storing Google Credentials. It makes strange
  stuff with double quotes and does not allow to use base64 encoded credentials

## v0.7.2

### Minor Changes

* Fix typos in README.md

## v0.7.1

### Minor Changes

* Add Google Pub/Sub Output integration

## v0.7.0

### Major Changes

* Disable eBPF by default on Falco. We activated eBPF by default to make the
  CI pass, but now we found a better method to make the CI pass without
  bothering our users.

## v0.6.0

### Major Changes

* Upgrade to Falco 0.14.0
* Upgrade rules to Falco 0.14.0
* Enable eBPF by default on Falco
* Allow to download Falco images from different registries than `docker.io`
* Use rollingUpdate strategy by default
* Provide sane defauls for falco resource management

## v0.5.6

### Minor Changes

* Allow extra container args

## v0.5.5

### Minor Changes

* Update correct slack example

## v0.5.4

### Minor Changes

* Using Falco version 0.13.0 instead of latest.

## v0.5.3

### Minor Changes

* Update falco_rules.yaml file to use the same rules that Falco 0.13.0

## v0.5.2

### Minor Changes

* Falco was accepted as a CNCF project. Fix references and download image from
  falcosecurity organization.

## v0.5.1

### Minor Changes

* Allow falco to resolve cluster hostnames when running with ebpf.hostNetwork: true

## v0.5.0

### Major Changes

* Add Amazon SNS Output integration

## v0.4.0

### Major Changes

* Allow Falco to be run with a HTTP proxy server

## v0.3.1

### Minor Changes

* Mount in memory volume for shm. It was used in volumes but was not mounted.

## v0.3.0

### Major Changes

* Add eBPF support for Falco. Falco can now read events via an eBPF program
  loaded into the kernel instead of the `falco-probe` kernel module.

## v0.2.1

### Minor Changes

* Update falco_rules.yaml file to use the same rules that Falco 0.11.1

## v0.2.0

### Major Changes

* Add NATS Output integration

### Minor Changes

* Fix value mismatch between code and documentation

## v0.1.1

### Minor Changes

* Fix several typos

## v0.1.0

### Major Changes

* Initial release of Sysdig Falco Helm Chart
