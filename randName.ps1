
function randName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$prefix = $null
    )

    # Define the resource types
    $resourceTypes = @("function app", "resource group", "storage account", "virtual network")
    
    if (-not [string]::IsNullOrWhiteSpace($prefix)) {

        $resourceName = $prefix + (Get-Random -Minimum 1000 -Maximum 9999)
    
    }
    else {

        # Display the resource types
        Write-Host "Choose a resource type from the following list:"
        $resourceTypes | ForEach-Object { Write-Host "- $_" }

        # Get user input
        $choice = Read-Host "Choose a resource type"

        switch ($choice) {
            'function app' {
                $resourceName = "functionapp" + (Get-Random -Minimum 1000 -Maximum 9999)
            }
            'resource group' {
                $resourceName = "rg" + (Get-Random -Minimum 1000 -Maximum 9999)
            }
            'storage account' {
                $resourceName = "storage" + (Get-Random -Minimum 1000 -Maximum 9999)
            }
            'virtual network' {
                $resourceName = "vnet" + (Get-Random -Minimum 1000 -Maximum 9999)
            }
            default {
                Write-Host "Unsupported resource type"
                break
            }
        }
    }

    Write-Host $resourceName

}


$select = Read-Host "Do you want to provide a prefix for the resource names? (y/n)"

if ($select -eq 'y') {

    $prefix = Read-Host "Enter the prefix"
    randName -prefix $prefix

} else {

    $prefix = $null
    randName -prefix $prefix
    
}
