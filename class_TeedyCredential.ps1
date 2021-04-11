class TeedyCredential
{
    [string]$URL
    [string] hidden $Token
    [string] hidden $ContentType
    [hashtable] hidden $Headers

    # Constructor
    TeedyCredential(
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
        Write-Verbose "Full URL Is: $fullURL"
        return $fullURL
    }

    [PSCustomObject] GetDocuments(){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/document/list") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }

    [PSCustomObject] GetDocument([string]$id){
        return Invoke-RestMethod -Uri $this.GetFullAPIUrl("/api/document/$id") -ContentType $this.ContentType -Headers $this.Headers -Method Get
    }
}