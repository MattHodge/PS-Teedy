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

    [PSCustomObject] AddTag([string]$name, [string]$color, [string]$parent){
        $body = @{
            name = $Name
            color = $Color
            parent = $Parent
        }

        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/tag") -ContentType $this.ContentType -Headers $this.Headers -Method Put -Body $body
    }

    [PSCustomObject] GetZippedFile([string]$id){
        $body = @{
            id = $id
        }

        return Invoke-WebRequest -Uri $this.GetFullAPIUrl("/api/file/zip") -ContentType $this.ContentType -Headers $this.Headers -Method Get -Body $body
    }
}