. ./class_TeedyService.ps1
function Get-TeedyTags {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService
    )
    
    $res = Invoke-RestMethod -Uri $TeedyService.GetFullAPIUrl("/api/tag/list") -Method Get -Headers $TeedyService.Headers -ContentType 'application/x-www-form-urlencoded'
    return $res.tags
}