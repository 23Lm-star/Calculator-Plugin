[CmdletBinding()]
param(
    [string]$InstallDirectory,
    [string]$ShortcutName = 'WangChenyangCalculator.lnk',
    [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($InstallDirectory)) {
    $InstallDirectory = Join-Path $env:LOCALAPPDATA 'Programs\WangChenyangCalculator'
}
$payloadPath = Join-Path $scriptRoot 'Payload.zip'

if (-not (Test-Path -LiteralPath $payloadPath -PathType Leaf)) {
    throw "Installer payload was not found: $payloadPath"
}

$temporaryDirectory = Join-Path $env:TEMP ('WangChenyangCalculator-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $temporaryDirectory | Out-Null

try {
    Expand-Archive -LiteralPath $payloadPath -DestinationPath $temporaryDirectory -Force
    $packageRoot = Get-ChildItem -LiteralPath $temporaryDirectory -Directory | Select-Object -First 1
    if ($null -eq $packageRoot) {
        throw 'The installer payload does not contain a package directory.'
    }

    New-Item -ItemType Directory -Force -Path $InstallDirectory | Out-Null
    Copy-Item -Path (Join-Path $packageRoot.FullName '*') -Destination $InstallDirectory -Recurse -Force

    $shortcutScript = Join-Path $InstallDirectory 'Create-DesktopShortcut.ps1'
    & $shortcutScript -InstallDirectory $InstallDirectory -ShortcutName $ShortcutName

    $applicationPath = Join-Path $InstallDirectory 'WangChenyangCalculator.exe'
    if (-not (Test-Path -LiteralPath $applicationPath -PathType Leaf)) {
        throw "Installed executable was not found: $applicationPath"
    }

    $vcRedistPath = Join-Path $InstallDirectory 'vc_redist.x64.exe'
    if (-not (Test-Path -LiteralPath $vcRedistPath -PathType Leaf)) {
        throw "Microsoft Visual C++ x64 runtime installer was not found: $vcRedistPath"
    }

    $vcRedistProcess = Start-Process -FilePath $vcRedistPath -ArgumentList @('/install', '/quiet', '/norestart') -Wait -PassThru
    if ($vcRedistProcess.ExitCode -notin 0, 3010) {
        throw "Microsoft Visual C++ x64 runtime installation failed with exit code $($vcRedistProcess.ExitCode). Run this file manually: $vcRedistPath"
    }
    if ($vcRedistProcess.ExitCode -eq 3010) {
        Write-Output 'Microsoft Visual C++ x64 runtime installation completed; restart is required.'
    }

    Write-Output "Installed to: $InstallDirectory"
    if (-not $NoLaunch) {
        Start-Process -FilePath $applicationPath -WorkingDirectory $InstallDirectory
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryDirectory) {
        Remove-Item -LiteralPath $temporaryDirectory -Recurse -Force
    }
}
