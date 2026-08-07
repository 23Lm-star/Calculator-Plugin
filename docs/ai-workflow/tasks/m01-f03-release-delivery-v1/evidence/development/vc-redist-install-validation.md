# Development Evidence | VC Runtime Installation

Date: 2026-08-07

## Commands and results

| Check | Result | Evidence |
| --- | --- | --- |
| PowerShell parser | Pass | `Install-Calculator.ps1` and `Package-Release.ps1` were parsed with `System.Management.Automation.Language.Parser`; no parser errors. |
| Package generation | Pass | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\release\Package-Release.ps1 -Version 1.1.0 -OutputDirectory <task-evidence-temp>` returned exit code `0`. |
| Portable runtime contents | Pass | ZIP contains `Qt5Core.dll`, `Qt5Gui.dll`, `Qt5Widgets.dll`, `platforms/qwindows.dll`, `MSVCP140.dll`, `VCRUNTIME140.dll`, `VCRUNTIME140_1.dll`, and `vc_redist.x64.exe`. |
| ZIP absolute-path scan | Pass | All packaged `.ps1`, `.cmd`, and `.md` entries were scanned; no `E:\qt\project1` text was found. |
| VC runtime exit `0` | Pass | A process-level `Start-Process` double returned `0`; installer copied the payload, created a desktop shortcut, used `/install /quiet /norestart`, and launched the installed application. |
| VC runtime exit `3010` | Pass | The process-level double returned `3010`; `-NoLaunch` was retained, installation succeeded, and the output reported that restart is required. |
| VC runtime exit `1603` | Pass | The process-level double returned `1603`; installation terminated with `exit code 1603` and the deployed `vc_redist.x64.exe` manual-execution path. |

## Generated package hashes

- Portable ZIP SHA-256: `7BA94ED91BA2F5497DB2CA63AB7ADD5463384609CF474BF9239D19BCD02C1FAD`
- Installer ZIP SHA-256: `9AAA1C8A6DB5FC0A493E37D213AFD7152FF1FD0FBF35F0C123616E919A5BCE20`

## Validation boundary

The three VC installer outcomes were simulated by a process-local `Start-Process` double. The real `vc_redist.x64.exe` was not run, so development validation did not modify the machine's installed VC runtime. Test shortcuts and temporary package/install directories are removed after validation.
