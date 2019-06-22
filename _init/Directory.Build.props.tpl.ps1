@"
<Project>
  <PropertyGroup>
    <!-- To be resolved from nuget package version  see https://github.com/zericco/Study.VersionUpdater -->
    <VersionMajor Condition="'`$(VersionMajor)'==''">1</VersionMajor>
    <VersionMinor Condition="'`$(VersionMinor)'==''">0</VersionMinor>
    <VersionPatch Condition="'`$(VersionPatch)'==''">0</VersionPatch>
    <Authors>$Author</Authors>
    <Company>$Company</Company>
    <Product>$Product</Product>
    <Version  Condition="'`$(Version)'==''">`$(VersionMajor).`$(VersionMinor).`$(VersionPatch)</Version>
    <AssemblyInformationalVersion>`$(VersionMajor).`$(VersionMinor).`$(VersionPatch)+12345</AssemblyInformationalVersion>
    <AssemblyVersion>`$(VersionMajor).0.0.0</AssemblyVersion>
    <FileVersion>`$(VersionMajor).0.0.0</FileVersion>
    <ArtifactFolderName>$ArtifactFolder</ArtifactFolderName>
    <IntermediateFolderName>$IntermediateFolder</IntermediateFolderName>
  </PropertyGroup>
</Project>
"@