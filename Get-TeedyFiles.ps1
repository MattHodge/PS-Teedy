. ./class_TeedyCredential.ps1
function Get-TeedyFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential   
    )
    
    $res = Invoke-RestMethod -Uri $TeedyCredential.GetFullAPIUrl("/api/file/list") -Method Get -Headers $TeedyCredential.Headers
    return $res.files
}