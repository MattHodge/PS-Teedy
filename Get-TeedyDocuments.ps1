. ./class_TeedyService.ps1
function Get-TeedyDocuments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyService]$TeedyService
    )
    
    $res = $TeedyService.GetDocuments()
    return $res.documents
}