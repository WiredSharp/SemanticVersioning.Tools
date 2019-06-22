@"
foreach (`$folder in @("bin", "obj", "$ArtifactFolder", "$IntermediateFolder")) {
  if (Test-Path `$folder) {
    Get-ChildItem -Filter `$folder -Directory -Recurse | Remove-Item -Recurse
  }
}
"@