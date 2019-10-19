
# Change Log

This file documents all notable changes to prometheus-cloudwatch-exporter Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).


NOTE: The change log until version 0.4.10 is auto generated based on git commits. Those include a reference to the git commit to be able to get more details.

## 0.4.11

Added CHANGELOG.md

## 0.4.10

include ServiceMonitor relabelings and metricRelabelings (#16443)
commit: c2774e5f2

## 0.4.9

Fix documentation typos (README.md) (#15745)
commit: 7f5e6a623

## 0.4.8

Added securityContext configuration capabilities (#12405)
commit: 9b4638fc7

## 0.4.7

configurable container command (#14803)
commit: 8b6e0c0a9

## 0.4.6

add torstenwalter as maintainer (#14788)
commit: 82b71f75c

## 0.4.5

Add scrape timeout option (#13686)
commit: 942005957

## 0.4.4

Added ingress configuration (#12407)
commit: 8be59eb77

## 0.4.3

Add optional ServiceMonitor and values stub with it disabled by default (#12503)
commit: 8a14b89fe

## 0.4.2

Fix default service port and target port.  (#11264)
commit: c1ac591fb

## 0.4.1

Adjust service targetPort to reference container port name. (#11462)
commit: b4bf081ab

## 0.4.0

Add support for pre-created secrets and AWS STS session tokens (#10878)
commit: 1e82f9986

## 0.3.0

Use entrypoint from Docker image and fix probe paths (#10873)
commit: 347c73a0e

## 0.2.1

Support custom service labels and portName (#8488)
commit: 3168c19aa

## 0.2.0

health/liveness endpoints added (#7681)
commit: 889e07402

## 0.1.4

Fixed secret variable parsing for access/secret keys. (#6511)
commit: 9659feb3e

## 0.1.3

Fixed image configuration in README for the prometheus-cloudwatch-exporter (#6400)
commit: d59512283

## 0.1.2

Annotations and checksum (#5067)
commit: 178d167bc

## 0.1.1

Update table/prometheus-cloudwatch-exporte (#4551)
commit: 647b56cc4

## 0.1.0

Add cloudwatch exporter (#4022)
commit: 0f730f26e

