# Change Log

This file documents all notable changes to Sysdig Falco Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

## v0.5.6

* Allow extra container args

## v0.5.5

* Update correct slack example

## v0.5.4

* Using Falco version 0.13.0 instead of latest.

## v0.5.3

* Update falco_rules.yaml file to use the same rules that Falco 0.13.0

## v0.5.2

* Falco was accepted as a CNCF project. Fix references and download image from
  falcosecurity organization.

## v0.5.1

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
