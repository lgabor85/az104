<# 
.DESCRIPTION
    Creates an Azure Storage Account and its associated resources. Returns the storage account connection string.

#>

#             ┌─────────┐
# ------------|functions|------------
#             └─────────┘

# Import external modules
Import-Module $PSScriptRoot\checkSAName.psm1

# function to create a new resource group
function newRg {
    [CmdletBinding()]
    param (
        [string]$rgName,
        [string]$location
    )

    New-AzResourceGroup -Name $rgName -Location $location
    
}

# function to create a new storage account
function newStorage {
    [CmdletBinding()]
    param (
        [string]$rgName,
        [string]$location,
        [string]$storageName
    )

    New-AzStorageAccount -ResourceGroupName $rgName -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2

}

# function to get the storage account connection string
function getStorageConnectionString {
    [CmdletBinding()]
    param (
        [string]$rgName,
        [string]$storageName
    )

    (Get-AzStorageAccount -ResourceGroupName $rgName -Name $storageName).Context.ConnectionString

}

#             ┌─────────┐
# ------------|Main Code|------------
#             └─────────┘

$rgName = "functionapp" + (Get-Random -Count 1 -Maximum 100)

# Create new resource group and storage account if user chooses to
$createRg = Read-Host -Prompt "Do you want to create a new resource group? (y/n)"

if ($createRg -eq "y") {

    $location = Read-Host -Prompt "Enter the location (i.e. centralus)"
    newRg -rgName $rgName -location $location

}

$createSa = Read-Host -Prompt "Do you want to create a new storage account? (y/n)"

# Generate SA name and check if its available

$storageNameAvailable = $false

while ($storageNameAvailable -eq $false) {
    
        $storageName = "sa" + (Get-Random -Count 1 -Maximum 100)
        $storageNameAvailable = checkSAName -keyVaultName "mslearn41-Kv" -secretName "appsecexport" -storageAccountName $storageName
    
}


if ($createSa -eq "y") {

    $location = (Get-AzResourceGroup -Name $rgName).Location
    newStorage -rgName $rgName -location $location -storageName $storageName

}


# Get the storage account connection string
Write-Host "Storage Account Connection String:`n"
getStorageConnectionString -rgName $rgName -storageName $storageName