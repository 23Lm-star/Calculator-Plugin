# Repository Payload Validation | 2026-08-08

## Payload

| Item | Value |
|---|---|
| Path | `release/Payload.zip` |
| Size | `56,029,144` bytes |
| SHA-256 | `87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101` |
| Git ignore result | Not ignored; no `.gitignore` exception was required. |

## Commands and results

| Command | Exit code | Result |
|---|---:|---|
| `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\release\Package-Release.ps1 -Version 1.1.0` | 0 | Rebuilt the tracked `release/Payload.zip` from the relative Release input. |
| `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\docs\ai-workflow\tasks\m01-f03-release-delivery-v1\evidence\development\validate-repository-payload.ps1` | 0 | Parsed release scripts; verified payload, source-copy installer flow, shortcut call, VC arguments, and `-NoLaunch`. |

## Assertions passed

- AST parsing: `Create-DesktopShortcut.ps1`, `Install-Calculator.ps1`, and `Package-Release.ps1` each had zero errors.
- Payload includes EXE, `Qt5Core.dll`, `Qt5Gui.dll`, `Qt5Widgets.dll`, `platforms/qwindows.dll`, `MSVCP140.dll`, `VCRUNTIME140.dll`, `VCRUNTIME140_1.dll`, `vc_redist.x64.exe`, `Create-DesktopShortcut.ps1`, and `README.md`.
- Payload ZIP entries are relative, contain no `..`, and match the explicit runtime whitelist. Text entries contain no absolute or UNC path.
- A controlled copy containing only `scripts/release` and `release/Payload.zip` had no `build` or `artifacts/release` directory. Its installer located the payload, extracted and copied the application, created the desktop shortcut, and completed with `-NoLaunch`.
- The validation replaced `Start-Process` only inside the test process. It observed `vc_redist.x64.exe /install /quiet /norestart` with `-Wait -PassThru`; the actual VC runtime installer was not executed.
