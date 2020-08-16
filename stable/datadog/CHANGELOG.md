# Datadog changelog

## 2.3.42

* Deprecate current repository, replaced by `helm.datadoghq.com`

## 2.3.41

* Fix issue with Kubernetes <= 1.14 and Cluster Agent's External Metrics Provider (must be 443)

## 2.3.40

* Update documentation for resource requests & limits default values.

## 2.3.39

* Propagate `datadog.checksd` to the clusterchecks runner to support custom checks there.

## 2.3.38

* Add support of DD\_CONTAINER\_{INCLUDE,EXCLUDE}\_{METRICS,LOGS}

## 2.3.37

* Add NET\_BROADCAST capability

## 2.3.36

* Bump default Agent version to `7.21.1`

## 2.3.35

* Add support for configuring the Datadog Admission Controller

## 2.3.34

* Add support for scaling based on `DatadogMetric` CRD

## 2.3.33

* Create new `datadog.podSecurity.securityContext` field to fix windows agent daemonset config.

## 2.3.32

* Always add os in nodeSelector based on `targetSystem`

## 2.3.31

* Fixed daemonset template for go 1.14

## 2.3.29

* Change the default port for the Cluster Agent's External Metrics Provider
  from 443 to 8443.
* Document usage of `clusterAgent.env`

## 2.3.28

* fix daemonset template generation if `datadog.securityContext` is set to `nil`

## 2.3.27

* add systemProbe.collectDNSStats option

## 2.3.26

* fix PodSecurityContext configuration

## 2.3.25

* Use directly .env var YAML block for all agents (was already the case for Cluster Agent)

## 2.3.24

* Allow enabling Orchestrator Explorer data collection from the process-agent

## 2.3.23

* Add the possibility to create a `PodSecurityPolicy` or a `SecurityContextConstraints` (Openshift) for the Agent's Daemonset Pods.

## 2.3.22

* Remove duplicate imagePullSecrets
* Fix DataDog location to useConfigMap in docs
* Adding explanation for metricsProvider.enabled

## 2.3.21

* Fix additional default values in `values.yaml` to prevent errors with Helm 2.x

## 2.3.20

* Fix process-agent <> system-probe communication

## 2.3.19

* Fix the container-trace-agent.yaml template creates invalid yaml when  `useSocketVolume` is enabled.

## 2.3.18

* Support arguments in the cluster-agent container `command` value

## 2.3.17

* grammar edits to datadog helm docs!
* Typo in log config

## 2.3.16

* Add parameter `clusterChecksRunner.rbac.serviceAccountAnnotations` for specifying annotations for dedicated ServiceAccount for Cluster Checks runners.
* Add parameters `clusterChecksRunner.volumes` and `clusterChecksRunner.volumeMounts` that can be used for providing a secret backend to Cluster Checks runners.

## 2.3.15

* Mount kernel headers in system-probe container
* Fix the mount of the `system-probe` socket in core agent
* Add parameters to enable eBPF based checks

## 2.3.14

* Allow overriding the `command` to run in the cluster-agent container

## 2.3.13

* Use two distinct health endpoints for liveness and readiness probes.

## 2.3.12

* Fix endpoints checks scheduling between agent and cluster check runners
* Cluster Check Runner now runs without s6 (similar to other agents)

## 2.3.11

* Bump the default version of the agent docker images

## 2.3.10

* Add dnsConfig options to all containers

## 2.3.9

* Add `clusterAgent.podLabels` variable to add labels to the Cluster Agent Pod(s)

## 2.3.8

* Fix templating errors when `clusterAgent.datadog_cluster_yaml` is being used.

## 2.3.7

* Fix an agent warning at startup because of a deprecated parameter

## 2.3.6

* Add `affinity` parameter in `values.yaml` for cluster agent deployment

## 2.3.5

* Add `DD_AC_INCLUDE` and `DD_AC_EXCLUDE` to all containers
* Add "Unix Domain Socket" support in trace-agent
* Add new parameter to specify the dogstatsd socket path on the host
* Fix typos in values.yaml
* Update "tags:" example in values.yaml
* Add "rate_limit_queries_*" in the datadog.cluster-agent prometheus check configuration

## 2.3.4

* Fix default values in `values.yaml` to prevent warnings with Helm 2.x

## 2.3.3

* Allow pre-release versions as docker image tag

## 2.3.2

* Update the DCA RBAC to allow it to create events in the HPA

## 2.3.1

* Update the example for `datadog.securityContext`

## 2.3.0

* Mount the directory containing the CRI socket instead of the socket itself
  This is to handle the cases where the docker daemon is restarted.
  In this case, the docker daemon will recreate its docker socket and,
  if the container bind-mounted directly the socket, the container would
  still have access to the old socket instead of the one of the new docker
  daemon.
  ⚠ This version of the chart requires an agent image 7.19.0 or more recent

## 2.2.12

* Adding resources for `system-probe` init container

## 2.2.11

* Add documentations around secret management in the datadog helm chart. It is to upstream
  requested changes in the IBM charts repository: https://github.com/IBM/charts/pull/690#discussion_r411702458
* update `kube-state-metrics` dependency
* uncomment every values.yaml parameters for IBM chart compliancy

## 2.2.10

* Remove `kubeStateMetrics` section from `values.yaml` as not used anymore

## 2.2.9

* Fixing variables description in README and Migration documentation (#22031)
* Avoid volumes mount conflict between `system-probe` and `logs` volumes in the `agent`.

## 2.2.8

* Mount `system-probe` socket in `agent` container when system-probe is enabled

## 2.2.7

* Add "Cluster-Agent" `Event` `create` RBAC permission

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
