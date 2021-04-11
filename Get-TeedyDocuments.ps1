. ./class_TeedyCredential.ps1
function Get-TeedyDocuments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential
    )
    
    $res = $TeedyCredential.GetDocuments()
    return $res.documents
}