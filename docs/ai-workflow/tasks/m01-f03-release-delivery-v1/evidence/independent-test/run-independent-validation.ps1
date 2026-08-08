[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..\..')).Path
$runRoot = Join-Path $PSScriptRoot 'run-20260808-contract'
$packageOutput = Join-Path $runRoot 'packages'
$results = [System.Collections.Generic.List[object]]::new()
$logLines = [System.Collections.Generic.List[string]]::new()

function Add-Result([string]$Name, [bool]$Passed, [string]$Detail) {
    $results.Add([pscustomobject]@{ Name = $Name; Passed = $Passed; Detail = $Detail })
    $logLines.Add(('ASSERT {0}: {1} - {2}' -f $Name, $(if ($Passed) { 'PASS' } else { 'FAIL' }), $Detail))
    if (-not $Passed) { throw "Assertion failed: $Name. $Detail" }
}

function Test-Parse([string]$Path) {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    Add-Result "Parser $([IO.Path]::GetFileName($Path))" ($errors.Count -eq 0) "parse errors: $($errors.Count)"
}

function Get-ZipEntries([string]$Path) {
    $archive = [IO.Compression.ZipFile]::OpenRead($Path)
    try { return @($archive.Entries | ForEach-Object { $_.FullName }) }
    finally { $archive.Dispose() }
}

function Test-SafeArchiveEntries([string[]]$Entries) {
    return @($Entries | Where-Object {
        $_ -match '(?i)(?:^|[^A-Za-z0-9_])[A-Z]:[\\/]' -or
        $_ -match '(?i)(?:^|[^A-Za-z0-9_])\\\\\?\\(?:[A-Z]:|UNC\\)' -or
        $_ -match '(?i)(?:^|[^A-Za-z0-9_])\\\\[^\\/]+' -or
        $_ -match '(?<![A-Za-z0-9_.-])\.\.(?:[\\/]|$)'
    }).Count -eq 0
}

function Invoke-VcBranch([string]$ControlledRoot, [int]$ExitCode, [switch]$NoLaunch) {
    $caseRoot = Join-Path $runRoot ("install-$ExitCode" + $(if ($NoLaunch) { '-no-launch' } else { '' }))
    $installDirectory = Join-Path $caseRoot 'installed-app'
    $shortcutName = "M01F03-$ExitCode.lnk"
    $global:M01F03StartedProcesses = [System.Collections.Generic.List[object]]::new()
    $global:M01F03Shortcuts = [System.Collections.Generic.List[string]]::new()
    $global:M01F03ExitCode = $ExitCode
    function global:Start-Process {
        param([string]$FilePath, [object[]]$ArgumentList, [switch]$Wait, [switch]$PassThru, [string]$WorkingDirectory)
        $global:M01F03StartedProcesses.Add([pscustomobject]@{ FilePath = $FilePath; ArgumentList = @($ArgumentList); Wait = [bool]$Wait; PassThru = [bool]$PassThru; WorkingDirectory = $WorkingDirectory })
        return [pscustomobject]@{ ExitCode = $global:M01F03ExitCode }
    }
    function global:New-Object {
        param([string]$TypeName, [string]$ComObject, [object[]]$ArgumentList)
        if ($ComObject -ne 'WScript.Shell') { return Microsoft.PowerShell.Utility\New-Object @PSBoundParameters }
        $shell = [pscustomobject]@{}
        $shell | Add-Member -MemberType ScriptMethod -Name CreateShortcut -Value {
            param([string]$Path)
            $shortcut = [pscustomobject]@{ Path = $Path; TargetPath = ''; WorkingDirectory = ''; IconLocation = ''; Description = '' }
            $shortcut | Add-Member -MemberType ScriptMethod -Name Save -Value { $global:M01F03Shortcuts.Add($this.Path) }
            return $shortcut
        }
        return $shell
    }
    $output = $null
    $failure = $null
    try { $output = & (Join-Path $ControlledRoot 'scripts\release\Install-Calculator.ps1') -InstallDirectory $installDirectory -ShortcutName $shortcutName -NoLaunch:$NoLaunch 2>&1 } catch { $failure = $_ }
    $vcCalls = @($global:M01F03StartedProcesses | Where-Object { $_.FilePath -like '*vc_redist.x64.exe' })
    Add-Result "VC $ExitCode invocation count" ($vcCalls.Count -eq 1) "calls: $($vcCalls.Count)"
    if ($vcCalls.Count -eq 1) {
        Add-Result "VC $ExitCode arguments" ((@($vcCalls[0].ArgumentList) -join ' ') -eq '/install /quiet /norestart') "arguments: $(@($vcCalls[0].ArgumentList -join ' '))"
        Add-Result "VC $ExitCode wait/pass-through" ($vcCalls[0].Wait -and $vcCalls[0].PassThru) "Wait=$($vcCalls[0].Wait); PassThru=$($vcCalls[0].PassThru)"
    }
    Add-Result "VC $ExitCode copied executable" (Test-Path -LiteralPath (Join-Path $installDirectory 'WangChenyangCalculator.exe') -PathType Leaf) $installDirectory
    Add-Result "VC $ExitCode copied runtime" (Test-Path -LiteralPath (Join-Path $installDirectory 'vc_redist.x64.exe') -PathType Leaf) $installDirectory
    $desktopPath = Join-Path ([Environment]::GetFolderPath('Desktop')) $shortcutName
    Add-Result "VC $ExitCode shortcut created" ($global:M01F03Shortcuts -contains $desktopPath) $desktopPath
    if ($NoLaunch) { Add-Result "VC $ExitCode NoLaunch suppresses application" (@($global:M01F03StartedProcesses | Where-Object { $_.FilePath -like '*WangChenyangCalculator.exe' }).Count -eq 0) 'application Start-Process calls: 0' }
    if ($ExitCode -in 0, 3010) {
        Add-Result "VC $ExitCode succeeds" ($null -eq $failure) $(if ($failure) { $failure.Exception.Message } else { 'no terminating error' })
        if ($ExitCode -eq 3010) { Add-Result 'VC 3010 restart message' (($output | Out-String) -match 'restart is required') ($output | Out-String).Trim() }
    }
    else {
        $message = if ($failure) { $failure.Exception.Message } else { '' }
        Add-Result "VC $ExitCode fails" ($null -ne $failure) $message
        Add-Result "VC $ExitCode failure message" ($message -match "exit code $ExitCode" -and $message -match [regex]::Escape((Join-Path $installDirectory 'vc_redist.x64.exe'))) $message
    }
    Remove-Item -LiteralPath 'function:global:Start-Process' -Force
    Remove-Item -LiteralPath 'function:global:New-Object' -Force
    Remove-Variable -Name M01F03StartedProcesses, M01F03Shortcuts, M01F03ExitCode -Scope Global -ErrorAction SilentlyContinue
}

try {
    Remove-Item -LiteralPath $runRoot -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $packageOutput | Out-Null
    $installScript = Join-Path $projectRoot 'scripts\release\Install-Calculator.ps1'
    $packageScript = Join-Path $projectRoot 'scripts\release\Package-Release.ps1'
    $shortcutScript = Join-Path $projectRoot 'scripts\release\Create-DesktopShortcut.ps1'
    Test-Parse $installScript; Test-Parse $packageScript; Test-Parse $shortcutScript

    & $packageScript -Version '1.1.0-independent' -OutputDirectory $packageOutput
    $rebuiltPayload = Join-Path $packageOutput 'Payload.zip'
    Add-Result 'OutputDirectory payload exists' (Test-Path -LiteralPath $rebuiltPayload -PathType Leaf) $rebuiltPayload
    $entries = Get-ZipEntries $rebuiltPayload
    Add-Result 'Payload entries are safe' (Test-SafeArchiveEntries $entries) 'no absolute, UNC, extended, or traversal entries'
    foreach ($required in @('Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll', 'platforms/qwindows.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe', 'Create-DesktopShortcut.ps1', 'README.md')) {
        $suffix = $required -replace '[\\/]', '[\\/]'
        Add-Result "Payload member $required" (@($entries | Where-Object { $_ -match "[\\/]$suffix$" }).Count -eq 1) 'present'
    }

    $fixtureRelease = Join-Path $runRoot 'fixture-release'
    $fixtureOutput = Join-Path $runRoot 'fixture-output'
    New-Item -ItemType Directory -Force -Path $fixtureRelease, (Join-Path $fixtureRelease 'platforms'), (Join-Path $fixtureRelease 'translations') | Out-Null
    foreach ($fixtureFile in @('WangChenyangCalculator.exe', 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe', 'platforms\qwindows.dll')) { New-Item -ItemType File -Force -Path (Join-Path $fixtureRelease $fixtureFile) | Out-Null }
    Set-Content -LiteralPath (Join-Path $fixtureRelease 'platforms\unexpected.dll') -Value 'unexpected' -Encoding ascii
    Set-Content -LiteralPath (Join-Path $fixtureRelease 'translations\private.txt') -Value 'private' -Encoding ascii
    & $packageScript -ReleaseDirectory $fixtureRelease -Version '1.1.0-whitelist' -OutputDirectory $fixtureOutput
    $fixtureEntries = Get-ZipEntries (Join-Path $fixtureOutput 'Payload.zip')
    Add-Result 'Unapproved plugin is excluded' (@($fixtureEntries | Where-Object { $_ -match 'unexpected\.dll$' }).Count -eq 0) 'platforms/unexpected.dll'
    Add-Result 'Unapproved translation is excluded' (@($fixtureEntries | Where-Object { $_ -match 'private\.txt$' }).Count -eq 0) 'translations/private.txt'
    foreach ($unsafePath in @('C:\\temp\\secret', '\\\\server\\share', '..\\escape')) {
        $unsafeReadme = Join-Path $runRoot ("unsafe-" + [guid]::NewGuid().ToString('N') + '.md')
        Set-Content -LiteralPath $unsafeReadme -Value $unsafePath -Encoding utf8
        $failure = $null
        try { & $packageScript -ReleaseDirectory $fixtureRelease -Version '1.1.0-reject' -OutputDirectory (Join-Path $runRoot ([guid]::NewGuid().ToString('N'))) -ReadmePath $unsafeReadme } catch { $failure = $_ }
        Add-Result "Unsafe text rejected $unsafePath" ($null -ne $failure -and $failure.Exception.Message -match 'Unsafe path') $(if ($failure) { $failure.Exception.Message } else { 'package unexpectedly succeeded' })
    }

    $controlledRoot = Join-Path $runRoot 'controlled-repository'
    New-Item -ItemType Directory -Force -Path (Join-Path $controlledRoot 'scripts'), (Join-Path $controlledRoot 'release') | Out-Null
    Copy-Item -LiteralPath (Join-Path $projectRoot 'scripts\release') -Destination (Join-Path $controlledRoot 'scripts') -Recurse -Force
    Copy-Item -LiteralPath (Join-Path $projectRoot 'release\Payload.zip') -Destination (Join-Path $controlledRoot 'release\Payload.zip') -Force
    Add-Result 'Controlled copy omits build' (-not (Test-Path -LiteralPath (Join-Path $controlledRoot 'build'))) 'build omitted'
    Add-Result 'Controlled copy omits artifacts/release' (-not (Test-Path -LiteralPath (Join-Path $controlledRoot 'artifacts\release'))) 'artifacts/release omitted'
    Invoke-VcBranch -ControlledRoot $controlledRoot -ExitCode 0 -NoLaunch
    Invoke-VcBranch -ControlledRoot $controlledRoot -ExitCode 3010 -NoLaunch
    Invoke-VcBranch -ControlledRoot $controlledRoot -ExitCode 1603 -NoLaunch
    $logLines.Add('RESULT PASS')
}
catch {
    $logLines.Add("RESULT FAIL: $($_.Exception.Message)")
    throw
}
finally {
    $logLines | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'independent-validation.log') -Encoding utf8
    $results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'independent-validation-results.json') -Encoding utf8
    Remove-Item -LiteralPath $runRoot -Recurse -Force -ErrorAction SilentlyContinue
}
