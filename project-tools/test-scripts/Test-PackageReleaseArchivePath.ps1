[CmdletBinding()]
param(
    [string]$ReleaseDirectory
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = (Resolve-Path (Join-Path $scriptRoot '..\..')).Path
if ([string]::IsNullOrWhiteSpace($ReleaseDirectory)) {
    $ReleaseDirectory = Join-Path $projectRoot 'build\v1.1-app\release'
}

$packageScript = Join-Path $projectRoot 'scripts\release\Package-Release.ps1'
$readmePath = Join-Path $projectRoot 'release\README.md'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('PackageReleaseArchivePath-' + [guid]::NewGuid().ToString('N'))
$payloadPath = Join-Path $testRoot 'Payload.zip'
$version = '1.1.0-path.separator.test'

try {
    New-Item -ItemType Directory -Force -Path $testRoot | Out-Null
    & $packageScript -ReleaseDirectory $ReleaseDirectory -Version $version -PayloadPath $payloadPath -ReadmePath $readmePath
    if (-not (Test-Path -LiteralPath $payloadPath -PathType Leaf)) {
        throw 'Package script did not create the test payload.'
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($payloadPath)
    try {
        $requiredEntry = "WangChenyangCalculator-$version/platforms/qwindows.dll"
        $entryNames = @($archive.Entries | ForEach-Object FullName)
        if ($requiredEntry -notin $entryNames) {
            throw "Expected archive entry is missing: $requiredEntry"
        }
        if ($entryNames -notcontains $requiredEntry -or $requiredEntry -notmatch '/') {
            throw 'Archive did not retain the ZIP forward-slash path required by this regression test.'
        }
    }
    finally {
        $archive.Dispose()
    }

    Write-Output 'ARCHIVE_PATH_SEPARATOR_TEST: PASS'
    Write-Output "Validated ZIP entry: $requiredEntry"
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
