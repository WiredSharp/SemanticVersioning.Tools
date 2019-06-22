@"
foreach (`$folder in @("bin", "obj", $ArtifactFolder, $IntermediateFolder)) {
  Get-ChildItem -Filter `$folder -Directory -Recurse | Remove-Item -Recurse
}
"@