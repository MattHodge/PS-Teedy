. ./class_TeedyService.ps1
function Add-TeedyTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]
        # Validate hex colour code
        [ValidateScript({
            if ($_ -cnotmatch  '^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$') {
                throw "ERROR: Enter a hex color like #ff0000"
            }
            $true
        })]
        $Color,

        [Parameter()]
        [string]
        $Parent
    )

    return $TeedyService.AddTag($Name, $Color, $Parent)
}