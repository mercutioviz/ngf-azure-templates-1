param(
    [string]$SourceDir = "$env:BUILD_SOURCESDIRECTORY\NGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD",
    [string]$TempDir = $env:TEMP
)
 
$modulePath = Join-Path $TempDir Pester-master\Pester.psm1
 
if (-not(Test-Path $modulePath)) {
 
    # Note: PSGet and chocolatey are not supported in hosted vsts build agent  
    $tempFile = Join-Path $TempDir pester.zip
    Invoke-WebRequest https://github.com/pester/Pester/archive/master.zip -OutFile $tempFile
 
    [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $tempDir)
 
    Remove-Item $tempFile
}
 
Import-Module $modulePath -DisableNameChecking
 
$outputFile = Join-Path $SourceDir "TEST-pester.xml";
 
Invoke-Pester -Path $SourceDir -PassThru -OutputFile $outputFile -OutputFormat NUnitXml -EnableExit