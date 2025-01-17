# Cosmos DB NoSQL API - Payments

## Introduction

This repository provides a code sample in .NET on how you might use a combination of Azure Functions, Cosmos DB, OpenAI and EventHub to implement a payment tracking process.

## Scenario

The scenario centers around a payments and transactions solution. Members having accounts, each account with corresponding balances, overdraft limits and credit/debit transactions. 

Transaction data is replicated across multiple geographic regions for both reads and writes, while maintaining consistency. Updates are made efficiently with the patch operation.

Business rules govern if a transaction is allowed. 

An AI powered co-pilot enables agents to analyze transactions using natural language.

## Solution Architecture

The solution architecture is represented by this diagram:

<p align="center">
    <img src="img/architecture.png" width="100%">
</p>

## Deployment

### Prerequisites

- Powershell
- Azure CLI 2.49.0 or greater

### Standard Deployments

From the `deploy/powershell` folder, run the following command. This should provision all of the necessary infrastructure, deploy builds to the function apps, deploy the frontend, and deploy necessary artifacts to the Synapse workspace.

```pwsh
.\Unified-Deploy.ps1 -resourceGroup <resource-group-name> `
                     -subscription <subscription-id>
```

### Deployments using an existing OpenAI service

For deployments that need to use an existing OpenAI service, run the following from the `deploy/powershell`.  This will provision all of the necessary infrastruction except the Azure OpenAI service and will deploy the function apps, the frontend, and Synapse artifacts.

```pwsh
.\Unified-Deploy.ps1 -resourceGroup <resource-group-name> `
                     -subscription <subscription-id> `
                     -openAiName <openAi-service-name> `
                     -openAiRg <openAi-resource-group-name> `
                     -openAiDeployment <openAi-completions-deployment-name>
```

### Enabling/Disabling Deployment Steps

The following flags can be used to enable/disable specific deployment steps in the `Unified-Deploy.ps1` script.

| Parameter Name | Description |
|----------------|-------------|
| stepDeployBicep | Enables or disables the provisioning of resources in Azure via Bicep templates (located in `./infrastructure`). Valid values are 0 (Disabled) and 1 (Enabled). See the `deploy/powershell/Deploy-Bicep.ps1` script.
| stepPublishFunctionApp | Enables or disables the publish and zip deployment of the `CorePayments.FunctionApp` project to the regional function apps present in the target resource group. Valid values are 0 (Disabled) and 1 (Enabled). See the `deploy/infrastructure/Publish-FunctionApp.ps1` script.
| stepDeployOpenAi | Enables or disables the provisioning of (or detection of an existing) Azure OpenAI service. If an explicit OpenAi resource group is not defined in the `openAiRg` parameter, the target resource group defaults to that passed in the `resourceGroup` parameter. Valid values are 0 (Disabled) and 1 (Enabled). See the `deploy/infrastructure/Deploy-OpenAi.ps1` script.
| stepPublishSite | Enables or disables the build and deployment of the static HTML site to the hosting storage account in the target resource group. Valid values are 0 (Disabled) and 1 (Enabled). See the `deploy/infrastructure/Publish-Site.ps1` script.
| stepLoginAzure | Enables or disables interactive Azure login. If disabled, the deployment assumes that the current Azure CLI session is valid. Valid values are 0 (Disabled). 

Example command:
```pwsh
cd deploy/powershell
./Unified-Deploy.ps1 -resourceGroup myRg `
                     -subscription 0000... `
                     -openAiName myOpenAi `
                     -openAiRg myOpenAiRg `
                     -openAiDeployment completions `
                     -stepLoginAzure 0 `
                     -stepDeployBicep 0 `
                     -stepPublishFunctionApp 1 `
                     -stepPublishSite 1
```

### Quickstart

1. After deployment is complete, go to the resource group for your deployment and open the Azure Storage Account prefixed with `web`.  This is the storage account hosting the static web app.
1. Select the `Static website` blade in the left-hand navigation pane and copy the site URL from the `Primary endpoint` field in the detail view.

    <p align="center">
        <img src="img/website-url.png" width="100%">
    </p>

1. Browse to the URL copied in the previous step to access the web app.