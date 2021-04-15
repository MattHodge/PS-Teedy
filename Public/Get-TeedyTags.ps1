function Get-TeedyTags {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService
    )

    $res = $TeedyService.GetTags()
    return $res.tags
}