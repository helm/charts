# Datadog changelog

## 2.0

## 2.0.4

* Mount the directory containing the CRI socket instead of the socket itself
  This is to handle the cases where the docker daemon is restarted.
  In this case, the docker daemon will recreate its docker socket and,
  if the container bind-mounted directly the socket, the container would
  still have access to the old socket instead of the one of the new docker
  daemon.
  ⚠ This version of the chart requires an agent image 7.18.0 or more recent

## 2.0.3

* Honor the image pull policy in init containers
* Pass the `DD_CRI_SOCKET_PATH` environment variable to the config init container so that it can adapt the agent config based on the CRI.

## 2.0.2

* Revert the docker socket path inside the agent container to its standard location to fix #21223

## 2.0.1

* Add parameters `datadog.logs.enabled` and `datadog.logs.containerCollectAll` to replace `datadog.logsEnabled` and `datadog.logsConfigContainerCollectAll`.
* Update the migration document link in the `Readme.md`.

### 2.0.0

* Remove Datadog agent deployment configuration.
* Cleanup resources labels, to fit with recommended labels.
* Cleanup useless or unused values parameters.
* each component have its own RBAC configuration (create,configuration).
* container runtime socket update values configuration simplification.
* `nameOverride` `fullnameOverride` is now optional in values.yaml
