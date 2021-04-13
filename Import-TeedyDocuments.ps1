. ./class_TeedyService.ps1
. ./Get-TeedyDocuments.ps1
. ./Get-TeedyDocument.ps1
. ./Add-TeedyDocumentFromBackup.ps1
function Import-TeedyDocuments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [TeedyService]$TeedyService,

        [Parameter(Mandatory = $false)]
        [string]
        $Directory = (Get-Location)
    )

    $ErrorActionPreference = 'Stop'
    
    $metadataPath = Join-Path -Path $Directory -ChildPath "backup_metadata.json"
    
    if (!(Test-Path -Path $metadataPath)) {
        Write-Error -Message "Unable to find the backup metadata file at $metadataPath. Is this the correct backup directory?" -ErrorAction Stop
    }

    $backupMetadata = Get-Content -Path $metadataPath | ConvertFrom-Json

    foreach ($doc in $backupMetadata) {
        Add-TeedyDocumentFromBackup -TeedyService $TeedyService -FilePath $doc.document_json_path
    }
}