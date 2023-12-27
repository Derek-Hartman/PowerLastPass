<#
.Synopsis
    Get Detailed Shared Folder Data

.EXAMPLE 
    Get-LastPassSharedFolders -CID "####" -ProvisioningHash "####"

.NOTES
    Modified by: Derek Hartman
    Date: 12/20/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-LastPassSharedFolders {
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Customer ID.")]
        [string[]]$CID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Provisioning Hash.")]
        [string[]]$ProvisioningHash
    )

    $Uri = "https://lastpass.com/enterpriseapi.php"

    $Body = @{"cid" = "$CID"}
    $Body += @{"provhash" = "$ProvisioningHash"}
    $Body += @{"cmd" = "getdetailedsfdata"}

    $JsonBody = ConvertTo-Json $Body

    $Response = Invoke-RestMethod -Uri $Uri -Method Post -Body $JsonBody

    $Items = $Response | Get-Member
	
    $Output = @()
    ForEach ($Item in $Items) {
        If ($Item.Name -eq "Equals") {
        }
        ElseIf ($Item.Name -eq "GetHashCode") {
        }
        ElseIf ($Item.Name -eq "GetType") {
        }
        ElseIf ($Item.Name -eq "ToString") {
        }
        Else {
            $Output += $Response.$($Item.Name)
        }
    }
    Write-Output $Output
}