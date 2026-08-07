[CmdletBinding()]
param(
    [string]$ReleaseDirectory,
    [string]$Version = '1.1.0',
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
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $projectRoot 'artifacts\release'
}
$releasePath = (Resolve-Path $ReleaseDirectory).Path
$outputPath = [IO.Path]::GetFullPath($OutputDirectory)
$defaultReadmePath = Join-Path $projectRoot 'release\README.md'
if ([string]::IsNullOrWhiteSpace($ReadmePath)) {
    $ReadmePath = $defaultReadmePath
}
$ReadmePath = (Resolve-Path $ReadmePath).Path
$packageName = "$applicationName-$Version"
$stagingPath = Join-Path $outputPath $packageName
$zipPath = Join-Path $outputPath ($packageName + '.zip')
$installerPackagePath = Join-Path $outputPath ($packageName + '-Installer.zip')

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

$requiredFiles = @(
    "$applicationName.exe",
    'Qt5Core.dll',
    'Qt5Gui.dll',
    'Qt5Widgets.dll',
    'MSVCP140.dll',
    'VCRUNTIME140.dll',
    'VCRUNTIME140_1.dll',
    'vc_redist.x64.exe',
    'platforms\qwindows.dll'
)
foreach ($relativePath in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $releasePath $relativePath) -PathType Leaf)) {
        throw "Required runtime file is missing: $relativePath"
    }
}

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
Remove-Item -LiteralPath $stagingPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $installerPackagePath -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $stagingPath | Out-Null

$runtimeNames = @(
    "$applicationName.exe", 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Svg.dll', 'Qt5Widgets.dll',
    'D3Dcompiler_47.dll', 'icudt58.dll', 'icuin58.dll', 'icuuc58.dll', 'libEGL.dll',
    'libGLESV2.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll',
    'opengl32sw.dll', 'vc_redist.x64.exe'
)
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
Copy-Item -LiteralPath $ReadmePath -Destination $stagingPath -Force
$packageFiles.Add('Create-DesktopShortcut.ps1')
$packageFiles.Add('README.md')

Assert-SafePackageText $stagingPath

Compress-Archive -LiteralPath $stagingPath -DestinationPath $zipPath -CompressionLevel Optimal -Force
if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) {
    throw 'ZIP package creation failed.'
}
Assert-SafeArchive $zipPath (@($packageFiles | ForEach-Object { "$packageName\$_" }) + $packageName)

$installerWorkPath = Join-Path $outputPath ($packageName + '-installer-work')
New-Item -ItemType Directory -Force -Path $installerWorkPath | Out-Null
Copy-Item -LiteralPath $zipPath -Destination (Join-Path $installerWorkPath 'Payload.zip') -Force
Copy-Item -LiteralPath (Join-Path $scriptRoot 'Install-Calculator.ps1') -Destination $installerWorkPath -Force
Copy-Item -LiteralPath (Join-Path $scriptRoot 'Install-Calculator.cmd') -Destination $installerWorkPath -Force
Compress-Archive -Path (Join-Path $installerWorkPath '*') -DestinationPath $installerPackagePath -CompressionLevel Optimal -Force
Remove-Item -LiteralPath $installerWorkPath -Recurse -Force

if (-not (Test-Path -LiteralPath $installerPackagePath -PathType Leaf)) {
    throw 'Installer package creation failed.'
}
Assert-SafeArchive $installerPackagePath @('Payload.zip', 'Install-Calculator.ps1', 'Install-Calculator.cmd')

Get-ChildItem -LiteralPath $outputPath -File | Where-Object { $_.Name -like "$packageName*" } |
    Select-Object Name, Length, LastWriteTime
