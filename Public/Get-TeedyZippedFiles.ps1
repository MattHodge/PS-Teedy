function Get-TeedyZippedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        $ID,

        [Parameter(Mandatory = $false)]
        [string]
        $Directory = (Get-Location)
    )

    $res = $TeedyService.GetZippedFile($ID)
    $res | Save-Download -Directory $Directory -FileName $FileName
}