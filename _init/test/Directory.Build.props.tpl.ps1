@"
<Project>
  <Import Project="`$([MSBuild]::GetPathOfFileAbove(`$(MSBuildThisFile), `$(MSBuildThisFileDirectory)..))" />
  <PropertyGroup>
    <SolutionDir Condition=" '`$(SolutionDir)' == '' ">`$(MSBuildThisFileDirectory)</SolutionDir>
    <BaseIntermediateOutputPath>`$(SolutionDir)`$(IntermediateFolderName)\`$(MSBuildProjectName)\</BaseIntermediateOutputPath>
    <BaseOutputPath Condition=" '`$(OutputPath)' == '' ">`$(SolutionDir)`$(ArtifactFolderName)\test</BaseOutputPath>
  </PropertyGroup>
</Project>
"@