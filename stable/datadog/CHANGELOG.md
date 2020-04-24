# Datadog changelog

## 2.2.6

* Ensure the `trace-agent` computes the same hostname as the core `agent`.
  by giving it access to all the elements that might be used to compute the hostname:
  the `DD_CLUSTER_NAME` environment variable and the docker socket.

## 2.2.5

* Fix RBAC

## 2.2.4

* Move several EnvVars to `common-env-vars` to be accessible by the `trace-agent` #21991.
* Fix discrepancies migration-guide and readme reporded in #21806 and #21920.
* Fix EnvVars with integer value due to yaml. serialization, reported by #21853.
* Fix .Values.datadog.tags encoding, reported by #21663.
* Add Checksum to `xxx-cluster-agent-config` config map, reported by #21622 and contribution #21656.

## 2.2.3

* Fix `datadog.dockerOrCriSocketPath` helper #21992

## 2.2.2

* Fix indentation for `clusterAgent.volumes`.

## 2.2.1

* Updating `agents.useConfigMap` and `agents.customAgentConfig` parameter descriptions in the chart and main readme.

## 2.2.0

* Add Windows support
* Update documentation to reflect some changes that were made default
* Enable endpoint checks by default in DCA/Agent

## 2.1.2

* Fixed a bug where `DD_LEADER_ELECTION` was not set in the config init container, leading to a failure to adapt
config to this environment variable.

## 2.1.1

* Add option to enable WPA in the Cluster Agent.

## 2.1.0

* Changed the default for `processAgent.enabled` to `true`.

## 2.0.14

* Fixed a bug where the `trace-agent` runs in the same container as `dd-agent`

## 2.0.13

* Fix `system-probe` startup on latest versions of containerd.
  Here is the error that this change fixes:
  ```    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       StartError
      Message:      failed to create containerd task: OCI runtime create failed: container_linux.go:349: starting container process caused "close exec fds: ensure /proc/self/fd is on procfs: operation not permitted": unknown
      Exit Code:    128
   ```

## 2.0.11

* Add missing syscalls in the `system-probe` seccomp profile

## 2.0.10

* Do not enable the `cri` check when running on a `docker` setup.

## 2.0.7

* Pass expected `DD_DOGSTATSD_PORT` to datadog-agent rather than invalid `DD_DOGSTATD_PORT`

## 2.0.6

* Introduces `procesAgent.processCollection` to correctly configure `DD_PROCESS_AGENT_ENABLED` for the process agent.

## 2.0.5

* Honor the `datadog.env` parameter in all containers.

## 2.0.4

* Honor the image pull policy in init containers.
* Pass the `DD_CRI_SOCKET_PATH` environment variable to the config init container so that it can adapt the agent config based on the CRI.

## 2.0.3

* Fix templating error when `agents.useConfigMap` is set to true.
* Add DD\_APM\_ENABLED environment variable to trace agent container.


## 2.0.2

* Revert the docker socket path inside the agent container to its standard location to fix #21223.

## 2.0.1

* Add parameters `datadog.logs.enabled` and `datadog.logs.containerCollectAll` to replace `datadog.logsEnabled` and `datadog.logsConfigContainerCollectAll`.
* Update the migration document link in the `Readme.md`.

### 2.0.0

* Remove Datadog agent deployment configuration.
* Cleanup resources labels, to fit with recommended labels.
* Cleanup useless or unused values parameters.
* each component have its own RBAC configuration (create,configuration).
* container runtime socket update values configuration simplification.
* `nameOverride` `fullnameOverride` is now optional in values.yaml.
