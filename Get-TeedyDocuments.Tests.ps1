BeforeAll { 
    . $PSScriptRoot/Get-TeedyDocuments.ps1

    $teedyCredential = [TeedyCredential]::new("http://fake", "faketoken")
}

Describe "Test Get-TeedyDocuments" {
    It "Returns Documents" {
        $fakeResult = @"
        <Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
        <Obj RefId="0">
          <TN RefId="0">
            <T>System.Management.Automation.PSCustomObject</T>
            <T>System.Object</T>
          </TN>
          <MS>
            <I64 N="total">3</I64>
            <Obj N="documents" RefId="1">
              <TN RefId="1">
                <T>System.Object[]</T>
                <T>System.Array</T>
                <T>System.Object</T>
              </TN>
              <LST>
                <Obj RefId="2">
                  <TNRef RefId="0" />
                  <MS>
                    <S N="id">557aeee4-aa21-4369-8c1c-9705c842c673</S>
                  </MS>
                </Obj>
                <Obj RefId="5">
                  <TNRef RefId="0" />
                  <MS>
                    <S N="id">55acb7ef-e918-4004-adbc-e8324fe45a1b</S>
                  </MS>
                </Obj>
              </LST>
            </Obj>
            <Obj N="suggestions" RefId="10">
              <TNRef RefId="1" />
              <LST />
            </Obj>
          </MS>
        </Obj>
      </Objs>
"@ 
        
        Mock Invoke-RestMethod { return [System.Management.Automation.PSSerializer]::Deserialize($fakeResult) }
        
        $res = Get-TeedyDocuments -TeedyCredential $teedyCredential
        $res[0].id | Should -Be '557aeee4-aa21-4369-8c1c-9705c842c673'
        $res[1].id | Should -Be '55acb7ef-e918-4004-adbc-e8324fe45a1b'
    }
}