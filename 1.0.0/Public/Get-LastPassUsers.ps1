<#
.Synopsis
    Retrieve list of all lastpass users

.EXAMPLE 
    Get-LastPassUsers -CID "####" -ProvisioningHash "####"

.NOTES
    Modified by: Derek Hartman
    Date: 12/18/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-LastPassUsers {
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
    $Body += @{"cmd" = "getuserdata"}

    $JsonBody = ConvertTo-Json $Body

    $Response = Invoke-RestMethod -Uri $Uri -Method Post -Body $JsonBody

    $Items = $Response.Users | Get-Member
	
    $Output = New-Object System.Collections.ArrayList
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
            $Object = New-Object PSObject
            $Object | Add-Member -MemberType NoteProperty -Name "username" -Value "$($Response.Users.$($Item.Name).username)"
            $Object | Add-Member -MemberType NoteProperty -Name "fullname" -Value "$($Response.Users.$($Item.Name).fullname)"
            $Object | Add-Member -MemberType NoteProperty -Name "mpstrength" -Value "$($Response.Users.$($Item.Name).mpstrength)"
            $Object | Add-Member -MemberType NoteProperty -Name "created" -Value "$($Response.Users.$($Item.Name).created)"
            $Object | Add-Member -MemberType NoteProperty -Name "last_pw_change" -Value "$($Response.Users.$($Item.Name).last_pw_change)"
            $Object | Add-Member -MemberType NoteProperty -Name "last_login" -Value "$($Response.Users.$($Item.Name).last_login)"
            $Object | Add-Member -MemberType NoteProperty -Name "neverloggedin" -Value "$($Response.Users.$($Item.Name).neverloggedin)"
            $Object | Add-Member -MemberType NoteProperty -Name "disabled" -Value "$($Response.Users.$($Item.Name).disabled)"
            $Object | Add-Member -MemberType NoteProperty -Name "admin" -Value "$($Response.Users.$($Item.Name).admin)"
            $Object | Add-Member -MemberType NoteProperty -Name "totalscore" -Value "$($Response.Users.$($Item.Name).totalscore)"
            $Object | Add-Member -MemberType NoteProperty -Name "multifactor" -Value "$($Response.Users.$($Item.Name).multifactor)"
            $Object | Add-Member -MemberType NoteProperty -Name "hasSharingKeys" -Value "$($Response.Users.$($Item.Name).hasSharingKeys)"
            $Object | Add-Member -MemberType NoteProperty -Name "duousername" -Value "$($Response.Users.$($Item.Name).duousername)"
            $Object | Add-Member -MemberType NoteProperty -Name "sites" -Value "$($Response.Users.$($Item.Name).sites)"
            $Object | Add-Member -MemberType NoteProperty -Name "notes" -Value "$($Response.Users.$($Item.Name).notes)"
            $Object | Add-Member -MemberType NoteProperty -Name "formfills" -Value "$($Response.Users.$($Item.Name).formfills)"
            $Object | Add-Member -MemberType NoteProperty -Name "applications" -Value "$($Response.Users.$($Item.Name).applications)"
            $Object | Add-Member -MemberType NoteProperty -Name "attachments" -Value "$($Response.Users.$($Item.Name).attachments)"
            $Object | Add-Member -MemberType NoteProperty -Name "password_reset_required" -Value "$($Response.Users.$($Item.Name).password_reset_required)"
            $Object | Add-Member -MemberType NoteProperty -Name "id" -Value "$($Item.Name)"
            $Output.Add($Object) | Out-Null
        }
    }
    Write-Output $Output
}