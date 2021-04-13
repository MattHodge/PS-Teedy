. ./class_TeedyService.ps1
. ./Get-TeedyDocuments.ps1
. ./Get-TeedyDocument.ps1
. ./Get-TeedyZippedFiles.ps1
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

    $backedMetadataList = @()
    
    $documents = Get-TeedyDocuments -TeedyService $TeedyService
    foreach ($doc in $documents) {
        $docId = $doc.id

        # Create directory for the document
        $directoryToSaveFile = Join-Path -Path $Directory -ChildPath $docId
        New-Item -Path $directoryToSaveFile -ItemType Directory -Force

        $jsonFilePath = Join-Path -Path $directoryToSaveFile -Child "$docId.json"

        $backupMetadata = @{
            id = $docId
            directory = $directoryToSaveFile
            document_json_path = $jsonFilePath
            hasFiles = $false
            title = $doc.title
        }

        # Save the document JSON
        Get-TeedyDocument -TeedyService $TeedyService -ID $docId | ConvertTo-Json | Out-File -FilePath $jsonFilePath
        
        if ($doc.file_count -gt 0) {
            # Download the attachments
            Get-TeedyZippedFiles -TeedyService $TeedyService -ID $docId -Directory $directoryToSaveFile -Verbose

            $backupMetadata["hasFiles"] = $true
        }

        $backedMetadataList += $backupMetadata
    }

    $backedMetadataList | ConvertTo-Json | Out-File -FilePath (Join-Path -Path $Directory -ChildPath "backup_metadata.json")
}