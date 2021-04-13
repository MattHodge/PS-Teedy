. ./class_TeedyService.ps1
. ./Get-TeedyDocuments.ps1
. ./Get-TeedyDocument.ps1
function Export-TeedyDocuments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $false)]
        [string]
        $Directory = (Get-Location)
    )

    $ErrorActionPreference = 'Stop'
    
    $documents = Get-TeedyDocuments -TeedyService $TeedyService
    foreach ($doc in $documents) {
        $docId = $doc.id

        # Create directory for the document
        $directoryToSaveFile = Join-Path -Path $Directory -ChildPath $docId
        New-Item -Path $directoryToSaveFile -ItemType Directory -Force

        # Save the document JSON
        $jsonFilePath = Join-Path -Path $directoryToSaveFile -Child "$docId.json"
        Get-TeedyDocument -TeedyService $TeedyService -ID $docId | ConvertTo-Json | Out-File -FilePath $jsonFilePath
        
        if ($doc.file_count -gt 0) {
            # Download the attachments
            Get-TeedyZippedFiles -TeedyService $TeedyService -ID $docId -Directory $directoryToSaveFile -Verbose
        }
    }
}