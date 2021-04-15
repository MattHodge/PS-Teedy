function Get-TeedyService {
    <#
    .SYNOPSIS
        Returns a Teedy Authentication Token
    .DESCRIPTION
        Returns a Teedy Authentication Token
    .PARAMETER URL
        URL of the Teedy server
    .PARAMETER Credential
        Username for your Teedy account
    .EXAMPLE
        $creds = Get-Credential -UserName admin
        $token = Get-TeedyService -URL https://teedy.host.com -Credential $creds
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $URL,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $fullURL = $URL.Trim("/") + "/api/user/login"

    $bodyData = @{
        username = $Credential.UserName
        password = $Credential.GetNetworkCredential().Password
    }

    $webrequest = Invoke-WebRequest -Uri $fullURL -Body $bodyData -Method Post -SessionVariable websession
    $cookies = $websession.Cookies.GetCookies($fullURL)

    return [TeedyService]::new($URL, $cookies.Value)
}