# Azure DevOps - Self Hosted Linux Agent

This chart provides a basic configuration for an Azure DevOps Self-Hosted Agent.   It will allow a user to control the number of instances and the tools installed on their agents.   Additional detail on self hosted agents can be found [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).  In addition, a sample setup of a full AKS Cluster using this chart, is available [here](https://github.com/gambtho/aks-azuredevops-agent)

## Setup

- Get the name of your Azure DevOps account, will be something like https://dev.azure.com/<your_account> - $ACCOUNT
- Create a [personal access token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts) - $TOKEN
- Create an [agent pool](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=vsts) - $POOL

These values need to be encoded with base64, and can either be applied in a values file, or as part of the helm chart deployment

```bash
helm install ado-agent incubator/ado-agent --set vsts.account=${ACCOUNT},vsts.token=${TOKEN},vsts.pool=${POOL}
```

## Possible changes

- Add pod autoscale
- Use this [startup script](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)
- Fork [gambtho/azure-pipeline-agent](https://hub.docker.com/r/gambtho/azure-pipeline-agent/dockerfile) and add any additional tools you may want
