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
