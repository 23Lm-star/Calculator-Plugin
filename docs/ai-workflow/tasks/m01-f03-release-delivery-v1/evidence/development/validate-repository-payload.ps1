[CmdletBinding()]
param(
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..\..')).Path
}
$results = [System.Collections.Generic.List[object]]::new()
function Assert-Result([string]$Name, [bool]$Passed, [string]$Detail) {
    $results.Add([PSCustomObject]@{ Name = $Name; Passed = $Passed; Detail = $Detail })
    if (-not $Passed) { throw "$Name failed: $Detail" }
}

$releaseScripts = Get-ChildItem -LiteralPath (Join-Path $ProjectRoot 'scripts\release') -Filter '*.ps1' -File
foreach ($releaseScript in $releaseScripts) {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($releaseScript.FullName, [ref]$tokens, [ref]$errors)
    Assert-Result "AST $($releaseScript.Name)" ($errors.Count -eq 0) ("errors: " + $errors.Count)
}

$payloadPath = Join-Path $ProjectRoot 'release\Payload.zip'
Assert-Result 'Tracked Payload.zip exists' (Test-Path -LiteralPath $payloadPath -PathType Leaf) $payloadPath
Add-Type -AssemblyName System.IO.Compression.FileSystem
$requiredEntries = @(
    'WangChenyangCalculator.exe', 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll',
    'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe',
    'platforms\qwindows.dll', 'Create-DesktopShortcut.ps1', 'README.md'
)
$allowedEntries = @(
    $requiredEntries + @('Qt5Svg.dll', 'D3Dcompiler_47.dll', 'icudt58.dll', 'icuin58.dll',
    'icuuc58.dll', 'libEGL.dll', 'libGLESV2.dll', 'opengl32sw.dll')
)
$archive = [IO.Compression.ZipFile]::OpenRead($payloadPath)
try {
    $root = (($archive.Entries | Where-Object { $_.FullName -match '[\\/]' } | Select-Object -First 1).FullName -split '[\\/]')[0]
    $actualEntries = @($archive.Entries |
        ForEach-Object { $_.FullName.Replace('/', '\\') } |
        Where-Object { $_ -ne $root } |
        ForEach-Object { $_.Substring($root.Length + 1) })
    foreach ($entry in $requiredEntries) {
        Assert-Result "Payload member $entry" ($actualEntries -contains $entry) 'present'
    }
    $unsafeEntries = @($archive.Entries | Where-Object { $_.FullName -match '(?i)(?:^[A-Z]:|^\\\\|^/|\.\.(?:/|\\))' })
    Assert-Result 'Payload paths are relative and traversal-free' ($unsafeEntries.Count -eq 0) ($unsafeEntries -join ', ')
    $unexpectedEntries = @($actualEntries | Where-Object { $_ -notin $allowedEntries })
    Assert-Result 'Payload whitelist' ($unexpectedEntries.Count -eq 0) ($unexpectedEntries -join ', ')
    $textEntries = @($archive.Entries | Where-Object { $_.Name -match '\.(cmd|ini|json|md|ps1|txt|xml|yml|yaml)$' })
    $unsafeText = foreach ($entry in $textEntries) {
        $reader = [IO.StreamReader]::new($entry.Open())
        try { $text = $reader.ReadToEnd() } finally { $reader.Dispose() }
        if ($text -match '(?i)(?:^|[^A-Za-z0-9_])[A-Z]:[\\/]|\\\\[^\\/]+|(?<![A-Za-z0-9_.-])\.\.(?:[\\/]|$)') { $entry.FullName }
    }
    Assert-Result 'Payload text has no absolute, UNC, or traversal path' (@($unsafeText).Count -eq 0) ($unsafeText -join ', ')
}
finally {
    $archive.Dispose()
}

$controlledRoot = Join-Path $env:TEMP ('m01-f03-repository-payload-' + [guid]::NewGuid().ToString('N'))
$shortcutName = 'WangChenyangCalculator-RepositoryPayload-Validation.lnk'
$shortcutPath = Join-Path ([Environment]::GetFolderPath('Desktop')) $shortcutName
try {
    New-Item -ItemType Directory -Force -Path (Join-Path $controlledRoot 'scripts') | Out-Null
    Copy-Item -LiteralPath (Join-Path $ProjectRoot 'scripts\release') -Destination (Join-Path $controlledRoot 'scripts') -Recurse -Force
    New-Item -ItemType Directory -Force -Path (Join-Path $controlledRoot 'release') | Out-Null
    Copy-Item -LiteralPath $payloadPath -Destination (Join-Path $controlledRoot 'release\Payload.zip') -Force
    Assert-Result 'Controlled copy omits build' (-not (Test-Path -LiteralPath (Join-Path $controlledRoot 'build'))) 'build omitted'
    Assert-Result 'Controlled copy omits artifacts/release' (-not (Test-Path -LiteralPath (Join-Path $controlledRoot 'artifacts\release'))) 'artifacts/release omitted'

    $global:M01F03VcInvocation = $null
    function global:Start-Process {
        param([string]$FilePath, [object]$ArgumentList, [switch]$Wait, [switch]$PassThru, [string]$WorkingDirectory)
        $global:M01F03VcInvocation = [PSCustomObject]@{ FilePath = $FilePath; ArgumentList = @($ArgumentList); Wait = $Wait.IsPresent; PassThru = $PassThru.IsPresent }
        return [PSCustomObject]@{ ExitCode = 0 }
    }
    $installDirectory = Join-Path $controlledRoot 'installed-app'
    & (Join-Path $controlledRoot 'scripts\release\Install-Calculator.ps1') -InstallDirectory $installDirectory -ShortcutName $shortcutName -NoLaunch
    Assert-Result 'Installer copied executable' (Test-Path -LiteralPath (Join-Path $installDirectory 'WangChenyangCalculator.exe') -PathType Leaf) 'EXE copied'
    Assert-Result 'Installer copied qwindows.dll' (Test-Path -LiteralPath (Join-Path $installDirectory 'platforms\qwindows.dll') -PathType Leaf) 'platform plugin copied'
    Assert-Result 'Installer invoked shortcut script' (Test-Path -LiteralPath $shortcutPath -PathType Leaf) $shortcutPath
    $argumentsMatch = ((@($global:M01F03VcInvocation.ArgumentList) -join ' ') -eq '/install /quiet /norestart')
    Assert-Result 'Installer invoked VC Redist with expected arguments' ($global:M01F03VcInvocation.FilePath -eq (Join-Path $installDirectory 'vc_redist.x64.exe') -and $argumentsMatch -and $global:M01F03VcInvocation.Wait -and $global:M01F03VcInvocation.PassThru) ($global:M01F03VcInvocation | ConvertTo-Json -Compress)
    Assert-Result 'NoLaunch suppressed application launch' ($global:M01F03VcInvocation.FilePath -like '*vc_redist.x64.exe') 'only VC Redist Start-Process call observed'
}
finally {
    Remove-Item -LiteralPath Function:\global:Start-Process -ErrorAction SilentlyContinue
    Remove-Variable -Name M01F03VcInvocation -Scope Global -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $shortcutPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $controlledRoot -Recurse -Force -ErrorAction SilentlyContinue
}

$results | ConvertTo-Json -Depth 3
