. ./class_TeedyCredential.ps1
function Get-TeedyTags {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential   
    )
    
    $res = Invoke-RestMethod -Uri $TeedyCredential.GetFullAPIUrl("/api/tag/list") -Method Get -Headers $TeedyCredential.Headers -ContentType 'application/x-www-form-urlencoded'
    return $res.tags
}