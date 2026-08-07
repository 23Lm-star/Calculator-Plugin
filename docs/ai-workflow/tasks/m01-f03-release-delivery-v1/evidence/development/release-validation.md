# Development Evidence | M01-F03

Date: 2026-08-07

## Generated artifacts

- `artifacts/release/WangChenyangCalculator-1.1.0.zip` (57,445,397 bytes)
- `artifacts/release/WangChenyangCalculator-1.1.0-Installer.zip` (57,233,629 bytes)
- Portable ZIP SHA-256: `E6A86F36F7913E8B3B532352B9C26D461F281A0F2D93BDF40BA8D8F18C9F7F5A`
- Installer ZIP SHA-256: `56BF1F3DBD5519C514FD625D397550374FE9CAF4CE3A9A0E13D2E3BB594FA148`
- Portable package file count: `50`

## Commands and results

| Check | Result | Evidence |
| --- | --- | --- |
| PowerShell parser validation | Pass | All three scripts under `scripts/release/` parsed without errors. |
| Package generation | Pass | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\release\Package-Release.ps1 -Version 1.1.0` returned exit code 0. |
| ZIP member check | Pass | EXE, Qt DLLs, MSVC CRT, `platforms/qwindows.dll`, README and shortcut script were extracted and present. |
| Absolute-path scan | Pass | Packaged `.ps1`, `.cmd` and `.md` files contain no `E:\qt\project1` string. |
| Installer install flow | Pass | Installer ZIP extracted; `Install-Calculator.ps1 -InstallDirectory artifacts\release\validation\installed-app -ShortcutName WangChenyangCalculator-Test.lnk -NoLaunch` created the requested install tree and desktop test shortcut. |
| Shortcut target check | Pass | The test shortcut target and working directory point at `artifacts\release\validation\installed-app`. |
| Shortcut launch with system PATH only | Pass | The shortcut launched `WangChenyangCalculator.exe` while child `PATH` contained only `%WINDIR%\System32;%WINDIR%`; the process remained running and was then closed. |

## Scope caveat

The PATH-restricted local launch supports the bundled-runtime claim, but it is not proof of the required independent clean Windows 10/11 environment. Independent testing must repeat the unpack/install and shortcut launch on a machine without Qt or MSVC development tooling, record any DLL error, and retain the command and outcome.
