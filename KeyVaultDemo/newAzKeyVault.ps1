<#PSScriptInfo

.VERSION 1.0.0.0

.GUID 17b043b2-5b70-4844-9bc6-5caa94ced64c

.AUTHOR linkedin.com/in/lakatosgabor

#>
<#

.DESCRIPTION
Deploy Azure Key Vault from ARM

#>
function printSecret {
    
    param (

        [Parameter(Mandatory = $true)]
        $keyVaultName,
        [Parameter(Mandatory = $true)]
        $secretName
        
    )

    $secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName
    $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)

    try {

        $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
    
    }
    
    finally {

        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
    
    }

    Write-Output $secretValueText
    
}

[string]$projectName = "mslearn" + (Get-Random -Count 1 -Maximum 100)
[string]$location = Read-Host -Prompt "Enter the location (i.e. westeurope, northeurope, etc.)"
[string]$upn = Read-Host -Prompt "Enter your user principal name (email address) used to sign in to Azure"

[string]$secret = openssl rand -base64 32
[securestring]$secretValue = ConvertTo-SecureString -String $secret -AsPlainText -Force
[string]$secretName = Read-Host -Prompt "Enter the secret name"



$resourceGroupName = "${projectName}-rg"
$keyVaultName = "${projectName}-Kv"
$adUserId = (Get-AzADUser -UserPrincipalName $upn).Id
$templateUri = "https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/tutorials-use-key-vault/CreateKeyVault.json"

New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -keyVaultName $keyVaultName -adUserId $adUserId -secretValue $secretValue -secretName $secretName

Read-Host -Prompt "Press [Enter] to print the secret"
printSecret -keyVaultName $keyVaultName -secretName $secretName