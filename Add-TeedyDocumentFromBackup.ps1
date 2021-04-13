. ./class_TeedyService.ps1
. ./Add-TeedyTag.ps1
. ./Get-TeedyTags.ps1
function Add-TeedyDocumentFromBackup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $true)]
        [string]
        [ValidateScript({
            if (!(Test-Path $_)) {
                throw "ERROR: File $_ doesn't exist"
            }

            $f = Get-ChildItem -Path $_

            if (!([guid]::TryParse($f.BaseName, $([ref][guid]::Empty)))) {
                throw "ERROR: File base name isn't a GUID (it was $f.BaseName). Are you sure this is a document backup?"
            }

            return $true
        })]
        $FilePath
    )
    
    $doc = Get-Content -Path $FilePath | ConvertFrom-Json

    $existingTags = Get-TeedyTags -TeedyService $TeedyService

    # set the tags array to empty array so compare-object works
    if (!($existingTags)) {
        $existingTags = @()
    }

    $documentTags = $doc | Select-Object -ExpandProperty tags # select just the tags from the doc

     # set the tags array to empty array so compare-object works
    if (!($documentTags)) {
        $documentTags = @()
    }

    $compare = Compare-Object -ReferenceObject $existingTags -DifferenceObject $documentTags

    foreach ($tag in $compare) {
        if ($tag.SideIndicator -eq '=>'){
            Write-Verbose "Adding Tag $($tag.InputObject.id)"
            Add-TeedyTag -TeedyService $TeedyService -Name $tag.InputObject.name -Color $tag.InputObject.color
        }
    }
    
    # tags when adding to teedy need to be a list of strings, not a list of objects
    $flatDocuemntTags = $documentTags | Select-Object -ExpandProperty name

    # get a fresh tags list, filter them to what is in the imported documnets tag list, and then just return the guids
    $existingTags = Get-TeedyTags -TeedyService $TeedyService | Where-Object { $_.name -in $flatDocuemntTags} |  Select-Object -ExpandProperty id

    return $TeedyService.AddDocument($doc.title, $doc.description,  $doc.subject, $doc.identifier, $doc.publisher, $doc.format, $doc.source, $doc.type, $doc.language, $doc.create_date, $existingTags)
}