. ./class_TeedyCredential.ps1
function Get-TeedyZippedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential,

        [Parameter(Mandatory = $true)]
        [string]
        $ID
    )
    
    $body = @{
        id = $ID
    }

    $res = Invoke-RestMethod -Uri $TeedyCredential.GetFullAPIUrl("/api/file/zip") -Method Get -Headers $TeedyCredential.Headers -Body $body -Outfile "blah.zip" -ContentType 'application/x-www-form-urlencoded'
}