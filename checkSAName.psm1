<#
.DESCRIPTION
    Check if the storage account name is available using Graph API
#>

function checkSAName {

    [CmdletBinding()]
    param (

        [string]$keyVaultName,
        [string]$secretName,
        [string]$storageAccountName

    )

    # Define your Azure AD credentials
    $tenantId = (Get-AzContext).Tenant.Id
    $clientId = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name 'clientId' -AsPlainText)
    $clientSecret = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName -AsPlainText)

    # Construct the token endpoint URL
    $tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    # Create a hashtable with the required parameters for the token request

    $tokenParams = @{

        client_id     = $clientId
        scope         = "https://graph.microsoft.com/.default"
        client_secret = $clientSecret
        grant_type    = "client_credentials"

    }

    # Get an access token using client credentials
    $tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method POST -ContentType "application/x-www-form-urlencoded" -Body $tokenParams

    # Extract the access token
    $accessToken = $tokenResponse.access_token

    # Construct the URL for querying storage account name availability
    $tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    # Create a hashtable with the required parameters for the token request
    $body = @{

        name = $storageAccountName
        type = "Microsoft.Storage/storageAccounts"
    
    }

    $header = @{
        Authorization = "Bearer $accessToken"
    }

    Invoke-RestMethod -Method Post -Uri $uri -Body $body -Headers $header


}

Export-ModuleMember -Function checkSAName