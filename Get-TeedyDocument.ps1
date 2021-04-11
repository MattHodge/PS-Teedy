. ./class_TeedyCredential.ps1
function Get-TeedyDocument {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential,

        [Parameter(Mandatory = $true)]
        [string]
        $ID
    )

    return $TeedyCredential.GetDocument($ID)
}