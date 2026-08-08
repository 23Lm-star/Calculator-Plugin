[CmdletBinding()]
param(
    [string]$ReleaseDirectory,
    [string]$Version = '1.1.0',
    [string]$PayloadPath,
    [string]$OutputDirectory,
    [string]$ReadmePath
)

$ErrorActionPreference = 'Stop'
$applicationName = 'WangChenyangCalculator'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = (Resolve-Path (Join-Path $scriptRoot '..\..')).Path
if ([string]::IsNullOrWhiteSpace($ReleaseDirectory)) {
    $ReleaseDirectory = Join-Path $projectRoot 'build\v1.1-app\release'
}
if ([string]::IsNullOrWhiteSpace($PayloadPath)) {
    $PayloadPath = if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
        Join-Path $projectRoot 'release\Payload.zip'
    }
    else {
        Join-Path $OutputDirectory 'Payload.zip'
    }
}
if ([string]::IsNullOrWhiteSpace($ReadmePath)) {
    $ReadmePath = Join-Path $projectRoot 'release\README.md'
}

$releasePath = (Resolve-Path $ReleaseDirectory).Path
$payloadPath = [IO.Path]::GetFullPath($PayloadPath)
$readmePath = (Resolve-Path $ReadmePath).Path
$payloadDirectory = Split-Path -Parent $payloadPath
$packageName = "$applicationName-$Version"

if ($Version -notmatch '^\d+\.\d+\.\d+([-.][0-9A-Za-z.]+)?$') {
    throw 'Version must use a portable numeric version such as 1.1.0.'
}

function Test-UnsafePath([string]$Value) {
    return $Value -match '(?i)(?:^|[^A-Za-z0-9_])[A-Z]:[\\/]' -or
        $Value -match '(?i)(?:^|[^A-Za-z0-9_])\\\\\?\\(?:[A-Z]:|UNC\\)' -or
        $Value -match '(?i)(?:^|[^A-Za-z0-9_])\\\\[^\\/]+' -or
        $Value -match '(?<![A-Za-z0-9_.-])\.\.(?:[\\/]|$)'
}

function Assert-SafePackageText([string]$PackagePath) {
    $textExtensions = @('.cmd', '.ini', '.json', '.md', '.ps1', '.txt', '.xml', '.yml', '.yaml')
    $unsafeFiles = @()
    foreach ($file in Get-ChildItem -LiteralPath $PackagePath -File -Recurse) {
        if ($file.Extension.ToLowerInvariant() -in $textExtensions -and (Test-UnsafePath (Get-Content -LiteralPath $file.FullName -Raw))) {
            $unsafeFiles += $file.FullName.Substring($PackagePath.Length).TrimStart('\', '/')
        }
    }
    if ($unsafeFiles.Count -gt 0) {
        throw "Unsafe path found in package text: $($unsafeFiles -join ', ')"
    }
}

function Assert-SafeArchive([string]$ArchivePath, [string[]]$AllowedEntries) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($ArchivePath)
    try {
        $unsafeEntries = @()
        foreach ($entry in $archive.Entries) {
            $entryName = $entry.FullName.Replace('/', '\\').TrimEnd('\\')
            if ((Test-UnsafePath $entry.FullName) -or $entryName -notin $AllowedEntries) {
                $unsafeEntries += $entry.FullName
            }
        }
        if ($unsafeEntries.Count -gt 0) {
            throw "Unsafe or unapproved archive entries: $($unsafeEntries -join ', ')"
        }
    }
    finally {
        $archive.Dispose()
    }
}

$runtimeNames = @(
    "$applicationName.exe", 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Svg.dll', 'Qt5Widgets.dll',
    'D3Dcompiler_47.dll', 'icudt58.dll', 'icuin58.dll', 'icuuc58.dll', 'libEGL.dll',
    'libGLESV2.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll',
    'opengl32sw.dll', 'vc_redist.x64.exe'
)
$requiredFiles = @(
    "$applicationName.exe", 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll',
    'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe',
    'platforms\qwindows.dll'
)
foreach ($relativePath in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $releasePath $relativePath) -PathType Leaf)) {
        throw "Required runtime file is missing: $relativePath"
    }
}

$temporaryRoot = Join-Path $env:TEMP ('WangChenyangCalculator-Payload-' + [guid]::NewGuid().ToString('N'))
$stagingPath = Join-Path $temporaryRoot $packageName
$temporaryPayloadPath = Join-Path $temporaryRoot 'Payload.zip'
New-Item -ItemType Directory -Force -Path $payloadDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $stagingPath | Out-Null
try {
    $packageFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($runtimeName in $runtimeNames) {
        $sourcePath = Join-Path $releasePath $runtimeName
        if (Test-Path -LiteralPath $sourcePath -PathType Leaf) {
            Copy-Item -LiteralPath $sourcePath -Destination $stagingPath -Force
            $packageFiles.Add($runtimeName)
        }
    }

    $platformDirectory = Join-Path $stagingPath 'platforms'
    New-Item -ItemType Directory -Force -Path $platformDirectory | Out-Null
    Copy-Item -LiteralPath (Join-Path $releasePath 'platforms\qwindows.dll') -Destination $platformDirectory -Force
    $packageFiles.Add('platforms\qwindows.dll')
    Copy-Item -LiteralPath (Join-Path $scriptRoot 'Create-DesktopShortcut.ps1') -Destination $stagingPath -Force
    Copy-Item -LiteralPath $readmePath -Destination $stagingPath -Force
    $packageFiles.Add('Create-DesktopShortcut.ps1')
    $packageFiles.Add('README.md')

    Assert-SafePackageText $stagingPath
    Compress-Archive -LiteralPath $stagingPath -DestinationPath $temporaryPayloadPath -CompressionLevel Optimal -Force
    if (-not (Test-Path -LiteralPath $temporaryPayloadPath -PathType Leaf)) {
        throw 'Payload ZIP creation failed.'
    }
    Assert-SafeArchive $temporaryPayloadPath (@($packageFiles | ForEach-Object { "$packageName\$_" }) + $packageName)
    Move-Item -LiteralPath $temporaryPayloadPath -Destination $payloadPath -Force
}
finally {
    if (Test-Path -LiteralPath $temporaryRoot) {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}

Get-Item -LiteralPath $payloadPath | Select-Object Name, Length, LastWriteTime
