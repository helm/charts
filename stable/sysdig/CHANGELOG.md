# Change Log

This file documents all notable changes to Sysdig Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).

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
