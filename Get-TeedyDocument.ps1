. ./class_TeedyService.ps1
function Get-TeedyDocument {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        $ID
    )

    return $TeedyService.GetDocument($ID)
}