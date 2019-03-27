function main {
param([string]$rawTemplates, [string]$rawGenerated)
    $root = $pwd.Path + '\..\'
    $astyleExePath = $root + "tools\astyle.exe"
    # TODO [sim]:  move tt executable to tools folder
    $textTransformExePath = "D:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\TextTransform.exe"

    $templates = $rawTemplates.Split(';')
    $generates = $rawGenerated.Split(';')

    $templates | % {
        $template = $_

        # transform tt
        Invoke-Expression -Command ('& $textTransformExePath ' + $template)

        Write-Host 'Transformed ' $template
    }

    $generates | % {
        $generated = $_
        
        # fix indents
        Invoke-Expression -Command ($astyleExePath + ' --style=allman --indent-namespaces ' + $generated)

        # remove empty lines (this is not possible with current astyle version)
        $value = Get-Content $generated | Select-String -NotMatch -Pattern ^\n*$

        Set-Content -Path $generated -Value $value
    }
}

main $args[0] $args[1]
