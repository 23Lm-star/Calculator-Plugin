# Independent Test Evidence | M01-F03

Date: 2026-08-07

## Host characterization

- `qmake.exe`: `C:\ProgramData\Anaconda31\Library\bin\qmake.exe`
- `cl.exe`: not found
- Process `PATH`: no Qt or MSVC path segment detected.
- This is not an eligible clean-environment acceptance host because Anaconda provides `qmake`.

## Commands and outcomes

| Check | Command or method | Exit code | Outcome |
| --- | --- | --- | --- |
| Script parser | PowerShell AST parser for the three `scripts/release/*.ps1` files | 0 | Pass; zero parse errors for each script. |
| Engine regression | `build/v1.1-engine/release/engine_tests.exe` | 0 | Pass; output: `All CalculatorEngine tests passed.` |
| Artifact integrity | `Get-FileHash -Algorithm SHA256` and `System.IO.Compression.ZipFile::OpenRead` | 0 | Pass; hashes equal development evidence; portable ZIP has 50 entries, installer ZIP has 3 entries, no absolute/traversal archive entry. |
| Portable package content | Extract ZIP to task-scoped temporary evidence directory; inspect EXE, `platforms/qwindows.dll`, and text files | 0 | Pass; required files exist; 0 `E:\qt\project1` text leaks. |
| Installer flow | Extract installer ZIP; execute `Install-Calculator.ps1` with `-ExecutionPolicy Bypass`, isolated install directory and `-NoLaunch` | 0 | Pass; EXE and `platforms/qwindows.dll` installed; desktop shortcut target and working directory point to installed package. |
| Installer shortcut launch | Start the generated desktop shortcut; wait 4 seconds; stop test process | 0 | Pass; process ID `37896` remained running after 4 seconds. |
| Portable shortcut launch | Extract portable ZIP; execute `Create-DesktopShortcut.ps1`; start shortcut; wait 4 seconds; stop test process | 0 | Pass; process ID `14380` remained running after 4 seconds. |

## Artifact hashes

- `WangChenyangCalculator-1.1.0.zip`: `E6A86F36F7913E8B3B532352B9C26D461F281A0F2D93BDF40BA8D8F18C9F7F5A`
- `WangChenyangCalculator-1.1.0-Installer.zip`: `56BF1F3DBD5519C514FD625D397550374FE9CAF4CE3A9A0E13D2E3BB594FA148`

## Cleanup

Both temporary extraction/install directories under this evidence directory and both temporary desktop shortcuts (`M01F03-IndependentTest.lnk`, `M01F03-PortableIndependentTest.lnk`) were removed after the checks.

## Repair retest

- Command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File docs/ai-workflow/tasks/m01-f03-release-delivery-v1/evidence/independent-test/run-independent-validation.ps1`
- Exit code: `0`; `independent-validation.log` ends in `RESULT PASS` and JSON records every assertion.
- Evidence covers all three release scripts, ZIP entry safety, unapproved plugin/translation exclusion, and controlled drive-letter, UNC, and traversal text rejection.
- The desktop directory is read-only; VC branch tests use a process-local WScript Shell double for shortcut persistence. Portable EXE launch remains a real process check.
