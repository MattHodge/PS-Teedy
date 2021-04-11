. ./class_TeedyCredential.ps1

function Get-TeedyAuthenticationToken {
    <#
    .SYNOPSIS
        Returns a Teedy Authentication Token
    .DESCRIPTION
        Returns a Teedy Authentication Token
    .PARAMETER URL
        URL of the Teedy server
    .PARAMETER Username
        Username for your Teedy account
    .PARAMETER Password
        Password for your Teedy account
    .EXAMPLE
        $cred = Get-Credential -UserName admin
        $token = Get-TeedyAuthenticationToken -URL https://teedy.host.com -Username admin -Password $cred.GetNetworkCredential().SecurePassword
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $URL,

        [Parameter(Mandatory = $true)]
        [string]
        $Username,

        [Parameter(Mandatory = $true)]
        [securestring]
        $Password
    )
    
    $fullURL = $URL.Trim("/") + "/api/user/login"

    $bodyData = @{
        username = $Username
        password = ConvertFrom-SecureString -SecureString $Password -AsPlainText
    }

    $webrequest = Invoke-WebRequest -Uri $fullURL -Body $bodyData -Method Post -SessionVariable websession
    $cookies = $websession.Cookies.GetCookies($fullURL) 

    return [TeedyCredential]::new($URL, $cookies.Value)
}