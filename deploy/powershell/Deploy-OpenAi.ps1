#!/usr/bin/pwsh

Param(
    [parameter(Mandatory=$true)][string]$name,
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$location,
    [parameter(Mandatory=$true)][string]$deployment=$null
)

Push-Location $($MyInvocation.InvocationName | Split-Path)

if ($name) {
    $openAi=$(az cognitiveservices account show -g $resourceGroup -n $name -o json | ConvertFrom-Json)
    if (-not $openAi) {
        $openAi=$(az cognitiveservices account create -g $resourceGroup -n $name --kind OpenAI --sku S0 --location $location --yes -o json | ConvertFrom-Json)
    }
} else {
    $openAi=$(az cognitiveservices account list -g $resourceGroup -o json | ConvertFrom-Json)[0]
}

if ($deployment) {
    $openAiDeployment=$(az cognitiveservices account deployment show -g $resourceGroup -n $openAi.name --deployment-name $deployment)
    if (-not $openAiDeployment) {
        $openAiDeployment=$(az cognitiveservices account deployment create -g $resourceGroup -n $openAi.name --deployment-name $deployment --model-name 'text-davinci-003' --model-version '1' --model-format OpenAI --scale-settings-scale-type "Standard" --scale-settings-capacity "10")
    }
} else {
    $deployment='completions'
    $openAiDeployment=$(az cognitiveservices account deployment show -g $resourceGroup -n $openAi.name --deployment-name $deployment)
}

Pop-Location