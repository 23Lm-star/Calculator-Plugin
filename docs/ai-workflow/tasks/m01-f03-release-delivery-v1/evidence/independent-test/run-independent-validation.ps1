[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..\..')).Path
$taskDirectory = Split-Path -Parent $PSScriptRoot
$runRoot = Join-Path $PSScriptRoot 'run-20260807'
$packageOutput = Join-Path $runRoot 'packages'
$portableExtract = Join-Path $runRoot 'portable'
$installerExtract = Join-Path $runRoot 'installer'
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

function Invoke-VcBranch([int]$ExitCode, [switch]$NoLaunch) {
    $caseRoot = Join-Path $runRoot ("install-$ExitCode" + $(if ($NoLaunch) { '-no-launch' } else { '' }))
    $installDirectory = Join-Path $caseRoot 'installed-app'
    $shortcutName = "M01F03-$ExitCode.lnk"
    $global:M01F03StartedProcesses = [System.Collections.Generic.List[object]]::new()
    $global:M01F03Shortcuts = [System.Collections.Generic.List[string]]::new()
    $global:M01F03ExitCode = $ExitCode
    function global:Start-Process {
        param(
            [string]$FilePath,
            [object[]]$ArgumentList,
            [switch]$Wait,
            [switch]$PassThru,
            [string]$WorkingDirectory
        )
        $global:M01F03StartedProcesses.Add([pscustomobject]@{
            FilePath = $FilePath
            ArgumentList = @($ArgumentList)
            Wait = [bool]$Wait
            WorkingDirectory = $WorkingDirectory
        })
        return [pscustomobject]@{ ExitCode = $global:M01F03ExitCode }
    }
    function global:New-Object {
        param([string]$TypeName, [string]$ComObject, [object[]]$ArgumentList)
        if ($ComObject -ne 'WScript.Shell') {
            return Microsoft.PowerShell.Utility\New-Object @PSBoundParameters
        }
        $shell = [pscustomobject]@{}
        $shell | Add-Member -MemberType ScriptMethod -Name CreateShortcut -Value {
            param([string]$Path)
            $shortcut = [pscustomobject]@{ Path = $Path; TargetPath = ''; WorkingDirectory = ''; IconLocation = ''; Description = '' }
            $shortcut | Add-Member -MemberType ScriptMethod -Name Save -Value {
                $global:M01F03Shortcuts.Add($this.Path)
            }
            return $shortcut
        }
        return $shell
    }

    $output = $null
    $failure = $null
    try {
        $output = & (Join-Path $installerExtract 'Install-Calculator.ps1') -InstallDirectory $installDirectory -ShortcutName $shortcutName -NoLaunch:$NoLaunch 2>&1
    } catch {
        $failure = $_
    }
    $vcCalls = @($global:M01F03StartedProcesses | Where-Object { $_.FilePath -like '*vc_redist.x64.exe' })
    if ($ExitCode -in 0, 3010) {
        Add-Result "VC $ExitCode installer reached runtime step" ($null -eq $failure) $(if ($failure) { $failure.Exception.Message } else { 'no pre-runtime error' })
    }
    Add-Result "VC $ExitCode invocation count" ($vcCalls.Count -eq 1) "calls: $($vcCalls.Count)"
    if ($vcCalls.Count -eq 1) {
        Add-Result "VC $ExitCode arguments" ((@($vcCalls[0].ArgumentList) -join ' ') -eq '/install /quiet /norestart') "arguments: $(@($vcCalls[0].ArgumentList -join ' '))"
        Add-Result "VC $ExitCode wait" $vcCalls[0].Wait "Wait=$($vcCalls[0].Wait)"
    }
    Add-Result "VC $ExitCode copied executable" (Test-Path -LiteralPath (Join-Path $installDirectory 'WangChenyangCalculator.exe') -PathType Leaf) $installDirectory
    $desktopPath = Join-Path ([Environment]::GetFolderPath('Desktop')) $shortcutName
    Add-Result "VC $ExitCode shortcut created" ($global:M01F03Shortcuts -contains $desktopPath) $desktopPath
    if ($NoLaunch) {
        $applicationCalls = @($global:M01F03StartedProcesses | Where-Object { $_.FilePath -like '*WangChenyangCalculator.exe' })
        Add-Result "VC $ExitCode NoLaunch suppresses application" ($applicationCalls.Count -eq 0) "application Start-Process calls: $($applicationCalls.Count)"
    }

    if ($ExitCode -in 0, 3010) {
        Add-Result "VC $ExitCode succeeds" ($null -eq $failure) $(if ($failure) { $failure.Exception.Message } else { 'no terminating error' })
        if ($ExitCode -eq 3010) {
            Add-Result 'VC 3010 restart message' (($output | Out-String) -match 'restart is required') ($output | Out-String).Trim()
        }
    } else {
        $message = if ($failure) { $failure.Exception.Message } else { '' }
        Add-Result "VC $ExitCode fails" ($null -ne $failure) $message
        Add-Result "VC $ExitCode failure message" ($message -match "exit code $ExitCode" -and $message -match [regex]::Escape((Join-Path $installDirectory 'vc_redist.x64.exe'))) $message
    }
    if (Test-Path -LiteralPath $desktopPath) { Remove-Item -LiteralPath $desktopPath -Force }
    Remove-Item -LiteralPath 'function:global:Start-Process' -Force
    Remove-Item -LiteralPath 'function:global:New-Object' -Force
    Remove-Variable -Name M01F03StartedProcesses, M01F03Shortcuts, M01F03ExitCode -Scope Global -ErrorAction SilentlyContinue
}

try {
    Remove-Item -LiteralPath $runRoot -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $packageOutput, $portableExtract, $installerExtract | Out-Null

    $installScript = Join-Path $projectRoot 'scripts\release\Install-Calculator.ps1'
    $packageScript = Join-Path $projectRoot 'scripts\release\Package-Release.ps1'
    $shortcutScript = Join-Path $projectRoot 'scripts\release\Create-DesktopShortcut.ps1'
    Test-Parse $installScript
    Test-Parse $packageScript
    Test-Parse $shortcutScript

    & $packageScript -Version '1.1.0-independent' -OutputDirectory $packageOutput
    Add-Result 'Package script completed' $true 'completed without a terminating error'
    $portableZip = Join-Path $packageOutput 'WangChenyangCalculator-1.1.0-independent.zip'
    $installerZip = Join-Path $packageOutput 'WangChenyangCalculator-1.1.0-independent-Installer.zip'
    Add-Result 'Portable ZIP exists' (Test-Path -LiteralPath $portableZip -PathType Leaf) $portableZip
    Add-Result 'Installer ZIP exists' (Test-Path -LiteralPath $installerZip -PathType Leaf) $installerZip

    $portableEntries = Get-ZipEntries $portableZip
    Add-Result 'Portable ZIP entries are safe' (Test-SafeArchiveEntries $portableEntries) 'no absolute, UNC, extended, or traversal entries'
    foreach ($required in @('Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll', 'platforms/qwindows.dll', 'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe')) {
        $entrySuffix = $required -replace '[\\/]', '[\\/]'
        Add-Result "Portable ZIP member $required" (@($portableEntries | Where-Object { $_ -match "[\\/]$entrySuffix$" }).Count -eq 1) 'present'
    }
    Expand-Archive -LiteralPath $portableZip -DestinationPath $portableExtract -Force
    $portableRoot = Get-ChildItem -LiteralPath $portableExtract -Directory | Select-Object -First 1
    $leaks = @()
    Get-ChildItem -LiteralPath $portableRoot.FullName -File -Recurse | Where-Object { $_.Extension -in '.ps1', '.cmd', '.ini', '.json', '.md', '.txt', '.xml', '.yml', '.yaml' } | ForEach-Object {
        if ((Get-Content -LiteralPath $_.FullName -Raw) -match '(?i)(?:^|[^A-Za-z0-9_])[A-Z]:[\\/]|(?:^|[^A-Za-z0-9_])\\\\\?\\(?:[A-Z]:|UNC\\)|(?:^|[^A-Za-z0-9_])\\\\[^\\/]+|(?<![A-Za-z0-9_.-])\.\.(?:[\\/]|$)') { $leaks += $_.FullName }
    }
    Add-Result 'Portable text has no unsafe path' ($leaks.Count -eq 0) $(if ($leaks.Count) { $leaks -join ', ' } else { 'none' })

    $fixtureRelease = Join-Path $runRoot 'fixture-release'
    $fixtureOutput = Join-Path $runRoot 'fixture-packages'
    New-Item -ItemType Directory -Force -Path $fixtureRelease, (Join-Path $fixtureRelease 'platforms'), (Join-Path $fixtureRelease 'translations') | Out-Null
    foreach ($requiredFixtureFile in @(
        'WangChenyangCalculator.exe', 'Qt5Core.dll', 'Qt5Gui.dll', 'Qt5Widgets.dll',
        'MSVCP140.dll', 'VCRUNTIME140.dll', 'VCRUNTIME140_1.dll', 'vc_redist.x64.exe',
        'platforms\qwindows.dll'
    )) {
        New-Item -ItemType File -Force -Path (Join-Path $fixtureRelease $requiredFixtureFile) | Out-Null
    }
    New-Item -ItemType Directory -Force -Path (Join-Path $fixtureRelease 'platforms'), (Join-Path $fixtureRelease 'translations') | Out-Null
    Set-Content -LiteralPath (Join-Path $fixtureRelease 'platforms\unexpected.dll') -Value 'unexpected' -Encoding ascii
    Set-Content -LiteralPath (Join-Path $fixtureRelease 'translations\private.txt') -Value 'private' -Encoding ascii
    & $packageScript -ReleaseDirectory $fixtureRelease -Version '1.1.0-whitelist' -OutputDirectory $fixtureOutput
    $fixtureEntries = Get-ZipEntries (Join-Path $fixtureOutput 'WangChenyangCalculator-1.1.0-whitelist.zip')
    Add-Result 'Unapproved plugin is excluded' (@($fixtureEntries | Where-Object { $_ -match 'unexpected\.dll$' }).Count -eq 0) 'platforms/unexpected.dll'
    Add-Result 'Unapproved translation is excluded' (@($fixtureEntries | Where-Object { $_ -match 'private\.txt$' }).Count -eq 0) 'translations/private.txt'
    foreach ($unsafePath in @('C:\\temp\\secret', '\\\\server\\share', '..\\escape')) {
        $unsafeReadme = Join-Path $runRoot ("unsafe-" + [guid]::NewGuid().ToString('N') + '.md')
        Set-Content -LiteralPath $unsafeReadme -Value $unsafePath -Encoding utf8
        $failure = $null
        try { & $packageScript -ReleaseDirectory $fixtureRelease -Version '1.1.0-reject' -OutputDirectory (Join-Path $runRoot ([guid]::NewGuid().ToString('N'))) -ReadmePath $unsafeReadme } catch { $failure = $_ }
        Add-Result "Unsafe text rejected $unsafePath" ($null -ne $failure -and $failure.Exception.Message -match 'Unsafe path') $(if ($failure) { $failure.Exception.Message } else { 'package unexpectedly succeeded' })
    }

    Expand-Archive -LiteralPath $installerZip -DestinationPath $installerExtract -Force
    Invoke-VcBranch -ExitCode 0
    Invoke-VcBranch -ExitCode 3010 -NoLaunch
    Invoke-VcBranch -ExitCode 1603 -NoLaunch

    $applicationPath = Join-Path $portableRoot.FullName 'WangChenyangCalculator.exe'
    $processInfo = [Diagnostics.ProcessStartInfo]::new($applicationPath)
    $processInfo.WorkingDirectory = $portableRoot.FullName
    $processInfo.UseShellExecute = $false
    $application = [Diagnostics.Process]::Start($processInfo)
    Start-Sleep -Seconds 3
    Add-Result 'Portable application launch' (-not $application.HasExited) "PID=$($application.Id)"
    if (-not $application.HasExited) { Stop-Process -Id $application.Id -Force }

    $hashes = @(
        Get-FileHash -LiteralPath $portableZip -Algorithm SHA256
        Get-FileHash -LiteralPath $installerZip -Algorithm SHA256
    )
    $logLines.Add("HASH portable $($hashes[0].Hash)")
    $logLines.Add("HASH installer $($hashes[1].Hash)")
    $logLines.Add('RESULT PASS')
} catch {
    $logLines.Add("RESULT FAIL: $($_.Exception.Message)")
    throw
} finally {
    $logLines | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'independent-validation.log') -Encoding utf8
    $results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'independent-validation-results.json') -Encoding utf8
    Remove-Item -LiteralPath $runRoot -Recurse -Force -ErrorAction SilentlyContinue
}
