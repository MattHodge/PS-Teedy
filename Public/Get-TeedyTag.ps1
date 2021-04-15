function Get-TeedyTags {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        $ID
    )

    return $TeedyService.GetTag($ID)
}