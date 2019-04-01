function main {
param([string]$rawTemplates, [string]$rawCsGenerated, [string]$rawSqlGenerated)
    $root = $pwd.Path + '\..\'
    $astyleExePath = $root + "tools\astyle.exe"
    # TODO [sim]:  move tt executable to tools folder
    $textTransformExePath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\TextTransform.exe"

    $templates = $rawTemplates.Split(';')
    $csGenerates = $rawCsGenerated.Split(';')
    $sqlGenerates = $rawSqlGenerated.Split(';')

    $templates | % {
        $template = $_

        # transform tt
        Invoke-Expression -Command ('& $textTransformExePath ' + $template)

        Write-Host 'Transformed ' $template
    }

    $csGenerates | % {
        $csGenerated = $_
        
        # fix indents
        Invoke-Expression -Command ($astyleExePath + ' --style=allman --indent-namespaces ' + $csGenerated)

        # remove empty lines (this is not possible with current astyle version)
        $value = Get-Content $csGenerated | Select-String -NotMatch -Pattern ^\n*$

        Set-Content -Path $csGenerated -Value $value
    }

    $sqlGenerates | % {
        $sqlGenerated = $_
        
        # fix indents
        Invoke-Expression -Command ($astyleExePath + ' --style=google ' + $sqlGenerated)

        # remove empty lines (this is not possible with current astyle version)
        $value = Get-Content $sqlGenerated | Select-String -NotMatch -Pattern ^\n*$

        Set-Content -Path $sqlGenerated -Value $value   
    }
}

main $args[0] $args[1] $args[2]
