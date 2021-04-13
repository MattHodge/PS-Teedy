class TeedyService
{
    [string]$URL
    [string] hidden $Token
    [string] hidden $ContentType
    [hashtable] hidden $Headers

    # Constructor
    TeedyService(
        [string]$u,
        [string]$t
    ){
        $this.URL = $u
        $this.Token = $t
        $this.Headers = @{
            "Cookie" = "auth_token=" + $t
        }
        $this.ContentType = "application/x-www-form-urlencoded"
    }

    [string] GetFullAPIUrl([string]$path){
        $fullURL = $this.URL + $path
        return $fullURL
    }

    [PSCustomObject] GetDocuments(){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/document/list") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }

    [PSCustomObject] GetDocument([string]$id){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/document/$id") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }

    [PSCustomObject] GetTags(){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/tag/list") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }

    [PSCustomObject] GetTag([string]$id){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/tag/$id") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }

    [PSCustomObject] AddTag([string]$name, [string]$color, [string]$parent){
        $body = @{
            name = $Name
            color = $Color
            parent = $Parent
        }

        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/tag") -ContentType $this.ContentType -Headers $this.Headers -Method Put -Body $body
    }

    [PSCustomObject] AddDocument([string]$title, [string]$description, [string]$subject, [string] $identifier, [string] $publisher, [string] $format, [string]$source, [string]$type, [string]$language, [long]$create_date, [string[]]$tags){
        # Teedy requires multiple tags to be posted via the query string
        # eg. &tags=dc38fd3d-ea33-45ca-9337-91d4f53c8c60&tags=54a310ff-97d0-47b9-ae6c-a824fb7ae8c9
        # Using a hashtable for the body of Invoke-WebRequest doesn't work for this.
        # Instead, you need to craft your own query string: https://stackoverflow.com/a/32443537
        
        $queryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $queryParams["title"] = $title
        $queryParams["description"] = $description
        $queryParams["subject"] = $subject
        $queryParams["identifier"] = $identifier
        $queryParams["publisher"] = $publisher
        $queryParams["format"] = $format
        $queryParams["source"] = $source
        $queryParams["type"] = $type
        $queryParams["language"] = $language
        $queryParams["create_date"] = $create_date

        foreach ($tag in $tags) {
            $queryParams.Add("tags", "$tag")
        }

        $request = [System.UriBuilder]$this.GetFullAPIUrl("/api/document")
        $request.Query = $queryParams.ToString()

        return Invoke-RestMethod -Uri $request.Uri -ContentType $this.ContentType -Headers $this.Headers -Method Put
    }

    [PSCustomObject] GetZippedFile([string]$id){
        $body = @{
            id = $id
        }

        return Invoke-WebRequest -Uri $this.GetFullAPIUrl("/api/file/zip") -ContentType $this.ContentType -Headers $this.Headers -Method Get -Body $body
    }
}