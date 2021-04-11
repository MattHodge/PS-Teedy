. ./class_TeedyService.ps1
function Get-TeedyDocuments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService
    )
    
    $res = $TeedyService.GetDocuments()
    return $res.documents
}