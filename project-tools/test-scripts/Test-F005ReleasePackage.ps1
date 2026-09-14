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

$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('F005-Package-' + [guid]::NewGuid().ToString('N'))
$payloadPath = Join-Path $testRoot 'Payload.zip'
$extractPath = Join-Path $testRoot 'isolated'
$version = '1.1.0-f005.20260914'
$packageScript = Join-Path $projectRoot 'scripts\release\Package-Release.ps1'
$readmePath = Join-Path $projectRoot 'release\README.md'
$process = $null
$expectedHashes = @{
    'MSVCP140.dll' = '0F885B509A685D2BBFA652FED26B5FB31D88FBDAB0A978C641D1C7B8AA460AA9'
    'VCRUNTIME140.dll' = 'D5E4D9A3E835FA679450145D6A7D94E36573A509317111904D9B3712C30D9066'
    'VCRUNTIME140_1.dll' = '1F2D41C4AA5DB0BC33EBF7B66D72943A817D7CE6CBE880502A9403823633093F'
}

try {
    New-Item -ItemType Directory -Force -Path $testRoot | Out-Null
    & $packageScript -ReleaseDirectory $ReleaseDirectory -Version $version -PayloadPath $payloadPath -ReadmePath $readmePath
    if (-not (Test-Path -LiteralPath $payloadPath -PathType Leaf)) {
        throw 'Payload ZIP was not created.'
    }

    Expand-Archive -LiteralPath $payloadPath -DestinationPath $extractPath -Force
    $packagePath = Join-Path $extractPath "WangChenyangCalculator-$version"
    if (-not (Test-Path -LiteralPath $packagePath -PathType Container)) {
        throw "Extracted package directory is missing: $packagePath"
    }

    Write-Output 'PAYLOAD_MANIFEST_START'
    Get-ChildItem -LiteralPath $packagePath -File -Recurse |
        ForEach-Object { $_.FullName.Substring($packagePath.Length).TrimStart('\').Replace('\', '/') } |
        Sort-Object |
        ForEach-Object { Write-Output $_ }
    Write-Output 'PAYLOAD_MANIFEST_END'

    foreach ($dllName in $expectedHashes.Keys | Sort-Object) {
        $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $packagePath $dllName)).Hash
        if ($actualHash -ne $expectedHashes[$dllName]) {
            throw "CRT hash mismatch for ${dllName}: $actualHash"
        }
        Write-Output "CRT_SHA256 $dllName $actualHash"
    }

    $process = Start-Process -FilePath (Join-Path $packagePath 'WangChenyangCalculator.exe') -PassThru
    Start-Sleep -Seconds 3
    if ($process.HasExited) {
        throw "Isolated package executable exited early with code $($process.ExitCode)."
    }
    Stop-Process -Id $process.Id -Force
    if (-not $process.WaitForExit(10000)) {
        throw "Isolated package executable did not exit after termination."
    }
    Write-Output 'ISOLATED_PACKAGE_STARTUP: PASS'
    Write-Output 'F005_RELEASE_PACKAGE_REGRESSION: PASS'
}
finally {
    if ($null -ne $process) {
        if (-not $process.HasExited) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            $process.WaitForExit(10000)
        }
        $process.Dispose()
    }
    if (Test-Path -LiteralPath $testRoot) {
        $cleanupComplete = $false
        for ($attempt = 1; $attempt -le 10 -and -not $cleanupComplete; $attempt++) {
            try {
                Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction Stop
                $cleanupComplete = $true
            }
            catch {
                if ($attempt -lt 10) {
                    Start-Sleep -Milliseconds 500
                }
                else {
                    throw
                }
            }
        }
    }
}
