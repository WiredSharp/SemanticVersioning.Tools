[CmdletBinding(SupportsShouldProcess)]
Param(
    # indicate the root namespace for projects
    [Parameter(HelpMessage="root namespace")] [string] $RootNamespace
    # indicate reference(s) for core project
    ,[Parameter(HelpMessage="core project references")] [string[]] $CorePackages
    # indicate reference(s) for test project
    ,[Parameter(HelpMessage="test project references")] [string[]] $TestPackages = @()
)

$sourceFolder = "src"
$testFolder = "test"

if (!$RootNamespace) {
    $RootNamespace = [System.IO.Path]::GetFileName((Get-Location).Path)
}

Set-StrictMode -Version Latest

# create core project
Write-Verbose "creating core project: ${RootNamespace}.core..."
dotnet new classlib --name "${RootNamespace}.core" -o "${sourceFolder}\${RootNamespace}.core\" --no-restore
foreach ($reference in $CorePackages) {
    dotnet add ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj" package $CorePackages
}

# create test project
Write-Verbose "creating test project: ${RootNamespace}.tests..."
dotnet new classlib --name "${RootNamespace}.tests" -o "${testFolder}\${RootNamespace}.tests\" --no-restore
dotnet add ".\${testFolder}\${RootNamespace}.tests\${RootNamespace}.tests.csproj" reference ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj"
foreach ($reference in ("NUnit", "NSubstitute") + $TestPackages) {
    Write-Debug "adding test project reference: $reference"
    dotnet add ".\${testFolder}\${RootNamespace}.tests\${RootNamespace}.tests.csproj" package $reference
}

function New-ConsoleProject([string]$name){
    # create console project
    dotnet new console --name templator -o "${sourceFolder}\${name}\" --no-restore
    dotnet add ".\${sourceFolder}\${name}\${name}.csproj" reference ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj"
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

# create solution
dotnet new sln
dotnet sln add ".\${sourceFolder}\${RootNamespace}.core\${RootNamespace}.core.csproj"
dotnet sln add ".\${testFolder}\${RootNamespace}.tests\${RootNamespace}.tests.csproj"

if (!(Test-Path "ArtifactFolder")) {
    $ArtifactFolder = "artifacts"
}
if (!(Test-Path "IntermediateFolder")) {
    $IntermediateFolder = "artifacts\obj"
}
if (!(Test-Path "Author")) {
    $Author = "EBL"
}
if (!(Test-Path "Product")) {
    $Product = $RootNamespace
}
if (!(Test-Path "Company")) {
    $Company = "EBL Inc."
}

foreach ($outputFolder in Get-ChildItem -Recurse -Path ".\" -Filter "$ArtifactFolder") {
    Remove-Item -Recurse -Path $outputFolder -Force
}

Apply-Templates $PSScriptRoot
foreach ($folder in Get-ChildItem -Path $PSScriptRoot -Directory) {
    Apply-Templates $folder
}
