[CmdletBinding()]
param(
    [string]$InstallDirectory,
    [string]$ShortcutName = 'WangChenyangCalculator.lnk'
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($InstallDirectory)) {
    $InstallDirectory = $scriptRoot
}
$applicationName = 'WangChenyangCalculator'
$targetPath = Join-Path $InstallDirectory ($applicationName + '.exe')

if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
    throw "Application executable was not found: $targetPath"
}

$desktopDirectory = [Environment]::GetFolderPath('Desktop')
if ([string]::IsNullOrWhiteSpace($desktopDirectory)) {
    throw 'The current user desktop directory is unavailable.'
}

if ([IO.Path]::GetFileName($ShortcutName) -ne $ShortcutName) {
    throw 'ShortcutName must be a file name without a directory path.'
}
$shortcutPath = Join-Path $desktopDirectory $ShortcutName
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $InstallDirectory
$shortcut.IconLocation = "$targetPath,0"
$shortcut.Description = 'Wang Chenyang Calculator'
$shortcut.Save()

Write-Output "Desktop shortcut created: $shortcutPath"
