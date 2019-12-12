# Change Log

This file documents all notable changes to Sysdig Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

## v1.4.24

### Minor changes

* Use the latest image from Agent (0.93.1) by default.

## v1.4.23

### Minor changes

* Update NOTES.txt to use the newest URL for finding the infrastructure.

## v1.4.22

### Minor changes

* Use the latest image from Agent (0.93.0) by default.

## v1.4.21

* Add 'How to upgrade to last version' to the README

## v1.4.20

### Minor changes

* Fixes compatibility errors introduced in v1.4.19.

## v1.4.19

### Minor changes

* Fixes compatibility with kubernetes 1.16.

## v1.4.18

### Minor changes

* Use the latest image from Agent (0.92.3) by default.

## v1.4.17

### Minor changes

* Use the latest image from Agent (0.92.2) by default.

## v1.4.16

### Minor changes

* Allow the DaemonSet to schedule using affinity rules

## v1.4.15

### Minor changes

* Add configmaps and secrets to the resources we can read
* Add support for priorityClassName, httpProxy, timezone and any env variable settings

## v1.4.14

### Minor changes

* Update REAMED.md to fix the example in how to use the `sysdig.settings.tags` in the command line with `--set`

## v1.4.13

### Minor changes

* Use the latest image from Agent (0.92.1) by default.
* Increase `resources.requests` and `resources.limits` to match the [values
  provided by Sysdig's agent team.](https://github.com/draios/sysdig-cloud-scripts/blob/master/agent_deploy/kubernetes/sysdig-agent-daemonset-v2.yaml#L70)

## v1.4.12

### Minor changes

* Use the latest image from Agent (0.92.0) by default.

## v1.4.11

### Minor Changes

* Add nestorsalceda as an approver in the OWNERS file

## v1.4.10

### Minor Changes

* Use the latest image from Agent (0.90.3) by default.

## v1.4.9

### Minor Changes

* Use the latest image from Agent (0.90.2) by default.

## v1.4.8

### Minor Changes

* Add a volume with the os release information.
* Use the latest image from Agent (0.90.1) by default.

## v1.4.7

### Minor Changes

* Add apiVersion to Chart.yaml.

## v1.4.6

### Minor Changes

* Dont allow to change the value of `new_k8s` flag.

## v1.4.5

### Minor Changes

* Enable `new_k8s` flag by default.  This allows kube state metrics to be
  automatically detected, monitored, and displayed in Sysdig Monitor.

## v1.4.4

### Minor Changes

* Use the latest image from Agent (0.89.5) by default.
* Add `persistentvolumes` and `persistentvolumeclaims` to ClusterRole

## v1.4.3

### Minor Changes

* Provide an empty value to `sysdig.accessKey` key.

## v1.4.2

### Minor Changes

* Use the latest image from Agent (0.89.4) by default.
* Use latest shovel logo.

## v1.4.0

### Major Changes

* Use the latest image from Agent (0.89.0) by default.
* eBPF support added.

## v1.3.2

### Minor Changes

* Provide sane defaults resources for the Sysdig Agent.
* Use RollingUpdate strategy by default.

## v1.3.1

### Minor Changes

* Revert v1.2.1 changes. The agent automatically restarts when detects a change in the configuration.

## v1.3.0

### Major Changes

* Use a lower pod termination grace period for avoiding data gaps when pod fails to terminate quickly.
* Check running file on readinessProbe instead of relaying on logs.
* Mount /run and /var/run instead of Docker socket. It allows to access CRI / containerd socket.
* Avoid floating references for the image.

## v1.2.2

### Minor Changes

* Fix value in the agent tags example.

## v1.2.1

### Minor Changes

* Add checksum annotations to DaemonSet so that rolling upgrades works when a ConfigMap changes.

## v1.2.0

### Major Changes

* Allow to use other Docker registries (ECR, Quay ...) to download the Sysdig agent image.

## v1.1.0

### Major Changes

* Add support for uploading custom app checks for Sysdig agent

## v1.0.4

### Minor Changes

* Update README file with instructions for setting up the agent with On-Premise deployments

## v1.0.3

### Minor Changes

* Fixed error in ClusterRoleBinding's roleRef

## v1.0.2

### Minor Changes

* Fix readinessProbe in daemonset's pod spec

## v1.0.1

### Minor Changes

* Add dnsPolicy to daemonset. Its value is ClusterFirstWithHostNet
* Fix link target for retrieving Sysdig Monitor Access Key in README

## v1.0.0

### Major Changes

* Run Sysdig agent as [daemonset v2.0](https://github.com/draios/sysdig-cloud-scripts/blob/master/agent_deploy/kubernetes/sysdig-agent-daemonset-v2.yaml).
* Fix value's naming in order to follow [best practices](https://docs.helm.sh/chart_best_practices/#naming-conventions).
* Use a secure.enabled flag for enabling Sysdig Secure.
* Allow rbac resource creation or use existing serviceAccountName.
* Use required function for retrieving sysdig.accessKey. This ensures that key is present.
