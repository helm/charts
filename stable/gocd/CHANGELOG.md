### 1.16.0

* [7872692](https://github.com/kubernetes/charts/commit/7872692): Update Pipeline config API version, use getting started repo's script for task

### 1.15.0

* [723e309](https://github.com/kubernetes/charts/commit/723e309):
- Bump up GoCD Version to 19.7.0

### 1.14.0

* [c191fb46c](https://github.com/kubernetes/charts/commit/c191fb46c):

- Bump up GoCD Version to 19.6.0
- Add an option to specify security constraint for server and agent pod.
- Remove `server.env.goServerSystemProperties` in favor of `server.env.goServerJvmOpts`
- Remove `server.env.goAgentSystemProperties` in favor of `server.env.goAgentJvmOpts`

### 1.13.0

* [484a09ef1](https://github.com/kubernetes/charts/commit/484a09ef1):

- Bump up GoCD docker registry artifact plugin version from v1.0.1-92 to v1.1.0-104

### 1.12.0

* [fa4bef2](https://github.com/kubernetes/charts/commit/fa4bef2):

- Update API versions of Deployment and RBAC resources

### 1.11.0

* [8207b8c](https://github.com/kubernetes/charts/commit/8207b8c):

- Bump up GoCD Version to 19.5.0

### 1.10.0

* [554019b](https://github.com/kubernetes/charts/commit/554019b):

- Bump up GoCD Version to 19.4.0

### 1.9.1

- Add support for Deployment and Pod annotations.

### 1.9.0

- Bump up k8s elastic agent plugin to latest.
- Bump up GoCD Version to 19.3.0

### 1.8.1

* [0f99647](https://github.com/helm/charts/commit/0f99647):

- Update docker registry artifact plugin to latest stable release.

### 1.8.0

* [8ec8c89](https://github.com/helm/charts/commit/8ec8c89):

- Update agent image to gocd-agent-alpine-3.9

* [dcd3332](https://github.com/helm/charts/commit/dcd3332):

- Introduce server and agent pre stop hooks for users to optionally provide pre stop scripts.

### 1.7.1

* [0b0e2bf](https://github.com/kubernetes/charts/commit/0b0e2bf):

- Bump k8s elastic agent plugin to latest.

### 1.7.0

* [908b129](https://github.com/kubernetes/charts/commit/908b129):

- Bump up GoCD Version to 19.2.0

### 1.6.6

* [84bd7fe](https://github.com/kubernetes/charts/commit/f44d408):

- If there is no host in template ingress.yaml, use default backend.

### 1.6.5

* [f44d408](https://github.com/kubernetes/charts/commit/f44d408):

- Bump up GoCD Version to 19.1.0

### 1.6.4

* [ec15367](https://github.com/kubernetes/charts/commit/ec15367):

- Bump up the version of docker registry artifact plugin to latest.

### 1.6.3

* [bca4092f](https://github.com/kubernetes/charts/commit/bca4092f):
  - Fixes regression of functionality that allows for extra volumes and mounts regardless of whether persistence and ssh is enabled

### 1.6.2

* [fe985d7](https://github.com/kubernetes/charts/commit/fe985d7):
  - Deprecate agent.env.agentAutoRegisterEnvironemnts in favour of agent.env.agentAutoRegisterEnvironments.

  *Please note that the deprecated property will be removed in GoCD 19.3.0 (that is, when Chart.appVersion is 19.3.0). Users are encouraged to use the new property `agent.env.agentAutoRegisterEnvironments`.*

### 1.6.1

* [28d5416](https://github.com/kubernetes/charts/commit/28d5416):
  - Add sheroy to owners

### 1.6.0

* [7002dac](https://github.com/kubernetes/charts/commit/7002dac):
  - add option to specify init containers and restart policy for server and agent

### 1.5.13

* [223b59f](https://github.com/kubernetes/charts/commit/223b59f):
  - Fix typo in README.

### 1.5.12

* [72aa74f1](https://github.com/kubernetes/charts/commit/72aa74f1):
  - Removes the namespace list permission for the service account being created.

### 1.5.11

* [a8f4e6c9](https://github.com/kubernetes/charts/commit/a8f4e6c9):
  - Bump up GoCD app version to 18.12.0

### 1.5.10

* [87b3a755](https://github.com/kubernetes/charts/commit/87b3a755):
  - Allow the override of the preconfigure command

### 1.5.9

* [6547ba84](https://github.com/kubernetes/charts/commit/6547ba84):
  - Introduces the ability to configure agent service accounts

### 1.5.8

* [cee475aa](https://github.com/kubernetes/charts/commit/cee475aa):
  - Enable extra volume mounts without persistence

### 1.5.7

* [c663a531](https://github.com/kubernetes/charts/commit/c663a531):
  - Bump up GoCD app version to 18.11.0

### 1.5.6

* [32de4923](https://github.com/kubernetes/charts/commit/32de4923)
  - Deployment strategy value

### 1.5.5

* [22f3354](https://github.com/helm/charts/commit/22f3354):
  - Volume mount the config map to preconfigure the server even if persistence is disabled. ([#8579](https://github.com/helm/charts/issues/8579))

### 1.5.4

* [4018a215](https://github.com/kubernetes/charts/commit/4018a215):
  - Update README with link to "Intro to GoCD" guide

### 1.5.3

* [65fa6218](https://github.com/kubernetes/charts/commit/65fa6218):
  - Affinity setting in agent and server deployments
* [587d7a37](https://github.com/kubernetes/charts/commit/587d7a37):
  - Invalid nodeSelector reference for agent deployment

### 1.5.2

* [17fa5c8e](https://github.com/kubernetes/charts/commit/17fa5c8e): Fix agent kube resources typo.

### 1.5.1

* [b22b9d6](https://github.com/kubernetes/charts/commit/b22b9d6):
  - Use latest Kubernetes elastic agent plugin v2.0.0

### 1.5.0

* [1f8118b](https://github.com/kubernetes/charts/commit/1f8118b):
  - Bump up GoCD app version to 18.10.0

### 1.4.3

* [52120886](https://github.com/kubernetes/charts/commit/52120886): Add extra volumes and volumeMounts options on the server and agents

### 1.4.2

* [499fddf9](https://github.com/kubernetes/charts/commit/499fddf9): Add agent.env.extraEnvVars

### 1.4.1

* [15c77caf](https://github.com/kubernetes/charts/commit/15c77caf):
  - Bump up GoCD app version to 18.9.0

### 1.4.0

* [f5249551](https://github.com/kubernetes/charts/commit/f5249551):  
  - Bump up GoCD app version to 18.8.0
  - Updated kubernetes elastic agent plugin version to 1.0.2
  - Updated post install script
       * From GoCD version 18.8.0 pipeline created using api is already in
         unpaused state

### 1.3.6

* [b7d596e](https://github.com/helm/charts/pull/7476/commits/b7d596e): Fixed role configuration instructions in README file.

### 1.3.5

* [eab7388](https://github.com/kubernetes/charts/commit/eab7388): Fix typo and whitespace in the README file.

### 1.3.4

* [57b201d](https://github.com/kubernetes/charts/commit/57b201d): Agent-only deployment should not create server-related k8s resources.

### 1.3.3

* [0c5eadd](https://github.com/kubernetes/charts/commit/0c5eadd): Enable use of hostAliases for agents

### 1.3.2

* [55d9cef](https://github.com/kubernetes/charts/commit/55d9cef): Add support for privileged mode, which is needed for DinD (Docker-in-Docker).
* [01df97f](https://github.com/kubernetes/charts/commit/01df97f): Enable privileged mode for GoCD agent deployment (if configured).

### 1.3.1

* [7b9d6c0](https://github.com/kubernetes/charts/commit/7b9d6c0): Enable use of hostAliases for server
* [273f042](https://github.com/kubernetes/charts/commit/273f042): Add documentation to hostAliases property
* [d21a32d](https://github.com/kubernetes/charts/commit/d21a32d): Add hostAliases property to README

### 1.3.0

* [750de42c](https://github.com/kubernetes/charts/commit/750de42c):  Add support for SSH keys on server and agent

### 1.2.0

* [514a1856](https://github.com/kubernetes/charts/commit/514a1856):  Bump up GoCD app version to 18.7.0

### 1.1.3

* [3df661cc](https://github.com/kubernetes/charts/commit/3df661cc):  Use the gocd-agent-docker-dind image of the tag same as of GoCD app version

### 1.1.2

* [ec6474b9](https://github.com/kubernetes/charts/commit/ec6474b9):  Fix heath check->health check (#6269)

### 1.1.1

* [ccd0a08d](https://github.com/kubernetes/charts/commit/ccd0a08d): Do not perform preconfigure_server script if server has already been configured

### 1.1.0

* [31990cd8](https://github.com/kubernetes/charts/commit/31990cd8): Support for ELB SSL using AWS ACM

### 1.0.9

* [3198a22c](https://github.com/kubernetes/charts/commit/3198a22c): Bump up application version to 18.6

### 1.0.8

* [4607974a](https://github.com/kubernetes/charts/commit/4607974a): Bump up application version to 18.5

### 1.0.7

* [0c66dbf](https://github.com/kubernetes/charts/commit/0c66dbf): Support TLS for ingress

### 1.0.6

* [98cead4](https://github.com/kubernetes/charts/commit/98cead4): Bump up application version to 18.3

### 1.0.5

* [8b205e0](https://github.com/kubernetes/charts/commit/8b205e0): Add a script to preconfigure the GoCD server using the `postStart` lifecycle hook.

### 1.0.4

* [7fa1860](https://github.com/kubernetes/charts/commit/7fa1860): Typo fix

### 1.0.3

* [c1eaaa1](https://github.com/kubernetes/charts/commit/c1eaaa1): README changes

### 1.0.2

* [ca90ee6](https://github.com/kubernetes/charts/commit/ca90ee6): fix typo: change recalim -> reclaim in README.

### 1.0.1

* [d9e850b](https://github.com/kubernetes/charts/commit/d9e850b): Changed kubernetes plugin version to v1.0.0

### 1.0.0

* [9323233](https://github.com/kubernetes/charts/commit/9325233): Moved the GoCD Helm chart to stable
