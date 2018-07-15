# Filebeat

[filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html) is used to ship Kubernetes and host logs to multiple outputs.

## Prerequisites

- Kubernetes 1.9+

## Note

By default this chart only ships a single output to a file on the local system.  Users should set config.output.file.enabled=false and configure their own outputs as [documented](https://www.elastic.co/guide/en/beats/filebeat/current/configuring-output.html)
