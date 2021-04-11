. ./class_TeedyCredential.ps1
function Add-TeedyTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TeedyCredential]$TeedyCredential,

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

    $body = @{
        name = $Name
        color = $Color
        # parent = $Parent
    }
    
    Invoke-RestMethod -Uri $TeedyCredential.GetFullAPIUrl("/api/tag") -Method Put -Headers $TeedyCredential.Headers -Body $body -ContentType 'application/x-www-form-urlencoded'
}