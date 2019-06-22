Set-StrictMode -Version Latest

$sourceFolder = "src"
$testFolder = "test"

function Create-Projects
 {
    Param(
        # indicate the root namespace for projects
        [Parameter(HelpMessage="root namespace")] [string] $RootNamespace
        # indicate reference(s) for core project
        ,[Parameter(HelpMessage="core project references")] [string[]] $CorePackages = @()
        # indicate reference(s) for test project
        ,[Parameter(HelpMessage="test project references")] [string[]] $TestPackages = @()
    )
 
    if (!$RootNamespace) {
        $RootNamespace = [System.IO.Path]::GetFileName((Get-Location).Path)
    }
    
    # # create core project
    # Write-Verbose "creating core project: ${RootNamespace}.core..."
    # dotnet new zericcolib --name "${RootNamespace}.core" -o "${sourceFolder}\${RootNamespace}.core\" --no-restore
    # foreach ($reference in $CorePackages) {
    #     Write-Debug "adding core project reference: $reference"
    #     dotnet add ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj" package $CorePackages
    # }

    # # create test project
    # Write-Verbose "creating test project: ${RootNamespace}.tests..."
    # dotnet new zericcout --name "${RootNamespace}.tests" -o "${testFolder}\${RootNamespace}.tests\" --no-restore
    # foreach ($reference in $TestPackages) {
    #     Write-Debug "adding test project reference: $reference"
    #     dotnet add ".\${testFolder}\${RootNamespace}.tests\${RootNamespace}.tests.csproj" package $reference
    # }

    dotnet new zericcosol

    # create solution
    dotnet new sln
    foreach ($csproj in (Get-ChildItem -Recurse -Path "." -Filter "*.csproj")) {
        dotnet sln add $csproj.FullName
    }
}

function New-ConsoleProject
{
    Param(
        # indicate the project name
        [Parameter(Mandatory=$True, HelpMessage="project name")] [string] $name
        # indicate the root namespace for projects
        ,[Parameter(HelpMessage="root namespace")] [string] $RootNamespace
        # indicate reference(s) for project
        ,[Parameter(HelpMessage="project references")] [string[]] $Packages = @()
    )
 
    if (!$RootNamespace) {
        $RootNamespace = [System.IO.Path]::GetFileName((Get-Location).Path)
    }
    
    # create console project
    dotnet new console --name ${name} -o "${sourceFolder}\${name}\" --no-restore
    dotnet add ".\${sourceFolder}\${name}\${name}.csproj" reference ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj"

    foreach ($reference in $Packages) {
        Write-Debug "adding test project reference: $reference"
        dotnet add ".\${sourceFolder}\${name}\${name}.csproj" package $reference
    }

    dotnet sln add ".\${sourceFolder}\${name}\${name}.csproj"
}

function Apply-Template([System.IO.FileInfo] $template) {
    $targetPath = $template.Name -replace ".tpl.ps1", ""
    $folder = (Split-Path (Split-Path $template.FullName) -Leaf)
    if (!($folder -eq (Split-Path $PSScriptRoot -Leaf))){
        $targetPath = Join-Path $folder $targetPath
        if (!(Test-Path $folder)) {
            Write-Debug "$folder does not exists, create it"
            New-Item -Path $folder -ItemType Directory > $null
        }
    }
    if (Test-Path $targetPath) {
        Write-Information "$targetPath already exists, skipping"
    } 
    else {
        Write-Information "generating $template"
        . "$($template.FullName)" > $targetPath
    }
}

function Apply-Templates([System.IO.DirectoryInfo] $sourceFolder) {
    foreach ($template in Get-ChildItem -Path $sourceFolder.FullName -Filter "*.tpl.ps1") {
        Apply-Template $template
    }
}
