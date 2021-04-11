. ./class_TeedyService.ps1
function Get-TeedyFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyService]$TeedyService   
    )
    
    $res = Invoke-RestMethod -Uri $TeedyService.GetFullAPIUrl("/api/file/list") -Method Get -Headers $TeedyService.Headers
    return $res.files
}