# Visual Studio - Build and release agent #

VSTS and Team Foundation Server help you implement a continuous integration (CI) and deployment (CD) pipeline for any app. Tutorials, references, and other documentation show you how to configure and manage CI/CD for the app and platform of your choice.

To build or deploy you'll need at least one agent. A Linux agent can build and deploy different kinds of apps, including Java and Android apps. We support Ubuntu, Red Hat, and CentOS.

An agent that you set up and manage on your own to run build and deployment jobs is a private agent. You can use private agents in VSTS or Team Foundation Server (TFS). Private agents give you more control to install dependent software needed for your builds and deployments.
You can install the agent on Windows, Linux, or macOS machines. You can also install an agent on a Linux Docker container.
After you've installed the agent on a machine, you can install any other software on that machine as required by your build or deployment jobs.


## Introduction


## Prerequisites
1. You need to create a vsts account at https://www.visualstudio.com/team-services/
2. You need to create a Personal Access Token (https://docs.microsoft.com/en-us/vsts/build-release/actions/agents/v2-linux?view=vsts)
3. You need to create an agentpool (https://docs.microsoft.com/en-us/vsts/build-release/actions/agents/v2-linux?view=vsts)
4. You need a Kubernetes cluster to deploy the agent on

Without the PAT, account name and agentpool filled in either the values.yaml or by using parameters (see Configuration) you won't be able to deploy the agent

## Installing the Chart
Since this chart is not available yet in the Helm repo you have to run it locally. Go to the vsts directory and run the command below
```bash
$ helm install --name vsts .
```

## Uninstalling
```bash
$ helm delete vsts --purge
```

## Configuration
The following table lists the configurable parameters of the VSTS chart and their default values.

| Parameter                     | Description                   | Default                                                                                                                    |
| ----------------------------- | ----------------------------  | -------------------------------------------------------------------------------------------------------------------------- |
| `vsts.secret.account`         |  vsts account name            | None, needs to be provided. Must be base64 encoded (base64 -w 0).E.g. myproject when the url is myproject.visualstudio.com |
| `vsts.secret.token`           |  vsts personal access token   | None, needs to be provided. Must be base64 encoded (base64 -w 0)                                                           |
| `vsts.agentpool.name`         |  vsts agentpool name          | None, needs to be provided.                                                                                                |
| `vsts.resources.requests.mem` |  min memory need              | `64Mi`                                                                                                                     |
| `vsts.resources.requests.cpu` |  min cpu needed               | `100m`                                                                                                                     |
| `vsts.resources.limits.mem`   |  max memory that can be used  | `128Mi`                                                                                                                    |
| `vsts.resources.limits.cpu`   |  max cpu that can be used     | `200m`                                                                                                                     |


```bash
$ helm install --name vsts --set vsts.secret.account=<bas64 encoded account name>,vsts.secret.token=<base64 encoded token>,vsts.agentpool.name=<naam> .
```

## Roadmap
