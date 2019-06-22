[CmdletBinding(SupportsShouldProcess)]
Param(
    # indicate the root namespace for projects
    [Parameter(HelpMessage="root namespace")] [string] $RootNamespace
    # indicate reference(s) for core project
    ,[Parameter(HelpMessage="core project references")] [string[]] $CorePackages
    # indicate reference(s) for test project
    ,[Parameter(HelpMessage="test project references")] [string[]] $TestPackages = @()
)

Set-StrictMode -Version Latest

Import-Module "${PSScriptRoot}\initialize.psm1"

Create-Projects

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
