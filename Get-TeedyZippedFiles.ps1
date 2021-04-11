. ./class_TeedyService.ps1
function Get-TeedyZippedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        $ID
    )
    
    $body = @{
        id = $ID
    }

    $res = Invoke-RestMethod -Uri $TeedyService.GetFullAPIUrl("/api/file/zip") -Method Get -Headers $TeedyService.Headers -Body $body -Outfile "blah.zip" -ContentType 'application/x-www-form-urlencoded'
}